-- Prefer bookings.guest_* over profile meta when resolving display name/phone/address.
-- Fixes "Unknown" for registered bookings where the real name is stored in guest_name
-- (admin create, book-for-another-person). Same pattern as queue_status / get_booking_tracking.

CREATE OR REPLACE FUNCTION public.get_all_bookings(
  p_start_date date DEFAULT NULL,
  p_end_date date DEFAULT NULL,
  p_specific_date date DEFAULT NULL
)
RETURNS TABLE(
  id uuid,
  booking_date timestamp with time zone,
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
LANGUAGE sql
AS $$
  WITH filtered_bookings AS (
    SELECT *
    FROM bookings b
    WHERE
      (p_specific_date IS NOT NULL AND DATE(b.booking_date) = p_specific_date)
      OR
      (p_start_date IS NOT NULL AND p_end_date IS NOT NULL
        AND DATE(b.booking_date) BETWEEN p_start_date AND p_end_date)
      OR
      (p_specific_date IS NULL AND p_start_date IS NULL AND p_end_date IS NULL)
  ),
  ranked AS (
    SELECT
      fb.*,
      ROW_NUMBER() OVER (
        PARTITION BY DATE(fb.booking_date), fb.shift
        ORDER BY fb.booking_date ASC
      ) AS rn,
      (
        ROW_NUMBER() OVER (
          PARTITION BY DATE(fb.booking_date), fb.shift
          ORDER BY fb.booking_date ASC
        ) - 1
      ) AS pb
    FROM filtered_bookings fb
  )
  SELECT
    r.id,
    r.booking_date,
    r.patient_id,
    r.patient_type,
    COALESCE(
      NULLIF(TRIM(r.guest_name), ''),
      p.meta -> 'raw_user_meta_data' ->> 'full_name',
      p.meta ->> 'name',
      'Unknown'
    ) AS patient_name,
    COALESCE(
      NULLIF(TRIM(r.guest_phone), ''),
      p.meta ->> 'phone',
      p.meta -> 'raw_user_meta_data' ->> 'phone',
      ''
    ) AS patient_phone,
    COALESCE(
      NULLIF(TRIM(r.guest_address), ''),
      p.meta -> 'raw_user_meta_data' ->> 'address',
      ''
    ) AS patient_address,
    r.shift,
    r.booking_status,
    r.booking_created_by,
    LPAD(r.queue_number::text, 4, '0') AS queue_number,
    r.ticket_code,
    r.pb AS people_before,
    r.created_at,
    r.updated_at,
    r.cancelled_at,
    r.completed_at,
    r.cancelled_by,
    r.cancel_reason
  FROM ranked r
  LEFT JOIN profiles p ON p.user_id = r.patient_id
  ORDER BY
    DATE(r.booking_date) DESC,
    r.shift,
    r.queue_number ASC;
$$;

CREATE OR REPLACE FUNCTION public.get_all_bookings_with_filters(
  p_start_date date DEFAULT NULL,
  p_end_date date DEFAULT NULL,
  p_specific_date date DEFAULT NULL,
  p_status public.booking_status DEFAULT NULL,
  p_shift public.booking_shift DEFAULT NULL,
  p_search_query text DEFAULT NULL
)
RETURNS TABLE(
  id uuid,
  booking_date timestamp with time zone,
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
LANGUAGE sql
AS $$
  WITH filtered_bookings AS (
    SELECT *
    FROM bookings b
    WHERE
      (
        (p_specific_date IS NOT NULL AND DATE(b.booking_date) = p_specific_date)
        OR
        (p_specific_date IS NULL AND p_start_date IS NOT NULL AND p_end_date IS NOT NULL
          AND DATE(b.booking_date) BETWEEN p_start_date AND p_end_date)
        OR
        (p_specific_date IS NULL AND p_start_date IS NULL AND p_end_date IS NULL)
      )
      AND (p_status IS NULL OR b.booking_status = p_status)
      AND (p_shift IS NULL OR b.shift = p_shift)
      AND (
        p_search_query IS NULL OR p_search_query = '' OR (
          (
            b.patient_type = 'registered' AND EXISTS (
              SELECT 1 FROM profiles p
              WHERE p.user_id = b.patient_id AND (
                p.meta -> 'raw_user_meta_data' ->> 'full_name' ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'name' ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'phone' ILIKE '%' || p_search_query || '%'
                OR p.meta -> 'raw_user_meta_data' ->> 'phone' ILIKE '%' || p_search_query || '%'
                OR p.meta -> 'raw_user_meta_data' ->> 'address' ILIKE '%' || p_search_query || '%'
              )
            )
          )
          OR
          (
            b.guest_name ILIKE '%' || p_search_query || '%'
            OR b.guest_phone ILIKE '%' || p_search_query || '%'
            OR b.guest_address ILIKE '%' || p_search_query || '%'
          )
          OR
          b.ticket_code ILIKE '%' || p_search_query || '%'
        )
      )
  ),
  ranked AS (
    SELECT
      fb.*,
      ROW_NUMBER() OVER (
        PARTITION BY DATE(fb.booking_date), fb.shift
        ORDER BY fb.booking_date ASC
      ) AS rn,
      (
        ROW_NUMBER() OVER (
          PARTITION BY DATE(fb.booking_date), fb.shift
          ORDER BY fb.booking_date ASC
        ) - 1
      ) AS pb
    FROM filtered_bookings fb
  )
  SELECT
    r.id,
    r.booking_date,
    r.patient_id,
    r.patient_type,
    COALESCE(
      NULLIF(TRIM(r.guest_name), ''),
      p.meta -> 'raw_user_meta_data' ->> 'full_name',
      p.meta ->> 'name',
      'Unknown'
    ) AS patient_name,
    COALESCE(
      NULLIF(TRIM(r.guest_phone), ''),
      p.meta ->> 'phone',
      p.meta -> 'raw_user_meta_data' ->> 'phone',
      ''
    ) AS patient_phone,
    COALESCE(
      NULLIF(TRIM(r.guest_address), ''),
      p.meta -> 'raw_user_meta_data' ->> 'address',
      ''
    ) AS patient_address,
    r.shift,
    r.booking_status,
    r.booking_created_by,
    LPAD(r.queue_number::text, 4, '0') AS queue_number,
    r.ticket_code,
    r.pb AS people_before,
    r.created_at,
    r.updated_at,
    r.cancelled_at,
    r.completed_at,
    r.cancelled_by,
    r.cancel_reason
  FROM ranked r
  LEFT JOIN profiles p ON p.user_id = r.patient_id
  ORDER BY
    DATE(r.booking_date) DESC,
    r.shift,
    r.queue_number ASC;
$$;

CREATE OR REPLACE FUNCTION public.get_all_bookings_with_filters_app(
  p_user_id uuid DEFAULT NULL,
  p_start_date date DEFAULT NULL,
  p_end_date date DEFAULT NULL,
  p_specific_date date DEFAULT NULL,
  p_status public.booking_status DEFAULT NULL,
  p_shift public.booking_shift DEFAULT NULL,
  p_search_query text DEFAULT NULL
)
RETURNS TABLE(
  id uuid,
  booking_date timestamp with time zone,
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
LANGUAGE sql
AS $$
  WITH filtered_bookings AS (
    SELECT *
    FROM bookings b
    WHERE
      (p_user_id IS NULL OR b.patient_id = p_user_id)
      AND (
        (p_specific_date IS NOT NULL AND DATE(b.booking_date) = p_specific_date)
        OR
        (p_specific_date IS NULL AND p_start_date IS NOT NULL AND p_end_date IS NOT NULL
          AND DATE(b.booking_date) BETWEEN p_start_date AND p_end_date)
        OR
        (p_specific_date IS NULL AND p_start_date IS NULL AND p_end_date IS NULL)
      )
      AND (p_status IS NULL OR b.booking_status = p_status)
      AND (p_shift IS NULL OR b.shift = p_shift)
      AND (
        p_search_query IS NULL OR p_search_query = '' OR (
          (
            b.patient_type = 'registered'
            AND EXISTS (
              SELECT 1 FROM profiles p
              WHERE p.user_id = b.patient_id AND (
                p.meta -> 'raw_user_meta_data' ->> 'full_name' ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'name' ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'phone' ILIKE '%' || p_search_query || '%'
                OR p.meta -> 'raw_user_meta_data' ->> 'phone' ILIKE '%' || p_search_query || '%'
                OR p.meta -> 'raw_user_meta_data' ->> 'address' ILIKE '%' || p_search_query || '%'
              )
            )
          )
          OR
          (
            b.guest_name ILIKE '%' || p_search_query || '%'
            OR b.guest_phone ILIKE '%' || p_search_query || '%'
            OR b.guest_address ILIKE '%' || p_search_query || '%'
          )
          OR
          b.ticket_code ILIKE '%' || p_search_query || '%'
        )
      )
  ),
  ranked AS (
    SELECT
      fb.*,
      ROW_NUMBER() OVER (
        PARTITION BY DATE(fb.booking_date), fb.shift
        ORDER BY fb.booking_date ASC
      ) - 1 AS pb
    FROM filtered_bookings fb
  )
  SELECT
    r.id,
    r.booking_date,
    r.patient_id,
    r.patient_type,
    COALESCE(
      NULLIF(TRIM(r.guest_name), ''),
      p.meta -> 'raw_user_meta_data' ->> 'full_name',
      p.meta ->> 'name',
      'Unknown'
    ) AS patient_name,
    COALESCE(
      NULLIF(TRIM(r.guest_phone), ''),
      p.meta ->> 'phone',
      p.meta -> 'raw_user_meta_data' ->> 'phone',
      ''
    ) AS patient_phone,
    COALESCE(
      NULLIF(TRIM(r.guest_address), ''),
      p.meta -> 'raw_user_meta_data' ->> 'address',
      ''
    ) AS patient_address,
    r.shift,
    r.booking_status,
    r.booking_created_by,
    LPAD(r.queue_number::text, 4, '0') AS queue_number,
    r.ticket_code,
    r.pb AS people_before,
    r.created_at,
    r.updated_at,
    r.cancelled_at,
    r.completed_at,
    r.cancelled_by,
    r.cancel_reason
  FROM ranked r
  LEFT JOIN profiles p ON p.user_id = r.patient_id
  ORDER BY DATE(r.booking_date) DESC, r.shift, r.queue_number ASC;
$$;
