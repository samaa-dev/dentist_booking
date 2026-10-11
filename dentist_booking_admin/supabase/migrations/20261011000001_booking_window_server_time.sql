-- Daily booking window: server-authoritative clinic time + "next opening".
--
-- Rules (patients only; admin/staff keep their bypass in can_book):
--   * Nothing is bookable before clinic_settings.booking_morning_start_time,
--     neither morning nor evening (evening used to be open from 00:00).
--   * Morning: [booking_start, morning_end] when the day + morning shift are open.
--   * Evening: [booking_start, evening_end - allow_before_minutes] when the
--     day + evening shift are open.
--   * Capacity limits still apply per shift.
--   * Time comes from the server in the clinic timezone (clinic_settings.timezone),
--     never from the patient's phone clock.
--   * get_booking_status returns next_open_at: the next moment booking opens
--     (today at booking_start, or the next working day, skipping closed days).

-- =============================================================================
-- Clinic timezone + helpers
-- =============================================================================

ALTER TABLE public.clinic_settings
  ADD COLUMN IF NOT EXISTS timezone text NOT NULL DEFAULT 'Africa/Algiers';

COMMENT ON COLUMN public.clinic_settings.timezone IS
  'IANA timezone of the clinic (e.g. Africa/Algiers). Used by clinic_now().';

CREATE OR REPLACE FUNCTION public.clinic_now()
RETURNS timestamp without time zone
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_tz text;
BEGIN
  SELECT NULLIF(trim(cs.timezone), '')
  INTO v_tz
  FROM clinic_settings cs
  WHERE cs.id = 1;

  BEGIN
    RETURN date_trunc('second', now() AT TIME ZONE COALESCE(v_tz, 'Africa/Algiers'));
  EXCEPTION
    WHEN invalid_parameter_value THEN
      RETURN date_trunc('second', now() AT TIME ZONE 'Africa/Algiers');
  END;
END;
$$;

GRANT EXECUTE ON FUNCTION public.clinic_now() TO authenticated, anon;

COMMENT ON FUNCTION public.clinic_now() IS
  'Current wall-clock time in the clinic timezone (timestamp without time zone).';

-- working_hours.day_of_week: Saturday = 1 ... Friday = 7
CREATE OR REPLACE FUNCTION public.clinic_day_of_week(p_date date)
RETURNS integer
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT CASE EXTRACT(isodow FROM p_date)::integer
           WHEN 6 THEN 1
           WHEN 7 THEN 2
           ELSE EXTRACT(isodow FROM p_date)::integer + 2
         END;
$$;

