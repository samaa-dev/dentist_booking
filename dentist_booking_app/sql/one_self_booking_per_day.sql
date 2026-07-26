-- One self-booking per day: update can_book, create_booking, create_booking_app
-- Run in Supabase SQL Editor or your PostgreSQL client

-- =============================================================================
-- 1) can_book: Remove section 9 (registered patient cannot book twice per day)
--    so users can have multiple bookings per day for others; self-booking limit
--    is enforced in create_booking / create_booking_app instead.
-- =============================================================================
CREATE OR REPLACE FUNCTION public.can_book(
  p_booking_datetime timestamp without time zone,
  p_shift public.booking_shift,
  p_patient_type public.patient_type,
  p_patient_id uuid DEFAULT NULL
) RETURNS jsonb
  LANGUAGE plpgsql
  AS $$
DECLARE
  v_booking_date date := DATE(p_booking_datetime);
  v_booking_time time := p_booking_datetime::time;
  iso INT;
  dow INT;
  wh RECORD;
  cs RECORD;
  existing_count INT;
  allowed_start TIME;
  allowed_end TIME;
  user_role public.user_role;
BEGIN
  SELECT public.current_user_role() INTO user_role;

  iso := EXTRACT(isodow FROM v_booking_date);
  dow := CASE
           WHEN iso = 6 THEN 1
           WHEN iso = 7 THEN 2
           ELSE iso + 2
         END;

  SELECT * INTO wh
  FROM working_hours
  WHERE day_of_week = dow;

  IF wh IS NULL THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'day_not_exist',
      'message', jsonb_build_object(
        'ar', 'اليوم المحدد غير متوفر للحجوزات',
        'en', 'The selected day is not available for bookings'
      )
    );
  END IF;

  IF NOT wh.is_open THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'clinic_closed',
      'message', jsonb_build_object(
        'ar', 'العيادة مغلقة في هذا اليوم',
        'en', 'Clinic is closed on this day'
      )
    );
  END IF;

  SELECT * INTO cs
  FROM clinic_settings
  WHERE id = 1;

  IF NOT cs.is_booking_enabled THEN
    -- Patients cannot book when disabled; admin/staff may still create bookings.
    IF user_role NOT IN ('admin', 'staff') THEN
      RETURN jsonb_build_object(
        'can_book', false,
        'reason', 'booking_disabled',
        'stop_reason', cs.stop_reason,
        'message', jsonb_build_object(
          'ar', COALESCE(NULLIF(trim(cs.stop_reason), ''), 'نظام الحجوزات معطل حالياً'),
          'en', COALESCE(NULLIF(trim(cs.stop_reason), ''), 'Booking system is currently disabled')
        )
      );
    END IF;
  END IF;

  IF p_shift = 'morning' THEN
    IF wh.morning_end IS NULL THEN
      RETURN jsonb_build_object(
        'can_book', false,
        'reason', 'invalid_working_hours',
        'message', jsonb_build_object(
          'ar', 'أوقات العمل غير محددة للفترة المحدد',
          'en', 'Working hours are not specified for the selected period'
        )
      );
    END IF;
    allowed_start := cs.booking_morning_start_time;
    allowed_end := wh.morning_end - (cs.allow_before_minutes * INTERVAL '1 minute');
    IF v_booking_time < allowed_start THEN
      RETURN jsonb_build_object(
        'can_book', false,
        'reason', 'too_early_morning',
        'message', jsonb_build_object(
          'ar', 'الحجز الصباحي يبدأ من الساعة ' || allowed_start || ' يرجى اختيار وقت لاحق',
          'en', 'Morning booking starts from ' || allowed_start || ' please choose a later time',
          'allowed_start', allowed_start
        )
      );
    END IF;
    IF v_booking_time > allowed_end THEN
      RETURN jsonb_build_object(
        'can_book', false,
        'reason', 'too_late_morning',
        'message', jsonb_build_object(
          'ar', 'لقد تجاوزت وقت الحجز الصباحي، يرجى التسجيل في المسائي',
          'en', 'You have exceeded the morning booking time, please register for the evening shift'
        )
      );
    END IF;
  END IF;

  IF p_shift = 'evening' THEN
    IF wh.evening_end IS NULL THEN
      RETURN jsonb_build_object(
        'can_book', false,
        'reason', 'invalid_working_hours',
        'message', jsonb_build_object(
          'ar', 'أوقات العمل غير محددة للفترة المحدد',
          'en', 'Working hours are not specified for the selected period'
        )
      );
    END IF;
    allowed_start := TIME '00:00';
    allowed_end := wh.evening_end - (cs.allow_before_minutes * INTERVAL '1 minute');
    IF v_booking_time < allowed_start THEN
      RETURN jsonb_build_object(
        'can_book', false,
        'reason', 'too_early_evening',
        'message', jsonb_build_object(
          'ar', 'وقت الحجز غير مناسب للفترة المسائية',
          'en', 'Booking time is not suitable for the evening period'
        )
      );
    END IF;
    IF v_booking_time > allowed_end THEN
      RETURN jsonb_build_object(
        'can_book', false,
        'reason', 'too_late_evening',
        'message', jsonb_build_object(
          'ar', 'لقد تجاوزت وقت الحجز المسائي',
          'en', 'You have exceeded the evening booking time'
        )
      );
    END IF;
  END IF;

  IF user_role IN ('admin','staff') THEN
    RETURN jsonb_build_object(
      'can_book', true,
      'reason', 'allowed_admin_staff',
      'message', jsonb_build_object(
        'ar', 'تم السماح للحجز (موظف/مدير)',
        'en', 'Booking allowed (staff/admin)'
      )
    );
  END IF;

  SELECT COUNT(*)
  INTO existing_count
  FROM bookings b
  WHERE DATE(b.booking_date) = v_booking_date
    AND b.shift = p_shift
    AND b.booking_status IN ('pending','confirmed')
    AND b.booking_created_by NOT IN (
        SELECT user_id FROM profiles WHERE role IN ('admin','staff')
    );

  IF p_shift = 'morning' AND existing_count >= cs.morning_count_limit THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'morning_full',
      'message', jsonb_build_object(
        'ar', 'لقد تم تعبئة الحجز الصباحي، يرجى التسجيل في المسائي',
        'en', 'Morning shift is full, please register for the evening shift'
      )
    );
  END IF;

  IF p_shift = 'evening' AND existing_count >= cs.evening_count_limit THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'evening_full',
      'message', jsonb_build_object(
        'ar', 'لقد تم تعبئة الحجز المسائي',
        'en', 'Evening shift is full'
      )
    );
  END IF;

  RETURN jsonb_build_object(
    'can_book', true,
    'reason', 'allowed',
    'message', jsonb_build_object(
      'ar', 'يمكنك المتابعة مع الحجز',
      'en', 'You can proceed with the booking'
    )
  );
