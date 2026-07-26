-- Separate clinic open hours from booking-enabled flag, and expose stop_reason.

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

  -- is_open is based on working hours only (not is_booking_enabled).
  IF w IS NULL OR NOT w.is_open THEN
    RETURN jsonb_build_object(
      'is_open', false,
      'shift', null,
      'time_left', null,
      'is_booking_enabled', booking_enabled,
      'stop_reason', stop_reason_val
    );
  END IF;

  IF now_time BETWEEN cs.booking_morning_start_time
      AND (w.morning_end - INTERVAL '1 minute' * cs.allow_before_minutes) THEN
    shift := 'morning';
    end_time := w.morning_end - INTERVAL '1 minute' * cs.allow_before_minutes;
  ELSIF now_time BETWEEN w.evening_start
      AND (w.evening_end - INTERVAL '1 minute' * cs.allow_before_minutes) THEN
    shift := 'evening';
    end_time := w.evening_end - INTERVAL '1 minute' * cs.allow_before_minutes;
  ELSE
    RETURN jsonb_build_object(
      'is_open', false,
      'shift', null,
      'time_left', null,
      'is_booking_enabled', booking_enabled,
      'stop_reason', stop_reason_val
    );
  END IF;

  diff_minutes := EXTRACT(EPOCH FROM (end_time - now_time)) / 60;

  result := jsonb_build_object(
    'is_open', true,
    'shift', shift,
    'time_left', diff_minutes,
    'is_booking_enabled', booking_enabled,
    'stop_reason', stop_reason_val
  );

  RETURN result;
END;
$$;