-- Patient booking window for one day + shift.
-- Returns NULLs when that shift cannot be booked at all on that day.
CREATE OR REPLACE FUNCTION public.shift_booking_window(
  p_date date,
  p_shift public.booking_shift,
  OUT window_start time,
  OUT window_end time
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  w RECORD;
  cs RECORD;
BEGIN
  SELECT * INTO cs FROM clinic_settings WHERE id = 1;
  IF NOT FOUND OR cs.booking_morning_start_time IS NULL THEN
    RETURN;
  END IF;

  SELECT * INTO w
  FROM working_hours
  WHERE day_of_week = public.clinic_day_of_week(p_date);
  IF NOT FOUND OR NOT COALESCE(w.is_open, false) THEN
    RETURN;
  END IF;

  IF p_shift = 'morning' THEN
    IF NOT COALESCE(w.morning_is_open, true) OR w.morning_end IS NULL THEN
      RETURN;
    END IF;
    window_end := w.morning_end;
  ELSE
    IF NOT COALESCE(w.evening_is_open, true) OR w.evening_end IS NULL THEN
      RETURN;
    END IF;
    window_end := w.evening_end
      - make_interval(mins => COALESCE(cs.allow_before_minutes, 0));
  END IF;

  window_start := cs.booking_morning_start_time;

  IF window_end < window_start THEN
    window_start := NULL;
    window_end := NULL;
  END IF;
END;
$$;

-- Next moment patient booking opens strictly after p_now
-- (today at booking start if still ahead, else the next bookable day).
CREATE OR REPLACE FUNCTION public.next_booking_open_at(
  p_now timestamp without time zone
)
RETURNS timestamp without time zone
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  d date;
  mw RECORD;
  ew RECORD;
  v_start time;
  i integer;
BEGIN
  FOR i IN 0..14 LOOP
    d := p_now::date + i;
    SELECT * INTO mw FROM public.shift_booking_window(d, 'morning');
    SELECT * INTO ew FROM public.shift_booking_window(d, 'evening');

    v_start := LEAST(mw.window_start, ew.window_start);
    IF v_start IS NOT NULL AND (d + v_start) > p_now THEN
      RETURN d + v_start;
    END IF;
  END LOOP;

  RETURN NULL;
END;
$$;

-- =============================================================================
-- get_booking_status: p_datetime kept for old clients but ignored.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.get_booking_status(
  p_datetime timestamp without time zone
) RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_now timestamp without time zone := public.clinic_now();
  today_date date := v_now::date;
  now_time time := v_now::time;
  w RECORD;
  cs RECORD;
  mw RECORD;
  ew RECORD;
  day_open boolean;
  booking_enabled boolean;
  stop_reason_val text;
  booking_start time;
  morning_start_str text;
  morning_open boolean;
  evening_open boolean;
  morning_full boolean := false;
  evening_full boolean := false;
  morning_in_window boolean;
  evening_in_window boolean;
  morning_available boolean;
  evening_available boolean;
  any_available boolean;
  shift_val text;
  end_time time;
  diff_minutes integer;
  shift_closed_val text;
  shift_full_val text;
  next_open timestamp without time zone;
BEGIN
  SELECT * INTO cs FROM clinic_settings WHERE id = 1;

  booking_enabled := COALESCE(cs.is_booking_enabled, false);
  stop_reason_val := NULLIF(trim(cs.stop_reason), '');
  booking_start := cs.booking_morning_start_time;
  morning_start_str := to_char(booking_start, 'HH24:MI');

  SELECT * INTO w
  FROM working_hours
  WHERE day_of_week = public.clinic_day_of_week(today_date);
  day_open := FOUND AND COALESCE(w.is_open, false);

  SELECT * INTO mw FROM public.shift_booking_window(today_date, 'morning');
  SELECT * INTO ew FROM public.shift_booking_window(today_date, 'evening');

  morning_in_window := COALESCE(now_time BETWEEN mw.window_start AND mw.window_end, false);
  evening_in_window := COALESCE(now_time BETWEEN ew.window_start AND ew.window_end, false);

  IF day_open THEN
    morning_full := COALESCE(
      public.count_bookings_for_day_shift(today_date, 'morning') >= cs.morning_count_limit,
      false
    );
    evening_full := COALESCE(
      public.count_bookings_for_day_shift(today_date, 'evening') >= cs.evening_count_limit,
      false
    );
  END IF;

  morning_available := morning_in_window AND NOT morning_full;
  evening_available := evening_in_window AND NOT evening_full;
  any_available := morning_available OR evening_available;

  -- Shift shown in the UI: the bookable one first, else the one whose window is active.
  IF morning_available THEN
    shift_val := 'morning';
    end_time := mw.window_end;
  ELSIF evening_available THEN
    shift_val := 'evening';
    end_time := ew.window_end;
  ELSIF morning_in_window THEN
    shift_val := 'morning';
    end_time := mw.window_end;
  ELSIF evening_in_window THEN
    shift_val := 'evening';
    end_time := ew.window_end;
  END IF;

  -- A shift explicitly closed today while booking hours are running.
  IF day_open AND booking_start IS NOT NULL AND now_time >= booking_start THEN
    morning_open := COALESCE(w.morning_is_open, true);
    evening_open := COALESCE(w.evening_is_open, true);
    IF NOT morning_open AND w.morning_end IS NOT NULL AND now_time <= w.morning_end THEN
      shift_closed_val := 'morning';
    ELSIF NOT evening_open AND w.evening_end IS NOT NULL AND now_time <= w.evening_end THEN
      shift_closed_val := 'evening';
    END IF;
  END IF;

  -- Legacy shift_full: only when no remaining bookable shift.
  IF NOT any_available THEN
    IF morning_full AND evening_full THEN
      shift_full_val := COALESCE(shift_val, 'morning');
    ELSIF morning_full AND morning_in_window THEN
      shift_full_val := 'morning';
    ELSIF evening_full AND evening_in_window THEN
      shift_full_val := 'evening';
    END IF;
  END IF;

  IF any_available AND end_time IS NOT NULL THEN
    diff_minutes := (EXTRACT(EPOCH FROM (end_time - now_time)) / 60)::integer;
  END IF;

  IF NOT any_available THEN
    next_open := public.next_booking_open_at(v_now);
  END IF;

  RETURN jsonb_build_object(
    'is_open', any_available,
    'shift', CASE WHEN day_open THEN shift_val END,
    'time_left', diff_minutes,
    'is_booking_enabled', booking_enabled,
    'stop_reason', stop_reason_val,
    'shift_closed', shift_closed_val,
    'shift_full', shift_full_val,
    'morning_full', morning_full,
    'evening_full', evening_full,
    'morning_available', morning_available,
    'evening_available', evening_available,
    'booking_morning_start_time', morning_start_str,
    'server_now', to_char(v_now, 'YYYY-MM-DD"T"HH24:MI:SS'),
    'next_open_at', to_char(next_open, 'YYYY-MM-DD"T"HH24:MI:SS'),
    'next_open_in_days', (next_open::date - today_date)
  );
END;
$$;

-- =============================================================================
-- can_book: patients are checked against clinic_now(), not the client clock.
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
  v_now timestamp without time zone;
  v_booking_date date;
  v_booking_time time;
  wh RECORD;
  cs RECORD;
  existing_count int;
  allowed_start time;
  allowed_end time;
  allowed_start_str text;
  user_role public.user_role;
BEGIN
  SELECT public.current_user_role() INTO user_role;

  IF user_role IN ('admin', 'staff') THEN
    RETURN jsonb_build_object(
      'can_book', true,
      'reason', 'allowed_admin_staff',
      'message', jsonb_build_object(
        'ar', 'تم السماح للحجز (موظف/مدير)',
        'en', 'Booking allowed (staff/admin)'
      )
    );
  END IF;

  -- Patients can only book "now": ignore the client-supplied timestamp.
  v_now := public.clinic_now();
  v_booking_date := v_now::date;
  v_booking_time := v_now::time;

  SELECT * INTO wh
  FROM working_hours
  WHERE day_of_week = public.clinic_day_of_week(v_booking_date);

  IF NOT FOUND THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'day_not_exist',
      'message', jsonb_build_object(
        'ar', 'اليوم المحدد غير متوفر للحجوزات',
        'en', 'The selected day is not available for bookings'
      )
    );
  END IF;

  SELECT * INTO cs FROM clinic_settings WHERE id = 1;

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

  IF NOT cs.is_booking_enabled THEN
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

  IF p_shift = 'morning' AND NOT COALESCE(wh.morning_is_open, true) THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'morning_closed',
      'message', jsonb_build_object(
        'ar', 'الفترة الصباحية مغلقة في هذا اليوم',
        'en', 'Morning shift is closed on this day'
      )
    );
  END IF;

  IF p_shift = 'evening' AND NOT COALESCE(wh.evening_is_open, true) THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'evening_closed',
      'message', jsonb_build_object(
        'ar', 'الفترة المسائية مغلقة في هذا اليوم',
        'en', 'Evening shift is closed on this day'
      )
    );
  END IF;

  IF (p_shift = 'morning' AND wh.morning_end IS NULL)
     OR (p_shift = 'evening' AND wh.evening_end IS NULL) THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'invalid_working_hours',
      'message', jsonb_build_object(
        'ar', 'أوقات العمل غير محددة للفترة المحدد',
        'en', 'Working hours are not specified for the selected period'
      )
    );
  END IF;

  -- Daily booking opening time applies to both shifts.
  allowed_start := cs.booking_morning_start_time;
  allowed_start_str := to_char(allowed_start, 'HH24:MI');
  IF v_booking_time < allowed_start THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', CASE WHEN p_shift = 'morning' THEN 'too_early_morning' ELSE 'too_early_evening' END,
      'allowed_start', allowed_start_str,
      'message', jsonb_build_object(
        'ar', 'الحجز يبدأ من الساعة ' || allowed_start_str,
        'en', 'Booking opens at ' || allowed_start_str,
        'allowed_start', allowed_start_str
      )
    );
  END IF;

  IF p_shift = 'morning' THEN
    allowed_end := wh.morning_end;
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
  ELSE
    allowed_end := wh.evening_end - make_interval(mins => COALESCE(cs.allow_before_minutes, 0));
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

  existing_count := public.count_bookings_for_day_shift(v_booking_date, p_shift);

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
-- create_booking: patients get booking_date = clinic_now(); failures carry
-- message + allowed_start so the app can show the opening time.
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
  booking_day DATE;
  auto_confirm_enabled BOOLEAN;
  final_status public.booking_status;
  profile_meta JSONB;
  resolved_patient_name TEXT;
  v_role public.user_role;
