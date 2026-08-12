-- Capacity limit: count ALL bookings for day+shift except cancelled.
-- Admin/staff still bypass via can_book early return.
-- get_booking_status exposes shift_full so patient app can disable booking UI.

CREATE OR REPLACE FUNCTION public.count_bookings_for_day_shift(
  p_booking_date date,
  p_shift public.booking_shift
) RETURNS integer
LANGUAGE sql
STABLE
AS $$
  SELECT COUNT(*)::int
  FROM bookings b
  WHERE DATE(b.booking_date) = p_booking_date
    AND b.shift = p_shift
    AND b.booking_status NOT IN ('cancelledByPatient', 'cancelledByStaff');
$$;

CREATE OR REPLACE FUNCTION public.get_booking_status(
  p_datetime timestamp without time zone
) RETURNS jsonb
LANGUAGE plpgsql
AS $$
DECLARE
  w RECORD;
  cs RECORD;
  now_time TIME := p_datetime::time;
  today_date DATE := p_datetime::date;
  iso INT := EXTRACT(isodow FROM today_date);
  dow INT;
  result jsonb;
  shift TEXT;
  end_time TIME;
  diff_minutes INT;
  booking_enabled BOOLEAN;
  stop_reason_val TEXT;
  existing_count INT;
BEGIN
  dow := CASE
           WHEN iso = 6 THEN 1
           WHEN iso = 7 THEN 2
           ELSE iso + 2
         END;

  SELECT * INTO w
  FROM working_hours
  WHERE day_of_week = dow;

  SELECT * INTO cs
  FROM clinic_settings
  LIMIT 1;

  booking_enabled := COALESCE(cs.is_booking_enabled, false);
  stop_reason_val := NULLIF(trim(cs.stop_reason), '');

  IF w IS NULL OR NOT w.is_open THEN
    RETURN jsonb_build_object(
      'is_open', false,
      'shift', null,
      'time_left', null,
      'is_booking_enabled', booking_enabled,
      'stop_reason', stop_reason_val,
      'shift_closed', null,
      'shift_full', null
    );
  END IF;

  IF now_time BETWEEN cs.booking_morning_start_time
      AND (w.morning_end - INTERVAL '1 minute' * cs.allow_before_minutes) THEN
    IF NOT COALESCE(w.morning_is_open, TRUE) THEN
      RETURN jsonb_build_object(
        'is_open', false,
        'shift', 'morning',
        'time_left', null,
        'is_booking_enabled', booking_enabled,
        'stop_reason', stop_reason_val,
        'shift_closed', 'morning',
        'shift_full', null
      );
    END IF;
    shift := 'morning';
    end_time := w.morning_end - INTERVAL '1 minute' * cs.allow_before_minutes;
  ELSIF now_time BETWEEN w.evening_start
      AND (w.evening_end - INTERVAL '1 minute' * cs.allow_before_minutes) THEN
    IF NOT COALESCE(w.evening_is_open, TRUE) THEN
      RETURN jsonb_build_object(
        'is_open', false,
        'shift', 'evening',
        'time_left', null,
        'is_booking_enabled', booking_enabled,
        'stop_reason', stop_reason_val,
        'shift_closed', 'evening',
        'shift_full', null
      );
    END IF;
    shift := 'evening';
    end_time := w.evening_end - INTERVAL '1 minute' * cs.allow_before_minutes;
  ELSE
    RETURN jsonb_build_object(
      'is_open', false,
      'shift', null,
      'time_left', null,
      'is_booking_enabled', booking_enabled,
      'stop_reason', stop_reason_val,
      'shift_closed', null,
      'shift_full', null
    );
  END IF;

  existing_count := public.count_bookings_for_day_shift(
    today_date,
    shift::public.booking_shift
  );

  IF shift = 'morning' AND existing_count >= cs.morning_count_limit THEN
    RETURN jsonb_build_object(
      'is_open', false,
      'shift', 'morning',
      'time_left', null,
      'is_booking_enabled', booking_enabled,
      'stop_reason', stop_reason_val,
      'shift_closed', null,
      'shift_full', 'morning'
    );
  END IF;

  IF shift = 'evening' AND existing_count >= cs.evening_count_limit THEN
    RETURN jsonb_build_object(
      'is_open', false,
      'shift', 'evening',
      'time_left', null,
      'is_booking_enabled', booking_enabled,
      'stop_reason', stop_reason_val,
      'shift_closed', null,
      'shift_full', 'evening'
    );
  END IF;

  diff_minutes := EXTRACT(EPOCH FROM (end_time - now_time)) / 60;

  result := jsonb_build_object(
    'is_open', true,
    'shift', shift,
    'time_left', diff_minutes,
    'is_booking_enabled', booking_enabled,
    'stop_reason', stop_reason_val,
    'shift_closed', null,
    'shift_full', null
  );

  RETURN result;
END;
$$;

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

  SELECT * INTO cs
  FROM clinic_settings
  WHERE id = 1;

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

  IF p_shift = 'morning' AND NOT COALESCE(wh.morning_is_open, TRUE) THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'morning_closed',
      'message', jsonb_build_object(
        'ar', 'الفترة الصباحية مغلقة في هذا اليوم',
        'en', 'Morning shift is closed on this day'
      )
    );
  END IF;

  IF p_shift = 'evening' AND NOT COALESCE(wh.evening_is_open, TRUE) THEN
    RETURN jsonb_build_object(
      'can_book', false,
      'reason', 'evening_closed',
      'message', jsonb_build_object(
        'ar', 'الفترة المسائية مغلقة في هذا اليوم',
        'en', 'Evening shift is closed on this day'
      )
    );
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
