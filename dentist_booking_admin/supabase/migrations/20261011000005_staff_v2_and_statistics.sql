-- Staff management v2 + clinic statistics.
--
-- Staff accounts are created by the `manage-staff` Edge Function (email +
-- password, admin-only). Everything else goes through these admin-only RPCs.
-- Staff status is just active / inactive; shift_type is no longer used by the
-- apps (kept with a default so old admin app versions keep working).
-- Requires 20261011000004_permissions_and_rls (has_permission, staff.permissions).

ALTER TABLE public.staff
  ALTER COLUMN shift_type SET DEFAULT 'mixed';

-- =============================================================================
-- Staff RPCs (admin only)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.get_staff_members()
RETURNS TABLE(
  id uuid,
  user_id uuid,
  full_name text,
  email text,
  phone text,
  "position" public.staff_position,
  is_active boolean,
  permissions text[],
  last_seen timestamp with time zone,
  created_at timestamp with time zone,
  updated_at timestamp with time zone
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.require_admin();

  RETURN QUERY
  SELECT
    s.id,
    s.user_id,
    s.full_name,
    s.email,
    s.phone,
    s.position,
    (s.status = 'active' AND p.status = 'active') AS is_active,
    s.permissions,
    p.last_seen,
    s.created_at,
    s.updated_at
  FROM public.staff s
  JOIN public.profiles p ON p.user_id = s.user_id
  ORDER BY (s.status = 'active') DESC, s.full_name;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_staff_member(
  p_id uuid,
  p_full_name text,
  p_phone text,
  p_position public.staff_position,
  p_permissions text[]
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.require_admin();

  IF p_full_name IS NULL OR trim(p_full_name) = '' THEN
    RAISE EXCEPTION 'full_name_required' USING ERRCODE = '22023';
  END IF;

  UPDATE public.staff
  SET full_name = trim(p_full_name),
      phone = NULLIF(trim(p_phone), ''),
      position = p_position,
      permissions = (SELECT COALESCE(array_agg(DISTINCT x ORDER BY x), ARRAY[]::text[])
                     FROM unnest(COALESCE(p_permissions, ARRAY[]::text[])) AS x),
      updated_at = now()
  WHERE id = p_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'staff_not_found' USING ERRCODE = 'P0002';
  END IF;
END;
$$;

-- Active <-> inactive. Inactive staff keep their history but lose all access.
CREATE OR REPLACE FUNCTION public.set_staff_active(p_id uuid, p_active boolean)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id uuid;
  v_status public.account_status :=
    CASE WHEN p_active THEN 'active' ELSE 'inactive' END;
BEGIN
  PERFORM public.require_admin();

  SELECT s.user_id INTO v_user_id FROM public.staff s WHERE s.id = p_id;
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'staff_not_found' USING ERRCODE = 'P0002';
  END IF;

  UPDATE public.staff SET status = v_status, updated_at = now() WHERE id = p_id;
  -- The sync trigger only fires on change; make the profile match either way.
  UPDATE public.profiles SET status = v_status, updated_at = now()
  WHERE user_id = v_user_id AND status IS DISTINCT FROM v_status;
END;
$$;

REVOKE ALL ON FUNCTION public.get_staff_members() FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.update_staff_member(uuid, text, text, public.staff_position, text[]) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.set_staff_active(uuid, boolean) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_staff_members() TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_staff_member(uuid, text, text, public.staff_position, text[]) TO authenticated;
GRANT EXECUTE ON FUNCTION public.set_staff_active(uuid, boolean) TO authenticated;

-- =============================================================================
-- Statistics ('statistics' permission)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.get_clinic_statistics(p_from date, p_to date)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_from date := LEAST(p_from, p_to);
  v_to date := GREATEST(p_from, p_to);
  v_days integer;
  v_prev_from date;
  v_prev_to date;
  v_today date := public.clinic_now()::date;
  v_bookings jsonb;
  v_previous jsonb;
  v_daily jsonb;
  v_weekday jsonb;
  v_patients jsonb;
  v_today_stats jsonb;
  v_working_days integer;
BEGIN
  PERFORM public.require_permission('statistics');

  IF v_from IS NULL OR v_to IS NULL THEN
    RAISE EXCEPTION 'date_range_required' USING ERRCODE = '22023';
  END IF;
  IF v_to - v_from > 366 THEN
    RAISE EXCEPTION 'date_range_too_long' USING ERRCODE = '22023';
  END IF;

  v_days := (v_to - v_from) + 1;
  v_prev_to := v_from - 1;
  v_prev_from := v_from - v_days;

  -- Bookings in the period, with who created them (patient app vs clinic).
  WITH b AS (
    SELECT bk.*,
           COALESCE(cp.role IN ('admin', 'doctor', 'staff'), false) AS by_clinic
    FROM public.bookings bk
    LEFT JOIN public.profiles cp ON cp.user_id = bk.booking_created_by
    WHERE bk.booking_date::date BETWEEN v_from AND v_to
  )
  SELECT jsonb_build_object(
    'total', COUNT(*),
    'by_status', jsonb_build_object(
      'pending', COUNT(*) FILTER (WHERE booking_status = 'pending'),
      'confirmed', COUNT(*) FILTER (WHERE booking_status = 'confirmed'),
      'completed', COUNT(*) FILTER (WHERE booking_status = 'completed'),
      'no_show', COUNT(*) FILTER (WHERE booking_status = 'noShow'),
      'cancelled_by_patient', COUNT(*) FILTER (WHERE booking_status = 'cancelledByPatient'),
      'cancelled_by_staff', COUNT(*) FILTER (WHERE booking_status = 'cancelledByStaff')
    ),
    'by_shift', jsonb_build_object(
      'morning', COUNT(*) FILTER (WHERE shift = 'morning'),
      'evening', COUNT(*) FILTER (WHERE shift = 'evening')
    ),
    'by_source', jsonb_build_object(
      'patient_app', COUNT(*) FILTER (WHERE NOT by_clinic),
      'clinic', COUNT(*) FILTER (WHERE by_clinic)
    ),
    'for_others', COUNT(*) FILTER (
      WHERE NOT by_clinic AND guest_name IS NOT NULL AND trim(guest_name) <> ''
    ),
    'busiest_day', (
      SELECT jsonb_build_object('date', d, 'total', n)
      FROM (
        SELECT booking_date::date AS d, COUNT(*) AS n
        FROM b GROUP BY 1 ORDER BY 2 DESC, 1 DESC LIMIT 1
      ) x
    )
  )
  INTO v_bookings
  FROM b;

  SELECT jsonb_build_object(
    'total', COUNT(*),
    'completed', COUNT(*) FILTER (WHERE booking_status = 'completed'),
    'no_show', COUNT(*) FILTER (WHERE booking_status = 'noShow'),
    'cancelled', COUNT(*) FILTER (WHERE booking_status IN ('cancelledByPatient', 'cancelledByStaff'))
  )
  INTO v_previous
  FROM public.bookings
  WHERE booking_date::date BETWEEN v_prev_from AND v_prev_to;

  -- One row per calendar day (zeros included) for charts.
  SELECT COALESCE(jsonb_agg(jsonb_build_object(
           'date', d.day::date,
           'total', COALESCE(c.total, 0),
           'completed', COALESCE(c.completed, 0),
           'cancelled', COALESCE(c.cancelled, 0),
           'no_show', COALESCE(c.no_show, 0)
         ) ORDER BY d.day), '[]'::jsonb)
  INTO v_daily
  FROM generate_series(v_from::timestamp, v_to::timestamp, interval '1 day') AS d(day)
  LEFT JOIN (
    SELECT booking_date::date AS day,
           COUNT(*) AS total,
           COUNT(*) FILTER (WHERE booking_status = 'completed') AS completed,
           COUNT(*) FILTER (WHERE booking_status IN ('cancelledByPatient', 'cancelledByStaff')) AS cancelled,
           COUNT(*) FILTER (WHERE booking_status = 'noShow') AS no_show
    FROM public.bookings
    WHERE booking_date::date BETWEEN v_from AND v_to
    GROUP BY 1
  ) c ON c.day = d.day::date;

  -- Weekday distribution (clinic numbering: Saturday = 1 ... Friday = 7).
  SELECT COALESCE(jsonb_agg(jsonb_build_object(
           'day_of_week', w.dow,
           'total', w.total,
           'average', w.average
         ) ORDER BY w.dow), '[]'::jsonb)
  INTO v_weekday
  FROM (
    SELECT public.clinic_day_of_week(d.day::date) AS dow,
           COALESCE(SUM(c.total), 0) AS total,
           ROUND(COALESCE(SUM(c.total), 0)::numeric / COUNT(*), 1) AS average
    FROM generate_series(v_from::timestamp, v_to::timestamp, interval '1 day') AS d(day)
    LEFT JOIN (
      SELECT booking_date::date AS day, COUNT(*) AS total
      FROM public.bookings
      WHERE booking_date::date BETWEEN v_from AND v_to
      GROUP BY 1
    ) c ON c.day = d.day::date
    GROUP BY 1
  ) w;

  -- Days the clinic actually received bookings (for "average per working day").
  SELECT COUNT(DISTINCT booking_date::date)
  INTO v_working_days
  FROM public.bookings
  WHERE booking_date::date BETWEEN v_from AND v_to;

  SELECT jsonb_build_object(
    'registered_total', (SELECT COUNT(*) FROM public.profiles WHERE role = 'patient'),
    'new_in_period', (
      SELECT COUNT(*) FROM public.profiles
      WHERE role = 'patient'
        AND (created_at AT TIME ZONE 'Africa/Algiers')::date BETWEEN v_from AND v_to
    ),
    'active_in_period', (
      SELECT COUNT(DISTINCT patient_id) FROM public.bookings
      WHERE patient_id IS NOT NULL
        AND booking_date::date BETWEEN v_from AND v_to
    )
  )
  INTO v_patients;

  SELECT jsonb_build_object(
    'date', v_today,
    'total', COUNT(*),
    'waiting', COUNT(*) FILTER (WHERE booking_status IN ('pending', 'confirmed')),
    'completed', COUNT(*) FILTER (WHERE booking_status = 'completed'),
    'no_show', COUNT(*) FILTER (WHERE booking_status = 'noShow'),
    'cancelled', COUNT(*) FILTER (WHERE booking_status IN ('cancelledByPatient', 'cancelledByStaff')),
    'morning', COUNT(*) FILTER (WHERE shift = 'morning'),
    'evening', COUNT(*) FILTER (WHERE shift = 'evening')
  )
  INTO v_today_stats
  FROM public.bookings
  WHERE booking_date::date = v_today;

  RETURN jsonb_build_object(
    'period', jsonb_build_object(
      'from', v_from, 'to', v_to, 'days', v_days,
      'previous_from', v_prev_from, 'previous_to', v_prev_to,
      'working_days', v_working_days
    ),
    'bookings', v_bookings,
    'previous', v_previous,
    'daily', v_daily,
    'weekday', v_weekday,
    'patients', v_patients,
    'today', v_today_stats
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_clinic_statistics(date, date) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_clinic_statistics(date, date) TO authenticated;
