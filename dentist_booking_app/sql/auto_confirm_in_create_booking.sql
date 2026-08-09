-- Auto-confirm in create_booking (+ monotonic queue numbers)
-- Run in Supabase SQL Editor (Dashboard → SQL → New query → Run)
-- Prefer applying the migration:
-- dentist_booking_admin/supabase/migrations/20260809000002_monotonic_queue_number_per_shift.sql
--
-- When clinic_settings.auto_confirm is true, create_booking forces
-- booking_status to 'confirmed'. When false, uses p_booking_status.
-- Queue numbers continue across completed/cancelled/noShow for the same day+shift.

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