END;
$$;

-- =============================================================================
-- 2) create_booking: Add one self-booking per day check (when guest_name empty)
-- =============================================================================
CREATE OR REPLACE FUNCTION public.create_booking(
  p_booking_date timestamp without time zone,
  p_patient_id uuid,
  p_patient_type public.patient_type,
  p_guest_name text,
  p_guest_phone text,
  p_guest_address text,
  p_shift public.booking_shift,
  p_booking_status public.booking_status,
  p_booking_created_by uuid,
  p_created_at timestamp without time zone,
  p_updated_at timestamp without time zone,
  p_cancelled_at timestamp without time zone,
  p_completed_at timestamp without time zone,
  p_cancelled_by uuid,
  p_cancel_reason text
) RETURNS jsonb
  LANGUAGE plpgsql
  AS $$
DECLARE
  check_result JSONB;
  new_booking bookings%ROWTYPE;
  next_queue INT;
  people_before_count INT;
  ticket_code_val VARCHAR(12);
  formatted_queue_number TEXT;
  result_data JSONB;
  booking_day DATE := DATE(p_booking_date);
  auto_confirm_enabled BOOLEAN;
  final_status public.booking_status;
BEGIN
  SELECT auto_confirm INTO auto_confirm_enabled
  FROM clinic_settings LIMIT 1;

  final_status := CASE
                    WHEN auto_confirm_enabled THEN 'confirmed'::public.booking_status
                    ELSE p_booking_status
                  END;

  check_result := can_book(p_booking_date, p_shift, p_patient_type, p_patient_id);

  IF (check_result->>'can_book') = 'false' THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', check_result->>'reason'
    );
  END IF;

  -- One self-booking per day: if this is a self-booking (no guest_name), reject if already exists
  IF (p_guest_name IS NULL OR trim(p_guest_name) = '') THEN
    IF EXISTS (
      SELECT 1 FROM bookings b
      WHERE b.patient_id = p_patient_id
        AND DATE(b.booking_date) = booking_day
        AND (b.guest_name IS NULL OR trim(b.guest_name) = '')
        AND b.booking_status IN ('pending', 'confirmed')
    ) THEN
      RETURN jsonb_build_object(
        'success', false,
        'reason', 'already_has_self_booking_today'
      );
    END IF;
  END IF;

  WITH existing_bookings AS (
    SELECT queue_number
    FROM bookings
    WHERE DATE(booking_date) = booking_day
      AND shift = p_shift
      AND booking_status IN ('pending','confirmed')
  )
  SELECT COALESCE(MAX(queue_number), 0) + 1
  INTO next_queue
  FROM existing_bookings;

  formatted_queue_number := LPAD(next_queue::TEXT, 4, '0');
  ticket_code_val := generate_unique_ticket_code();

  INSERT INTO bookings (
    booking_date, patient_id, patient_type, guest_name, guest_phone, guest_address,
    shift, booking_status, booking_created_by, queue_number, ticket_code,
    created_at, updated_at, cancelled_at, completed_at, cancelled_by, cancel_reason
  )
  VALUES (
    p_booking_date, p_patient_id, p_patient_type, p_guest_name, p_guest_phone, p_guest_address,
    p_shift, final_status, p_booking_created_by, next_queue, ticket_code_val,
    p_created_at, p_updated_at, p_cancelled_at, p_completed_at, p_cancelled_by, p_cancel_reason
  )
  RETURNING * INTO new_booking;

  SELECT COUNT(*)
  INTO people_before_count
  FROM bookings b2
  WHERE DATE(b2.booking_date) = booking_day
    AND b2.shift = new_booking.shift
    AND b2.booking_status IN ('pending','confirmed')
    AND b2.queue_number < new_booking.queue_number;

  result_data := jsonb_build_object(
    'id', new_booking.id,
    'booking_date', new_booking.booking_date,
    'patient_id', new_booking.patient_id,
    'patient_type', new_booking.patient_type,
    'guest_name', new_booking.guest_name,
    'guest_phone', new_booking.guest_phone,
    'guest_address', new_booking.guest_address,
    'shift', new_booking.shift,
    'booking_status', new_booking.booking_status,
    'booking_created_by', new_booking.booking_created_by,
    'queue_number', formatted_queue_number,
    'ticket_code', new_booking.ticket_code,
    'people_before', people_before_count,
    'created_at', new_booking.created_at,
    'updated_at', new_booking.updated_at,
    'cancelled_at', new_booking.cancelled_at,
    'completed_at', new_booking.completed_at,
    'cancelled_by', new_booking.cancelled_by,
    'cancel_reason', new_booking.cancel_reason
  );

  RETURN jsonb_build_object('success', true, 'data', result_data);
