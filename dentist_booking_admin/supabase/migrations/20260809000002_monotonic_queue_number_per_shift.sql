-- Monotonic queue numbers per day+shift.
-- Next queue_number = MAX(queue_number)+1 across ALL bookings for that day/shift
-- (including completed / cancelled / noShow), so numbers are never reused mid-day.
-- people_before and can_book capacity still count pending/confirmed only.

CREATE OR REPLACE FUNCTION public.next_queue_number_for_day_shift(
  p_day date,
  p_shift public.booking_shift,
  p_exclude_id uuid DEFAULT NULL
) RETURNS integer
  LANGUAGE sql
  STABLE
AS $$
  SELECT COALESCE(MAX(queue_number), 0) + 1
  FROM public.bookings
  WHERE DATE(booking_date) = p_day
    AND shift = p_shift
    AND queue_number IS NOT NULL
    AND (p_exclude_id IS NULL OR id <> p_exclude_id);
$$;

GRANT EXECUTE ON FUNCTION public.next_queue_number_for_day_shift(date, public.booking_shift, uuid)
  TO anon, authenticated, service_role;

-- =============================================================================
-- create_booking
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

-- =============================================================================
-- create_booking_app
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

  next_queue := public.next_queue_number_for_day_shift(booking_day, p_shift);

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

-- =============================================================================
-- update_booking (reassign queue when day/shift changes)
-- =============================================================================
CREATE OR REPLACE FUNCTION public.update_booking(
  p_id uuid,
  p_booking_date timestamp with time zone,
  p_patient_id uuid,
  p_patient_type public.patient_type,
  p_guest_name text,
  p_guest_phone text,
  p_guest_address text,
  p_shift public.booking_shift,
  p_booking_status public.booking_status,
  p_booking_created_by uuid,
  p_created_at timestamp with time zone,
  p_updated_at timestamp with time zone,
  p_cancelled_at timestamp with time zone DEFAULT NULL,
  p_completed_at timestamp with time zone DEFAULT NULL,
  p_cancelled_by uuid DEFAULT NULL,
  p_cancel_reason text DEFAULT NULL
) RETURNS jsonb
  LANGUAGE plpgsql
  AS $$
DECLARE
  check_result JSONB;
  old_booking bookings%ROWTYPE;
  updated_row bookings%ROWTYPE;
  new_queue_number INT;
  formatted_queue_number TEXT;
  result_data JSONB;
  booking_day DATE := DATE(p_booking_date);
  booking_timestamp TIMESTAMP;
BEGIN
  SELECT * INTO old_booking
  FROM bookings WHERE id = p_id;

  IF old_booking IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', 'booking_not_found'
    );
  END IF;

  booking_timestamp := p_booking_date::timestamp;

  IF DATE(old_booking.booking_date) != booking_day
     OR old_booking.shift != p_shift
     OR old_booking.patient_id != p_patient_id THEN

    check_result := can_book(
      booking_timestamp,
      p_shift,
      p_patient_type,
      p_patient_id
    );

    IF (check_result->>'can_book') = 'false' THEN
      RETURN jsonb_build_object(
        'success', false,
        'reason', check_result->>'reason'
      );
    END IF;
  END IF;

  IF DATE(old_booking.booking_date) != booking_day OR old_booking.shift != p_shift THEN
    new_queue_number := public.next_queue_number_for_day_shift(
      booking_day,
      p_shift,
      p_id
    );
  ELSE
    new_queue_number := old_booking.queue_number;
  END IF;

  formatted_queue_number := LPAD(new_queue_number::TEXT, 4, '0');

  UPDATE bookings
  SET
    booking_date = p_booking_date,
    patient_id = p_patient_id,
    patient_type = p_patient_type,
    guest_name = p_guest_name,
    guest_phone = p_guest_phone,
    guest_address = p_guest_address,
    shift = p_shift,
    booking_status = p_booking_status,
    booking_created_by = p_booking_created_by,
    queue_number = new_queue_number,
    created_at = p_created_at,
    updated_at = p_updated_at,
    cancelled_at = p_cancelled_at,
    completed_at = p_completed_at,
    cancelled_by = p_cancelled_by,
    cancel_reason = p_cancel_reason
  WHERE id = p_id
  RETURNING * INTO updated_row;

  result_data := jsonb_build_object(
    'id', updated_row.id,
    'booking_date', updated_row.booking_date,
    'patient_id', updated_row.patient_id,
    'patient_type', updated_row.patient_type,
    'guest_name', updated_row.guest_name,
    'guest_phone', updated_row.guest_phone,
    'guest_address', updated_row.guest_address,
    'shift', updated_row.shift,
    'booking_status', updated_row.booking_status,
    'booking_created_by', updated_row.booking_created_by,
    'queue_number', formatted_queue_number,
    'ticket_code', updated_row.ticket_code,
    'created_at', updated_row.created_at,
    'updated_at', updated_row.updated_at,
    'cancelled_at', updated_row.cancelled_at,
    'completed_at', updated_row.completed_at,
    'cancelled_by', updated_row.cancelled_by,
    'cancel_reason', updated_row.cancel_reason
  );

  RETURN jsonb_build_object(
    'success', true,
    'data', result_data
  );