BEGIN
  SELECT public.current_user_role() INTO v_role;

  -- Patients always book for the current clinic time (phone clock is not trusted).
  IF v_role IS NULL OR v_role NOT IN ('admin', 'staff') THEN
    p_booking_date := public.clinic_now();
  END IF;
  booking_day := DATE(p_booking_date);

  SELECT auto_confirm INTO auto_confirm_enabled
  FROM clinic_settings LIMIT 1;

  final_status := CASE
                    WHEN auto_confirm_enabled THEN 'confirmed'::public.booking_status
                    ELSE p_booking_status
                  END;

  -- Require identity + resolvable display name before any insert
  IF p_patient_type = 'registered' AND p_patient_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', 'patient_name_required',
      'message', jsonb_build_object(
        'ar', 'يجب اختيار مريض مسجل يحتوي على اسم',
        'en', 'A registered patient with a name is required'
      )
    );
  END IF;

  IF p_patient_type = 'guest'
     AND (p_guest_name IS NULL OR trim(p_guest_name) = '') THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', 'patient_name_required',
      'message', jsonb_build_object(
        'ar', 'يجب إدخال اسم المريض',
        'en', 'Patient name is required'
      )
    );
  END IF;

  profile_meta := NULL;
  IF p_patient_id IS NOT NULL THEN
    SELECT meta INTO profile_meta
    FROM profiles
    WHERE user_id = p_patient_id;
  END IF;

  resolved_patient_name := COALESCE(
    NULLIF(TRIM(p_guest_name), ''),
    profile_meta -> 'raw_user_meta_data' ->> 'full_name',
    profile_meta ->> 'name'
  );

  IF resolved_patient_name IS NULL OR trim(resolved_patient_name) = '' THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', 'patient_name_required',
      'message', jsonb_build_object(
        'ar', 'يجب إدخال اسم المريض',
        'en', 'Patient name is required'
      )
    );
  END IF;

  check_result := can_book(p_booking_date, p_shift, p_patient_type, p_patient_id);

  IF (check_result->>'can_book') = 'false' THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', check_result->>'reason',
      'message', check_result->'message',
      'allowed_start', check_result->>'allowed_start'
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

  next_queue := public.next_queue_number_for_day_shift(booking_day, p_shift);

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
