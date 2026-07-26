-- Admin/staff may create bookings even when is_booking_enabled is false.
-- Run in Supabase SQL Editor (same body as migration 20260725000001).

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
