-- Patient app: list current user's bookings for a date range.
--
-- Diagnosis (TIC-1685):
-- Raw row is valid: registered, patient_id = booking_created_by,
-- booking_date 2026-08-16, status confirmed, ticket TIC-1685.
-- Home + My Bookings both empty => shared source
-- get_all_bookings_with_filters_app (SECURITY INVOKER + RLS) failed to
-- return the row or failed parsing was swallowed as an empty list.
--
-- Fix: SECURITY DEFINER scoped strictly to auth.uid(), no client-supplied
-- user id. Bypasses RLS for read while still isolating to the session user.

CREATE OR REPLACE FUNCTION public.get_my_bookings_for_date_range(
  p_start_date date DEFAULT NULL,
  p_end_date date DEFAULT NULL,
  p_search_query text DEFAULT NULL
)
RETURNS TABLE(
  id uuid,
  booking_date timestamp without time zone,
  patient_id uuid,
  patient_type public.patient_type,
  patient_name text,
  patient_phone text,
  patient_address text,
  shift public.booking_shift,
  booking_status public.booking_status,
  booking_created_by uuid,
  queue_number text,
  ticket_code text,
  people_before integer,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  cancelled_at timestamp with time zone,
  completed_at timestamp with time zone,
  cancelled_by uuid,
  cancel_reason text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not_authenticated'
      USING ERRCODE = '42501';
  END IF;

  RETURN QUERY
  WITH my_bookings AS (
    SELECT b.*
    FROM public.bookings b
    WHERE b.patient_id = v_uid
      AND (
        (p_start_date IS NOT NULL AND p_end_date IS NOT NULL
          AND DATE(b.booking_date) BETWEEN p_start_date AND p_end_date)
        OR (p_start_date IS NULL AND p_end_date IS NULL)
      )
      AND (
        p_search_query IS NULL OR trim(p_search_query) = '' OR (
          b.ticket_code ILIKE '%' || p_search_query || '%'
          OR b.guest_name ILIKE '%' || p_search_query || '%'
          OR b.guest_phone ILIKE '%' || p_search_query || '%'
          OR b.guest_address ILIKE '%' || p_search_query || '%'
          OR EXISTS (
            SELECT 1
            FROM public.profiles p
            WHERE p.user_id = b.patient_id
              AND (
                p.meta -> 'raw_user_meta_data' ->> 'full_name'
                  ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'name' ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'phone' ILIKE '%' || p_search_query || '%'
                OR p.meta -> 'raw_user_meta_data' ->> 'phone'
                  ILIKE '%' || p_search_query || '%'
              )
          )
        )
      )
  )
  SELECT
    mb.id,
    mb.booking_date,
    mb.patient_id,
    mb.patient_type,
    COALESCE(
      NULLIF(TRIM(mb.guest_name), ''),
      p.meta -> 'raw_user_meta_data' ->> 'full_name',
      p.meta ->> 'name',
      'Unknown'
    ) AS patient_name,
    COALESCE(
      NULLIF(TRIM(mb.guest_phone), ''),
      p.meta ->> 'phone',
      p.meta -> 'raw_user_meta_data' ->> 'phone',
      ''
    ) AS patient_phone,
    COALESCE(
      NULLIF(TRIM(mb.guest_address), ''),
      p.meta -> 'raw_user_meta_data' ->> 'address',
      ''
    ) AS patient_address,
    mb.shift,
    mb.booking_status,
    mb.booking_created_by,
    LPAD(mb.queue_number::text, 4, '0') AS queue_number,
    mb.ticket_code::text,
    (
      SELECT COUNT(*)::integer
      FROM public.bookings b2
      WHERE DATE(b2.booking_date) = DATE(mb.booking_date)
        AND b2.shift = mb.shift
        AND b2.booking_status IN ('pending', 'confirmed')
        AND b2.queue_number < mb.queue_number
    ) AS people_before,
    mb.created_at,
    mb.updated_at,
    mb.cancelled_at,
    mb.completed_at,
    mb.cancelled_by,
    mb.cancel_reason::text
  FROM my_bookings mb
  LEFT JOIN public.profiles p ON p.user_id = mb.patient_id
  ORDER BY DATE(mb.booking_date) DESC, mb.shift, mb.queue_number ASC;
END;
$$;

REVOKE ALL ON FUNCTION public.get_my_bookings_for_date_range(date, date, text)
  FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_my_bookings_for_date_range(date, date, text)
  TO authenticated;

COMMENT ON FUNCTION public.get_my_bookings_for_date_range(date, date, text) IS
  'Returns bookings for auth.uid() only (SECURITY DEFINER). Used by patient app home + My Bookings.';
