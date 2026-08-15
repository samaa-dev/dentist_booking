-- Per-shift capacity in get_booking_status:
-- Keep booking open when at least one shift is still bookable.
-- Report morning_full / evening_full and morning_available / evening_available.
-- can_book remains the write-time enforcement (unchanged).

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
  shift TEXT;
  end_time TIME;
  diff_minutes INT;
  booking_enabled BOOLEAN;
  stop_reason_val TEXT;
  morning_count INT;
  evening_count INT;
  morning_full BOOLEAN;
  evening_full BOOLEAN;
  morning_open BOOLEAN;
  evening_open BOOLEAN;
  morning_in_window BOOLEAN;
  evening_in_window BOOLEAN;
  morning_available BOOLEAN;
  evening_available BOOLEAN;
  any_available BOOLEAN;
  shift_closed_val TEXT;
  shift_full_val TEXT;
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
      'shift_full', null,
      'morning_full', false,
      'evening_full', false,
      'morning_available', false,
      'evening_available', false
    );
  END IF;

  morning_count := public.count_bookings_for_day_shift(today_date, 'morning'::public.booking_shift);
  evening_count := public.count_bookings_for_day_shift(today_date, 'evening'::public.booking_shift);
  morning_full := morning_count >= cs.morning_count_limit;
  evening_full := evening_count >= cs.evening_count_limit;
  morning_open := COALESCE(w.morning_is_open, TRUE);
  evening_open := COALESCE(w.evening_is_open, TRUE);

  -- Same windows as can_book / previous get_booking_status
  morning_in_window := now_time BETWEEN cs.booking_morning_start_time
      AND (w.morning_end - INTERVAL '1 minute' * cs.allow_before_minutes);
  evening_in_window := now_time BETWEEN TIME '00:00'
      AND (w.evening_end - INTERVAL '1 minute' * cs.allow_before_minutes);

  -- Clock display shift (current active window for UI label)
  IF now_time BETWEEN cs.booking_morning_start_time
      AND (w.morning_end - INTERVAL '1 minute' * cs.allow_before_minutes) THEN
    shift := 'morning';
    end_time := w.morning_end - INTERVAL '1 minute' * cs.allow_before_minutes;
  ELSIF now_time BETWEEN w.evening_start
      AND (w.evening_end - INTERVAL '1 minute' * cs.allow_before_minutes) THEN
    shift := 'evening';
    end_time := w.evening_end - INTERVAL '1 minute' * cs.allow_before_minutes;
  ELSE
    shift := null;
    end_time := null;
  END IF;

  -- Bookable shifts for patients (aligned with can_book time windows)
  morning_available := morning_open
    AND NOT morning_full
    AND morning_in_window
    AND w.morning_end IS NOT NULL;

  evening_available := evening_open
    AND NOT evening_full
    AND evening_in_window
    AND w.evening_end IS NOT NULL;

  any_available := morning_available OR evening_available;

  shift_closed_val := null;
  IF shift = 'morning' AND NOT morning_open THEN
    shift_closed_val := 'morning';
  ELSIF shift = 'evening' AND NOT evening_open THEN
    shift_closed_val := 'evening';
  END IF;

  -- Legacy shift_full: only when no remaining bookable shift (blocks old clients)
  shift_full_val := null;
  IF NOT any_available THEN
    IF morning_full AND evening_full THEN
      shift_full_val := COALESCE(shift, 'morning');
    ELSIF morning_full THEN
      shift_full_val := 'morning';
    ELSIF evening_full THEN
      shift_full_val := 'evening';
    END IF;
  END IF;

  IF end_time IS NOT NULL THEN
    diff_minutes := EXTRACT(EPOCH FROM (end_time - now_time)) / 60;
  ELSE
    diff_minutes := null;
  END IF;

  RETURN jsonb_build_object(
    'is_open', any_available,
    'shift', shift,
    'time_left', CASE WHEN any_available THEN diff_minutes ELSE null END,
    'is_booking_enabled', booking_enabled,
    'stop_reason', stop_reason_val,
    'shift_closed', shift_closed_val,
    'shift_full', shift_full_val,
    'morning_full', morning_full,
    'evening_full', evening_full,
    'morning_available', morning_available,
    'evening_available', evening_available
  );
END;
$$;