END;
$$;

-- =============================================================================
-- 3) create_booking_app: Add one self-booking per day check (always self)
-- =============================================================================
CREATE OR REPLACE FUNCTION public.create_booking_app(
  p_booking_date timestamp without time zone,
  p_shift public.booking_shift,
  p_patient_id uuid
) RETURNS jsonb
  LANGUAGE plpgsql
  AS $$
DECLARE
  auto_confirm_enabled BOOLEAN;
  final_status public.booking_status;
  new_booking bookings%ROWTYPE;
  next_queue INT;
  people_before_count INT;
  ticket_code_val VARCHAR(12);
  formatted_queue_number TEXT;
  result_data JSONB;
  booking_day DATE := DATE(p_booking_date);
  check_result JSONB;
BEGIN
  SELECT auto_confirm INTO auto_confirm_enabled
  FROM clinic_settings LIMIT 1;

  final_status := CASE
                    WHEN auto_confirm_enabled THEN 'confirmed'
                    ELSE 'pending'
                  END;

  check_result := can_book(p_booking_date, p_shift, 'registered', p_patient_id);

  IF NOT (check_result->>'can_book')::boolean THEN
    RETURN jsonb_build_object('success', false, 'reason', check_result->>'reason');
  END IF;

  -- One self-booking per day: create_booking_app always creates a self-booking
  IF EXISTS (
    SELECT 1 FROM bookings b
    WHERE b.patient_id = p_patient_id
      AND DATE(b.booking_date) = booking_day
      AND (b.guest_name IS NULL OR trim(b.guest_name) = '')
      AND b.booking_status IN ('pending', 'confirmed')
  ) THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', 'already_has_self_booking_today'
    );
  END IF;

  SELECT COALESCE(MAX(queue_number), 0) + 1 INTO next_queue
  FROM bookings
  WHERE DATE(booking_date) = booking_day
    AND shift = p_shift
    AND booking_status IN ('pending','confirmed');

  formatted_queue_number := LPAD(next_queue::TEXT, 4, '0');
  ticket_code_val := generate_unique_ticket_code();

  INSERT INTO bookings (
    booking_date, patient_id, patient_type, shift, booking_status,
    booking_created_by, queue_number, ticket_code, created_at, updated_at
  )
  VALUES (
    p_booking_date, p_patient_id, 'registered', p_shift, final_status,
    auth.uid(), next_queue, ticket_code_val, NOW(), NOW()
  )
  RETURNING * INTO new_booking;

  SELECT COUNT(*) INTO people_before_count
  FROM bookings b2
  WHERE DATE(b2.booking_date) = booking_day
    AND b2.shift = new_booking.shift
    AND b2.booking_status IN ('pending','confirmed')
    AND b2.queue_number < new_booking.queue_number;

  result_data := jsonb_build_object(
    'id', new_booking.id,
    'booking_date', new_booking.booking_date,
    'shift', new_booking.shift,
    'booking_status', new_booking.booking_status,
    'queue_number', formatted_queue_number,
    'ticket_code', new_booking.ticket_code,
    'people_before', people_before_count
  );

  RETURN jsonb_build_object('success', true, 'data', result_data);
END;
$$;