END;
$$;

-- =============================================================================
-- update_booking_queue (reassign queue when day/shift changes)
-- =============================================================================
CREATE OR REPLACE FUNCTION public.update_booking_queue(
  p_id uuid,
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
  old_booking bookings%ROWTYPE;
  updated_row bookings%ROWTYPE;
  new_queue_number INT;
  formatted_queue_number TEXT;
  result_data JSONB;
  booking_day DATE := DATE(p_booking_date);
  booking_timestamp TIMESTAMP;
BEGIN
  SELECT * INTO old_booking
  FROM bookings WHERE id = p_id;

  IF old_booking IS NULL THEN
    RETURN jsonb_build_object('success', false, 'reason', 'booking_not_found');
  END IF;

  booking_timestamp := p_booking_date::timestamp;

  IF DATE(old_booking.booking_date) != booking_day
     OR old_booking.shift != p_shift
     OR old_booking.patient_id != p_patient_id THEN

    check_result := can_book(
      booking_timestamp,
      p_shift,
      p_patient_type,
      p_patient_id
    );

    IF (check_result->>'can_book') = 'false' THEN
      RETURN jsonb_build_object(
        'success', false,
        'reason', check_result->>'reason'
      );
    END IF;
  END IF;

  IF DATE(old_booking.booking_date) != booking_day
     OR old_booking.shift != p_shift THEN
    new_queue_number := public.next_queue_number_for_day_shift(
      booking_day,
      p_shift,
      p_id
    );
  ELSE
    new_queue_number := old_booking.queue_number;
  END IF;

  formatted_queue_number := LPAD(new_queue_number::TEXT, 4, '0');

  UPDATE bookings
  SET
    booking_date = p_booking_date,
    patient_id = p_patient_id,
    patient_type = p_patient_type,
    guest_name = p_guest_name,
    guest_phone = p_guest_phone,
    guest_address = p_guest_address,
    shift = p_shift,
    booking_status = p_booking_status,
    booking_created_by = p_booking_created_by,
    queue_number = new_queue_number,
    created_at = p_created_at,
    updated_at = p_updated_at,
    cancelled_at = p_cancelled_at,
    completed_at = p_completed_at,
    cancelled_by = p_cancelled_by,
    cancel_reason = p_cancel_reason
  WHERE id = p_id
  RETURNING * INTO updated_row;

  result_data := to_jsonb(updated_row) ||
    jsonb_build_object('queue_number', formatted_queue_number);

  RETURN jsonb_build_object('success', true, 'data', result_data);
END;
$$;
