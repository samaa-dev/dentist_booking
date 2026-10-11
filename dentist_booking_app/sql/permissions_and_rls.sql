-- Permission system + Row Level Security for the core tables.
--
-- Roles:  admin / doctor = full access.  staff = only the permissions granted
--         in staff.permissions.  patient = own data only.
-- Permissions: bookings, queue, patients, announcements, statistics, settings.
--         Staff management stays admin-only (require_admin).
--
-- All client RPCs run as SECURITY DEFINER and check the caller first, so the
-- tables themselves can be locked down with RLS (no direct client writes,
-- reads limited to the caller's own rows unless they hold a permission).
-- Old admin app versions keep working: RPC names/signatures are unchanged.
-- Requires 20261011000003_security_hotfix_admin_only (require_admin).

-- =============================================================================
-- Staff permissions
-- =============================================================================

ALTER TABLE public.staff
  ADD COLUMN IF NOT EXISTS permissions text[] NOT NULL
    DEFAULT ARRAY['bookings', 'queue']::text[];

ALTER TABLE public.staff
  DROP CONSTRAINT IF EXISTS staff_permissions_valid;
ALTER TABLE public.staff
  ADD CONSTRAINT staff_permissions_valid CHECK (
    permissions <@ ARRAY['bookings', 'queue', 'patients', 'announcements',
                         'statistics', 'settings']::text[]
  );

-- Existing staff keep what the admin apps already showed them.
UPDATE public.staff
SET permissions = ARRAY['bookings', 'queue', 'announcements', 'statistics']::text[]
WHERE permissions = ARRAY['bookings', 'queue']::text[];

COMMENT ON COLUMN public.staff.permissions IS
  'Granted permissions: bookings, queue, patients, announcements, statistics, settings.';

-- =============================================================================
-- Permission helpers
-- =============================================================================

CREATE OR REPLACE FUNCTION public.has_permission(p_permission text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.user_id = auth.uid()
      AND p.status = 'active'
      AND (
        p.role IN ('admin', 'doctor')
        OR (
          p.role = 'staff'
          AND EXISTS (
            SELECT 1
            FROM public.staff s
            WHERE s.user_id = p.user_id
              AND s.status = 'active'
              AND p_permission = ANY (s.permissions)
          )
        )
      )
  );
$$;

CREATE OR REPLACE FUNCTION public.require_permission(p_permission text)
RETURNS void
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.has_permission(p_permission) THEN
    RAISE EXCEPTION 'forbidden: missing permission %', p_permission
      USING ERRCODE = '42501';
  END IF;
END;
$$;

-- What the signed-in user may do (used by the admin apps to build navigation).
CREATE OR REPLACE FUNCTION public.get_my_access()
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_role public.user_role;
  v_status public.account_status;
  v_permissions text[] := ARRAY[]::text[];
  v_all text[] := ARRAY['bookings', 'queue', 'patients', 'announcements',
                        'statistics', 'settings'];
BEGIN
  SELECT p.role, p.status INTO v_role, v_status
  FROM public.profiles p
  WHERE p.user_id = auth.uid();

  IF v_role IN ('admin', 'doctor') AND v_status = 'active' THEN
    v_permissions := v_all;
  ELSIF v_role = 'staff' AND v_status = 'active' THEN
    SELECT COALESCE(s.permissions, ARRAY[]::text[]) INTO v_permissions
    FROM public.staff s
    WHERE s.user_id = auth.uid()
      AND s.status = 'active';
  END IF;

  RETURN jsonb_build_object(
    'role', v_role,
    'status', v_status,
    'is_admin', COALESCE(v_role IN ('admin', 'doctor') AND v_status = 'active', false),
    'permissions', to_jsonb(COALESCE(v_permissions, ARRAY[]::text[]))
  );
END;
$$;

REVOKE ALL ON FUNCTION public.has_permission(text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.require_permission(text) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_my_access() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.has_permission(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.require_permission(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_my_access() TO authenticated;

-- =============================================================================
-- Existing RPCs: production bodies + permission guard, run as SECURITY DEFINER
-- =============================================================================

CREATE OR REPLACE FUNCTION public.get_all_bookings(p_start_date date DEFAULT NULL::date, p_end_date date DEFAULT NULL::date, p_specific_date date DEFAULT NULL::date)
 RETURNS TABLE(id uuid, booking_date timestamp with time zone, patient_id uuid, patient_type patient_type, patient_name text, patient_phone text, patient_address text, shift booking_shift, booking_status booking_status, booking_created_by uuid, queue_number text, ticket_code text, people_before integer, created_at timestamp with time zone, updated_at timestamp with time zone, cancelled_at timestamp with time zone, completed_at timestamp with time zone, cancelled_by uuid, cancel_reason text)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT public.require_permission('bookings');

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
$function$;

CREATE OR REPLACE FUNCTION public.get_all_bookings_with_filters(p_start_date date DEFAULT NULL::date, p_end_date date DEFAULT NULL::date, p_specific_date date DEFAULT NULL::date, p_status booking_status DEFAULT NULL::booking_status, p_shift booking_shift DEFAULT NULL::booking_shift, p_search_query text DEFAULT NULL::text)
 RETURNS TABLE(id uuid, booking_date timestamp with time zone, patient_id uuid, patient_type patient_type, patient_name text, patient_phone text, patient_address text, shift booking_shift, booking_status booking_status, booking_created_by uuid, queue_number text, ticket_code text, people_before integer, created_at timestamp with time zone, updated_at timestamp with time zone, cancelled_at timestamp with time zone, completed_at timestamp with time zone, cancelled_by uuid, cancel_reason text)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT public.require_permission('bookings');

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
$function$;

CREATE OR REPLACE FUNCTION public.update_booking(p_id uuid, p_booking_date timestamp with time zone, p_patient_id uuid, p_patient_type patient_type, p_guest_name text, p_guest_phone text, p_guest_address text, p_shift booking_shift, p_booking_status booking_status, p_booking_created_by uuid, p_created_at timestamp with time zone, p_updated_at timestamp with time zone, p_cancelled_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_completed_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_cancelled_by uuid DEFAULT NULL::uuid, p_cancel_reason text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
  PERFORM public.require_permission('bookings');
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
$function$;

CREATE OR REPLACE FUNCTION public.update_booking_queue(p_id uuid, p_booking_date timestamp without time zone, p_patient_id uuid, p_patient_type patient_type, p_guest_name text, p_guest_phone text, p_guest_address text, p_shift booking_shift, p_booking_status booking_status, p_booking_created_by uuid, p_created_at timestamp without time zone, p_updated_at timestamp without time zone, p_cancelled_at timestamp without time zone, p_completed_at timestamp without time zone, p_cancelled_by uuid, p_cancel_reason text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
  PERFORM public.require_permission('bookings');
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
$function$;

CREATE OR REPLACE FUNCTION public.delete_booking(p_booking_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  exists_count int;
begin
  PERFORM public.require_permission('bookings');
  -- تحقق: هل الحجز موجود؟
  select count(*) into exists_count
  from bookings
  where id = p_booking_id;

  if exists_count = 0 then
    return jsonb_build_object(
      'success', false,
      'reason', 'booking_not_found'
    );
  end if;

  -- تنفيذ حذف الحجز
  delete from bookings
  where id = p_booking_id;

  return jsonb_build_object(
    'success', true,
    'reason', 'deleted'
  );
end;
$function$;

CREATE OR REPLACE FUNCTION public.queue_next(p_datetime timestamp without time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  qs RECORD;
  next_booking RECORD;
  current_shift booking_shift;
  now_time TIME := p_datetime::time;
  today_date DATE := p_datetime::date;

  wh RECORD;
  iso INT := EXTRACT(isodow FROM today_date);
  dow INT;
  morning_cur INT;
  evening_cur INT;
  morning_undrained BOOLEAN := false;
  evening_undrained BOOLEAN := false;
BEGIN
  PERFORM public.require_permission('queue');
  dow := CASE
           WHEN iso = 6 THEN 1
           WHEN iso = 7 THEN 2
           ELSE iso + 2
         END;

  SELECT * INTO wh FROM working_hours WHERE day_of_week = dow;

  IF wh IS NULL OR wh.is_open = FALSE THEN
    RETURN jsonb_build_object('success',false,'code','CLINIC_CLOSED');
  END IF;

  SELECT COALESCE(current_queue_number, 0) INTO morning_cur
  FROM queue_state WHERE shift = 'morning';
  IF NOT FOUND THEN morning_cur := 0; END IF;

  SELECT COALESCE(current_queue_number, 0) INTO evening_cur
  FROM queue_state WHERE shift = 'evening';
  IF NOT FOUND THEN evening_cur := 0; END IF;

  SELECT EXISTS (
    SELECT 1 FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = 'morning'
      AND booking_status = 'confirmed'
      AND (
        morning_cur = 0
        OR queue_number >= morning_cur
      )
  ) INTO morning_undrained;

  SELECT EXISTS (
    SELECT 1 FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = 'evening'
      AND booking_status = 'confirmed'
      AND (
        evening_cur = 0
        OR queue_number >= evening_cur
      )
  ) INTO evening_undrained;

  IF now_time BETWEEN wh.morning_start AND wh.morning_end THEN
    current_shift := 'morning';
  ELSIF now_time BETWEEN wh.evening_start AND wh.evening_end THEN
    current_shift := 'evening';
  ELSIF morning_undrained THEN
    current_shift := 'morning';
  ELSIF evening_undrained THEN
    current_shift := 'evening';
  ELSE
    RETURN jsonb_build_object('success',false,'code','OUT_OF_WORKING_HOURS');
  END IF;

  SELECT * INTO qs FROM queue_state WHERE shift = current_shift;

  IF qs IS NULL THEN
    INSERT INTO queue_state (shift, current_queue_number, is_paused)
    VALUES (current_shift, 0, false)
    RETURNING * INTO qs;
  END IF;

  IF qs.updated_at IS NOT NULL AND (qs.updated_at)::date < today_date THEN
    UPDATE queue_state
    SET current_queue_number = 0, updated_at = NOW()
    WHERE shift = current_shift;
    SELECT * INTO qs FROM queue_state WHERE shift = current_shift;
  END IF;

  IF qs.is_paused THEN
    RETURN jsonb_build_object('success',false,'code','QUEUE_PAUSED');
  END IF;

  SELECT *
  INTO next_booking
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number > qs.current_queue_number
    AND booking_status = 'confirmed'
  ORDER BY queue_number ASC
  LIMIT 1;

  IF next_booking IS NULL THEN
    RETURN jsonb_build_object('success',false,'code','NO_MORE_BOOKINGS');
  END IF;

  UPDATE queue_state
  SET current_queue_number = next_booking.queue_number,
      updated_at = NOW()
  WHERE shift = current_shift;

  RETURN jsonb_build_object(
    'success', true,
    'code', 'NEXT_OK',
    'booking', to_jsonb(next_booking),
    'shift', current_shift
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.queue_pause(p_shift booking_shift)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public.require_permission('queue');
  UPDATE queue_state
  SET is_paused = TRUE, updated_at = NOW()
  WHERE shift = p_shift;

  RETURN jsonb_build_object('success', true, 'message', 'Queue paused');
END;
$function$;

CREATE OR REPLACE FUNCTION public.queue_resume(p_shift booking_shift)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public.require_permission('queue');
  UPDATE queue_state
  SET is_paused = FALSE, updated_at = NOW()
  WHERE shift = p_shift;

  RETURN jsonb_build_object('success', true, 'message', 'Queue resumed');
END;
$function$;

CREATE OR REPLACE FUNCTION public.queue_restart(p_shift booking_shift)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public.require_permission('queue');
  -- إعادة تعيين current_queue_number إلى 0
  UPDATE queue_state
  SET current_queue_number = 0,
      is_paused = false,
      updated_at = NOW()
  WHERE shift = p_shift;

  -- إذا لم يكن هناك سجل، قم بإنشائه
  IF NOT FOUND THEN
    INSERT INTO queue_state (shift, current_queue_number, is_paused)
    VALUES (p_shift, 0, false);
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Queue restarted successfully'
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.get_all_patients()
 RETURNS TABLE(user_id uuid, meta jsonb, role user_role, status account_status, created_at timestamp with time zone, updated_at timestamp with time zone, last_seen timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$BEGIN
  IF NOT (public.has_permission('patients') OR public.has_permission('bookings')) THEN
    RAISE EXCEPTION 'forbidden: missing permission patients' USING ERRCODE = '42501';
  END IF;
  -- 🔐 السماح فقط للإدمن باستدعاء الدالة
  -- IF NOT public.is_admin_user() THEN
  --   RAISE EXCEPTION 'Access denied: only admin can view patient list';
  -- END IF;

  -- ✔ إرجاع المستخدمين الذين role = 'patient'
  RETURN QUERY
    SELECT
      p.user_id,
      p.meta,
      p.role,
      p.status,
      p.created_at,
      p.updated_at,
      p.last_seen
    FROM public.profiles p
    WHERE p.role = 'patient'::public.user_role
    ORDER BY p.last_seen DESC;

END;$function$;

CREATE OR REPLACE FUNCTION public.get_all_announcements()
 RETURNS TABLE(id uuid, title text, body text, link_url text, audience announcement_audience, images jsonb, is_active boolean, created_by_user_id uuid, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT public.require_permission('announcements');

  SELECT 
    a.id,
    a.title,
    a.body,
    a.link_url, 
    a.audience::public.announcement_audience,
    a.images,
    a.is_active,
    a.created_by_user_id,
    a.created_at,
    a.updated_at
  FROM public.announcements a
  ORDER BY a.created_at DESC;
$function$;

CREATE OR REPLACE FUNCTION public.create_announcement(p_title text, p_body text, p_link_url text, p_audience announcement_audience, p_images jsonb, p_is_active boolean, p_created_by_user_id uuid)
 RETURNS announcements
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$DECLARE
  new_row announcements;
BEGIN
  PERFORM public.require_permission('announcements');
  INSERT INTO announcements (
    title,
    body,
    link_url,
    audience,
    images,
    is_active,
    created_by_user_id
  )
  VALUES (
    p_title,
    p_body,
    p_link_url,
    p_audience,
    p_images,
    p_is_active,
    p_created_by_user_id
  )
  RETURNING * INTO new_row;

  RETURN new_row;
END;$function$;

CREATE OR REPLACE FUNCTION public.update_announcement(p_id uuid, p_title text, p_body text, p_link_url text, p_audience announcement_audience, p_images jsonb, p_is_active boolean, p_updated_by_user_id uuid)
 RETURNS announcements
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  updated_row announcements;
BEGIN
  PERFORM public.require_permission('announcements');
  UPDATE announcements
  SET
    title = p_title,
    body = p_body,
    link_url = p_link_url,
    audience = p_audience,
    images = p_images,
    is_active = p_is_active,
    updated_at = NOW(),
    created_by_user_id = p_updated_by_user_id
  WHERE id = p_id
  RETURNING * INTO updated_row;

  RETURN updated_row;
END;
$function$;

CREATE OR REPLACE FUNCTION public.delete_announcement(p_id uuid)
 RETURNS TABLE(deleted_id uuid)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public.require_permission('announcements');
  RETURN QUERY
  DELETE FROM announcements
  WHERE id = p_id
  RETURNING id;
END;
$function$;

CREATE OR REPLACE FUNCTION public.get_dashboard_stats()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
declare
  -- Daily stats
  total_bookings_today int := 0;
  confirmed_today int := 0;
  cancelled_today int := 0;
  no_show_today int := 0;
  new_patients_today int := 0;
  total_staff int := 0;
  active_announcements int := 0;

  -- Weekly stats
  weekly_counts int[] := '{}';

  -- Today summary (working hours)
  v_morning_start time;
  v_morning_end   time;
  v_evening_start time;
  v_evening_end   time;

  -- Clinic settings
  v_morning_limit int := 10;
  v_evening_limit int := 10;

  -- Load ratio
  v_limit int := 0;
  load_ratio numeric := 0;

  -- Today day of week
  dow int := extract(isodow from now());
begin
  PERFORM public.require_permission('statistics');
  ---------------------------------------------------------------------------
  -- DAILY STATS
  ---------------------------------------------------------------------------
  select count(*) into total_bookings_today
  from bookings
  where booking_date = current_date;

  select count(*) into confirmed_today
  from bookings
  where booking_date = current_date
    and booking_status = 'confirmed';

  select count(*) into cancelled_today
  from bookings
  where booking_date = current_date
    and booking_status in ('cancelledByPatient','cancelledByStaff');

  select count(*) into no_show_today
  from bookings
  where booking_date = current_date
    and booking_status = 'noShow';

  select count(*) into new_patients_today
  from profiles
  where role = 'patient'
    and created_at::date = current_date;

  select count(*) into total_staff
  from staff;

  select count(*) into active_announcements
  from announcements
  where is_active = true;

  ---------------------------------------------------------------------------
  -- WEEKLY BOOKINGS (Sat → Fri)
  ---------------------------------------------------------------------------
  weekly_counts := array[]::int[];

  for x in 1..7 loop
    weekly_counts := array_append(
      weekly_counts,
      (
        select count(*)
        from bookings
        where booking_date = (current_date - ((7 - x))::int)
      )
    );
  end loop;

  ---------------------------------------------------------------------------
  -- TODAY WORKING HOURS
  ---------------------------------------------------------------------------
  select wh.morning_start, wh.morning_end,
         wh.evening_start, wh.evening_end
  into v_morning_start, v_morning_end,
       v_evening_start, v_evening_end
  from working_hours wh
  where wh.day_of_week = dow
  limit 1;

  ---------------------------------------------------------------------------
  -- CLINIC SETTINGS (morning + evening limits)
  ---------------------------------------------------------------------------
  select morning_limit, evening_limit
  into v_morning_limit, v_evening_limit
  from clinic_settings
  where id = 1
  limit 1;

  ---------------------------------------------------------------------------
  -- LOAD RATIO (Dynamic)
  ---------------------------------------------------------------------------
  if now()::time between v_morning_start and v_morning_end then
    v_limit := v_morning_limit;
  elsif now()::time between v_evening_start and v_evening_end then
    v_limit := v_evening_limit;
  else
    v_limit := v_morning_limit + v_evening_limit;
  end if;

  load_ratio := total_bookings_today::numeric / nullif(v_limit, 0);

  ---------------------------------------------------------------------------
  -- RETURN JSON
  ---------------------------------------------------------------------------
  return jsonb_build_object(
    'daily', jsonb_build_object(
      'total_bookings_today', total_bookings_today,
      'confirmed_today', confirmed_today,
      'cancelled_today', cancelled_today,
      'no_show_today', no_show_today,
      'new_patients_today', new_patients_today,
      'total_staff', total_staff,
      'active_announcements', active_announcements
    ),

    'weekly', jsonb_build_object(
      'counts', weekly_counts
    ),

    'today_summary', jsonb_build_object(
      'morning_start', v_morning_start,
      'morning_end', v_morning_end,
      'evening_start', v_evening_start,
      'evening_end', v_evening_end,
      'load_ratio', load_ratio
    )
  );
end;
$function$;

CREATE OR REPLACE FUNCTION public.save_clinic_config(p_settings jsonb, p_hours jsonb)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_permission('settings');
  perform update_clinic_settings(
    (p_settings->>'morning_count_limit')::int,
    (p_settings->>'evening_count_limit')::int,
    (p_settings->>'is_booking_enabled')::boolean,
    (p_settings->>'booking_morning_start_time')::time,
    (p_settings->>'allow_before_minutes')::int,
    (p_settings->>'auto_confirm')::boolean,
    (p_settings->>'stop_reason')::text,
    nullif(trim(p_settings->>'clinic_phone'), '')::text,
    nullif(trim(p_settings->>'ticket_note'), '')::text,
    nullif(trim(p_settings->>'min_version_patient'), '')::text,
    nullif(trim(p_settings->>'min_version_admin'), '')::text,
    nullif(trim(p_settings->>'min_version_desktop'), '')::text,
    nullif(trim(p_settings->>'min_version_tv'), '')::text,
    -- Only overwrite min versions when the payload includes at least one key
    (p_settings ? 'min_version_patient'
      OR p_settings ? 'min_version_admin'
      OR p_settings ? 'min_version_desktop'
      OR p_settings ? 'min_version_tv')
  );
  perform update_working_hours(p_hours);
end;
$function$;

CREATE OR REPLACE FUNCTION public.update_clinic_settings(p_morning_count_limit integer, p_evening_count_limit integer, p_is_booking_enabled boolean, p_booking_morning_start_time time without time zone, p_allow_before_minutes integer, p_auto_confirm boolean, p_stop_reason text, p_clinic_phone text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_permission('settings');
  update clinic_settings set
    morning_count_limit = p_morning_count_limit,
    evening_count_limit = p_evening_count_limit,
    is_booking_enabled = p_is_booking_enabled,
    booking_morning_start_time = p_booking_morning_start_time,
    allow_before_minutes = p_allow_before_minutes,
    auto_confirm = p_auto_confirm,
    stop_reason = p_stop_reason,
    clinic_phone = p_clinic_phone,
    updated_at = now()
  where id = 1;
end;
$function$;

CREATE OR REPLACE FUNCTION public.update_clinic_settings(p_morning_count_limit integer, p_evening_count_limit integer, p_is_booking_enabled boolean, p_booking_morning_start_time time without time zone, p_allow_before_minutes integer, p_auto_confirm boolean, p_stop_reason text, p_clinic_phone text DEFAULT NULL::text, p_ticket_note text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_permission('settings');
  update clinic_settings set
    morning_count_limit = p_morning_count_limit,
    evening_count_limit = p_evening_count_limit,
    is_booking_enabled = p_is_booking_enabled,
    booking_morning_start_time = p_booking_morning_start_time,
    allow_before_minutes = p_allow_before_minutes,
    auto_confirm = p_auto_confirm,
    stop_reason = p_stop_reason,
    clinic_phone = p_clinic_phone,
    ticket_note = p_ticket_note,
    updated_at = now()
  where id = 1;
end;
$function$;

CREATE OR REPLACE FUNCTION public.update_clinic_settings(p_morning_count_limit integer, p_evening_count_limit integer, p_is_booking_enabled boolean, p_booking_morning_start_time time without time zone, p_allow_before_minutes integer, p_auto_confirm boolean, p_stop_reason text, p_clinic_phone text DEFAULT NULL::text, p_ticket_note text DEFAULT NULL::text, p_min_version_patient text DEFAULT NULL::text, p_min_version_admin text DEFAULT NULL::text, p_min_version_desktop text DEFAULT NULL::text, p_min_version_tv text DEFAULT NULL::text, p_update_min_versions boolean DEFAULT false)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_permission('settings');
  update clinic_settings set
    morning_count_limit = p_morning_count_limit,
    evening_count_limit = p_evening_count_limit,
    is_booking_enabled = p_is_booking_enabled,
    booking_morning_start_time = p_booking_morning_start_time,
    allow_before_minutes = p_allow_before_minutes,
    auto_confirm = p_auto_confirm,
    stop_reason = p_stop_reason,
    clinic_phone = p_clinic_phone,
    ticket_note = p_ticket_note,
    min_version_patient = CASE
      WHEN p_update_min_versions THEN nullif(trim(p_min_version_patient), '')
      ELSE min_version_patient
    END,
    min_version_admin = CASE
      WHEN p_update_min_versions THEN nullif(trim(p_min_version_admin), '')
      ELSE min_version_admin
    END,
    min_version_desktop = CASE
      WHEN p_update_min_versions THEN nullif(trim(p_min_version_desktop), '')
      ELSE min_version_desktop
    END,
    min_version_tv = CASE
      WHEN p_update_min_versions THEN nullif(trim(p_min_version_tv), '')
      ELSE min_version_tv
    END,
    updated_at = now()
  where id = 1;
end;
$function$;

CREATE OR REPLACE FUNCTION public.update_working_hours(p_hours jsonb)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  item jsonb;
BEGIN
  PERFORM public.require_permission('settings');
  FOR item IN SELECT * FROM jsonb_array_elements(p_hours)
  LOOP
    UPDATE working_hours
    SET
      is_open = (item->>'is_open')::boolean,
      morning_start = (item->>'morning_start')::time,
      morning_end = (item->>'morning_end')::time,
      evening_start = (item->>'evening_start')::time,
      evening_end = (item->>'evening_end')::time,
      morning_is_open = COALESCE((item->>'morning_is_open')::boolean, TRUE),
      evening_is_open = COALESCE((item->>'evening_is_open')::boolean, TRUE),
      updated_at = now()
    WHERE id = (item->>'id')::uuid;
  END LOOP;
END;
$function$;

CREATE OR REPLACE FUNCTION public.create_booking(p_booking_date timestamp without time zone, p_patient_id uuid, p_patient_type patient_type, p_guest_name text, p_guest_phone text, p_guest_address text, p_shift booking_shift, p_booking_status booking_status, p_booking_created_by uuid, p_created_at timestamp without time zone, p_updated_at timestamp without time zone, p_cancelled_at timestamp without time zone, p_completed_at timestamp without time zone, p_cancelled_by uuid, p_cancel_reason text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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

  IF v_role IN ('admin', 'doctor', 'staff') THEN
    PERFORM public.require_permission('bookings');
  ELSE
    IF auth.uid() IS NULL THEN
      RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '42501';
    END IF;
    -- Patients book for themselves, at the current clinic time, as pending
    -- (phone clock and client-supplied ids/status are not trusted).
    p_booking_date := public.clinic_now();
    p_patient_id := auth.uid();
    p_booking_created_by := auth.uid();
    p_booking_status := 'pending';
    p_cancelled_at := NULL;
    p_completed_at := NULL;
    p_cancelled_by := NULL;
    p_cancel_reason := NULL;
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
$function$;

CREATE OR REPLACE FUNCTION public.queue_status(p_datetime timestamp with time zone)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  now_time TIME := p_datetime::time;
  today_date DATE := p_datetime::date;

  wh RECORD;
  qs RECORD;
  nb RECORD;
  next_nb RECORD;
  result_booking JSONB;
  next_result_booking JSONB;
  v_waiting_count INT;

  iso INT := EXTRACT(isodow FROM today_date);
  dow INT;
  current_shift booking_shift;
  morning_cur INT;
  evening_cur INT;
  morning_undrained BOOLEAN := false;
  evening_undrained BOOLEAN := false;
BEGIN
  dow := CASE
    WHEN iso = 6 THEN 1
    WHEN iso = 7 THEN 2
    ELSE iso + 2
  END;

  SELECT * INTO wh FROM working_hours WHERE day_of_week = dow;

  IF wh IS NULL OR wh.is_open = FALSE THEN
    RETURN jsonb_build_object('state','CLOSED','message','Clinic is closed today');
  END IF;

  SELECT COALESCE(current_queue_number, 0) INTO morning_cur
  FROM queue_state WHERE shift = 'morning';
  IF NOT FOUND THEN morning_cur := 0; END IF;

  SELECT COALESCE(current_queue_number, 0) INTO evening_cur
  FROM queue_state WHERE shift = 'evening';
  IF NOT FOUND THEN evening_cur := 0; END IF;

  SELECT EXISTS (
    SELECT 1 FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = 'morning'
      AND booking_status = 'confirmed'
      AND (
        morning_cur = 0
        OR queue_number >= morning_cur
      )
  ) INTO morning_undrained;

  SELECT EXISTS (
    SELECT 1 FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = 'evening'
      AND booking_status = 'confirmed'
      AND (
        evening_cur = 0
        OR queue_number >= evening_cur
      )
  ) INTO evening_undrained;

  IF now_time BETWEEN wh.morning_start AND wh.morning_end THEN
    current_shift := 'morning';
  ELSIF now_time BETWEEN wh.evening_start AND wh.evening_end THEN
    current_shift := 'evening';
  ELSIF morning_undrained THEN
    current_shift := 'morning';
  ELSIF evening_undrained THEN
    current_shift := 'evening';
  ELSE
    RETURN jsonb_build_object('state','OUT_OF_WORKING_HOURS','message','Outside working hours');
  END IF;

  SELECT * INTO qs
  FROM queue_state
  WHERE shift = current_shift;

  IF qs IS NULL THEN
    INSERT INTO queue_state (shift, current_queue_number, is_paused)
    VALUES (current_shift, 0, false)
    RETURNING * INTO qs;
  END IF;

  IF qs.updated_at IS NOT NULL AND (qs.updated_at)::date < today_date THEN
    UPDATE queue_state
    SET current_queue_number = 0, updated_at = NOW()
    WHERE shift = current_shift;
    SELECT * INTO qs FROM queue_state WHERE shift = current_shift;
  END IF;

  IF qs.is_paused THEN
    RETURN jsonb_build_object('state','PAUSED','shift',current_shift,'message','Queue is paused');
  END IF;

  IF qs.current_queue_number = 0 THEN
    SELECT COUNT(*) INTO v_waiting_count
    FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = current_shift
      AND booking_status = 'confirmed';

    SELECT * INTO next_nb
    FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = current_shift
      AND booking_status = 'confirmed'
    ORDER BY queue_number ASC
    LIMIT 1;

    IF next_nb IS NULL THEN
      RETURN jsonb_build_object(
        'state',
          CASE current_shift
            WHEN 'morning' THEN 'NO_MORE_BOOKINGS_MORNING'
            WHEN 'evening' THEN 'NO_MORE_BOOKINGS_EVENING'
            ELSE 'NO_MORE_BOOKINGS'
          END,
        'shift', current_shift,
        'current_queue_number', 0,
        'waiting_count', 0
      );
    END IF;

    next_result_booking := jsonb_build_object(
      'queue_number', next_nb.queue_number::text,
      'ticket_code',  next_nb.ticket_code
    );

    RETURN jsonb_build_object(
      'state', 'NORMAL',
      'shift', current_shift,
      'current_queue_number', 0,
      'next_booking', next_result_booking,
      'waiting_count', v_waiting_count
    );
  END IF;

  SELECT *
  INTO nb
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number = qs.current_queue_number
    AND booking_status = 'confirmed'
  LIMIT 1;

  -- Current pointer has no confirmed booking (completed/cancelled).
  -- Look ahead and self-heal instead of returning NO_MORE immediately.
  IF nb IS NULL THEN
    SELECT * INTO next_nb
    FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = current_shift
      AND queue_number > qs.current_queue_number
      AND booking_status = 'confirmed'
    ORDER BY queue_number ASC
    LIMIT 1;

    IF next_nb IS NULL THEN
      RETURN jsonb_build_object(
        'state',
          CASE current_shift
            WHEN 'morning' THEN 'NO_MORE_BOOKINGS_MORNING'
            WHEN 'evening' THEN 'NO_MORE_BOOKINGS_EVENING'
            ELSE 'NO_MORE_BOOKINGS'
          END,
        'shift', current_shift,
        'current_queue_number', qs.current_queue_number
      );
    END IF;

    UPDATE queue_state
    SET current_queue_number = next_nb.queue_number,
        updated_at = NOW()
    WHERE shift = current_shift;

    SELECT * INTO qs FROM queue_state WHERE shift = current_shift;
    nb := next_nb;
  END IF;

  result_booking := jsonb_build_object(
    'id', nb.id,
    'ticket_code', nb.ticket_code,
    'queue_number', nb.queue_number::text,
    'booking_date', nb.booking_date,
    'shift', nb.shift,
    'booking_status', nb.booking_status,
    'patient_type', nb.patient_type,
    'patient_id', nb.patient_id,

    'patient_name',
      COALESCE(
        NULLIF(nb.guest_name, ''),
        (
          SELECT COALESCE(
            p.meta->'raw_user_meta_data'->>'full_name',
            p.meta->>'name',
            'Unknown'
          )
          FROM profiles p
          WHERE p.user_id = nb.patient_id
        )
      ),

    'patient_phone',
      CASE
        WHEN nb.patient_type = 'guest' THEN nb.guest_phone
        ELSE (
          SELECT COALESCE(
            p.meta->>'phone',
            p.meta->'raw_user_meta_data'->>'phone',
            ''
          )
          FROM profiles p WHERE p.user_id = nb.patient_id
        )
      END,

    'patient_address',
      CASE
        WHEN nb.patient_type = 'guest' THEN nb.guest_address
        ELSE (
          SELECT COALESCE(
            p.meta->'raw_user_meta_data'->>'address',
            ''
          )
          FROM profiles p WHERE p.user_id = nb.patient_id
        )
      END,

    'created_at', nb.created_at,
    'updated_at', nb.updated_at,
    'cancelled_at', nb.cancelled_at,
    'completed_at', nb.completed_at,
    'cancelled_by', nb.cancelled_by,
    'cancel_reason', nb.cancel_reason,
    'booking_created_by', nb.booking_created_by
  );

  SELECT * INTO next_nb
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number > qs.current_queue_number
    AND booking_status = 'confirmed'
  ORDER BY queue_number ASC
  LIMIT 1;

  SELECT COUNT(*) INTO v_waiting_count
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number > qs.current_queue_number
    AND booking_status = 'confirmed';

  IF next_nb IS NOT NULL THEN
    next_result_booking := jsonb_build_object(
      'queue_number', next_nb.queue_number::text,
      'ticket_code',  next_nb.ticket_code
    );
  END IF;

  IF next_nb IS NULL THEN
    RETURN jsonb_build_object(
      'state',
        CASE current_shift
          WHEN 'morning' THEN 'NO_MORE_BOOKINGS_MORNING'
          WHEN 'evening' THEN 'NO_MORE_BOOKINGS_EVENING'
          ELSE 'NO_MORE_BOOKINGS'
        END,
      'shift', current_shift,
      'current_queue_number', qs.current_queue_number,
      'current_booking', result_booking,
      'next_booking',    NULL,
      'waiting_count',   0
    );
  END IF;

  RETURN jsonb_build_object(
    'state','NORMAL',
    'shift',current_shift,
    'current_queue_number', qs.current_queue_number,
    'current_booking', result_booking,
    'next_booking',    next_result_booking,
    'waiting_count',   v_waiting_count
  );

END;
$function$;

-- =============================================================================
-- cancel_booking: patients only their own active bookings; staff need 'bookings'
-- =============================================================================

CREATE OR REPLACE FUNCTION public.cancel_booking(p_booking_id uuid, p_cancel_reason text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_role public.user_role;
  v_status public.booking_status;
  v_user_id uuid := auth.uid();
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '42501';
  END IF;

  SELECT public.current_user_role() INTO v_role;

  IF v_role IN ('admin', 'doctor', 'staff') THEN
    PERFORM public.require_permission('bookings');
    v_status := 'cancelledByStaff';

    UPDATE bookings
    SET booking_status = v_status,
        cancel_reason = p_cancel_reason,
        cancelled_at = NOW(),
        cancelled_by = v_user_id,
        updated_at = NOW()
    WHERE id = p_booking_id;
  ELSE
    v_status := 'cancelledByPatient';

    UPDATE bookings
    SET booking_status = v_status,
        cancel_reason = p_cancel_reason,
        cancelled_at = NOW(),
        cancelled_by = v_user_id,
        updated_at = NOW()
    WHERE id = p_booking_id
      AND (patient_id = v_user_id OR booking_created_by = v_user_id)
      AND booking_status IN ('pending', 'confirmed');
  END IF;

  IF NOT FOUND THEN
    RETURN jsonb_build_object(
      'success', false,
      'message', 'booking_not_found'
    );
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'booking_cancelled',
    'cancel_status', v_status,
    'cancelled_by', v_user_id
  );
END;
$$;

-- =============================================================================
-- update_patient: 'patients' permission; accounts can only stay/become patients
-- (staff accounts are created and managed separately, admin-only).
-- =============================================================================

CREATE OR REPLACE FUNCTION public.update_patient(
  p_user_id uuid,
  p_meta jsonb,
  p_role public.user_role,
  p_status public.account_status
)
RETURNS TABLE(user_id uuid, meta jsonb, role public.user_role, status public.account_status,
              created_at timestamp with time zone, updated_at timestamp with time zone,
              last_seen timestamp with time zone)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.require_permission('patients');

  IF NOT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE profiles.user_id = p_user_id
      AND profiles.role = 'patient'
  ) THEN
    RAISE EXCEPTION 'Only patient profiles can be updated using update_patient()';
  END IF;

  IF p_role IS NOT NULL AND p_role <> 'patient' THEN
    RAISE EXCEPTION 'forbidden: update_patient cannot change the account role'
      USING ERRCODE = '42501';
  END IF;

  RETURN QUERY
  UPDATE public.profiles AS p
  SET
    meta       = COALESCE(p_meta, p.meta),
    status     = COALESCE(p_status, p.status),
    updated_at = NOW()
  WHERE p.user_id = p_user_id
  RETURNING
    p.user_id,
    p.meta,
    p.role,
    p.status,
    p.created_at,
    p.updated_at,
    p.last_seen;
END;
$$;

-- =============================================================================
-- Legacy / internal functions: not used by any current app -> no client access.
-- =============================================================================

DO $$
DECLARE
  f record;
BEGIN
  FOR f IN
    SELECT p.oid::regprocedure AS sig
    FROM pg_proc p
    WHERE p.pronamespace = 'public'::regnamespace
      AND p.proname IN (
        'call_next_ticket', 'get_next_booking', 'get_daily_bookings',
        'create_booking_app', 'get_all_bookings_with_filters_app',
        'get_current_shift', 'get_dashboard_full_stats',
        'user_can_access_booking', 'enqueue_notification_job',
        'enqueue_queue_notifications', 'build_push_payload',
        'update_last_seen', 'count_bookings_for_day_shift',
        'next_queue_number_for_day_shift', 'generate_unique_ticket_code',
        'can_book', 'shift_booking_window', 'next_booking_open_at'
      )
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon, authenticated', f.sig);
  END LOOP;
END;
$$;

-- =============================================================================
-- Table privileges: clients never write these tables directly (RPCs only).
-- =============================================================================

REVOKE TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public FROM anon, authenticated;

REVOKE INSERT, UPDATE, DELETE ON public.bookings, public.queue_state,
  public.clinic_settings, public.working_hours, public.staff
  FROM anon, authenticated;

REVOKE ALL ON public.profiles FROM anon;
REVOKE INSERT, DELETE ON public.profiles FROM authenticated;

-- =============================================================================
-- Row Level Security
-- =============================================================================

-- profiles: own row (role/status protected by trigger), staff with 'patients'.
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin can read all profiles" ON public.profiles;
DROP POLICY IF EXISTS "Admin can update all profiles" ON public.profiles;
DROP POLICY IF EXISTS "No delete allowed" ON public.profiles;
DROP POLICY IF EXISTS "No insert allowed" ON public.profiles;
DROP POLICY IF EXISTS "Users can read own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS profiles_select ON public.profiles;
DROP POLICY IF EXISTS profiles_update_own ON public.profiles;

CREATE POLICY profiles_select ON public.profiles
  FOR SELECT TO authenticated
  USING (user_id = (SELECT auth.uid()) OR (SELECT public.has_permission('patients')));

CREATE POLICY profiles_update_own ON public.profiles
  FOR UPDATE TO authenticated
  USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));

-- bookings: patients see their own; staff with bookings/queue see all. No direct writes.
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS bookings_delete ON public.bookings;
DROP POLICY IF EXISTS bookings_insert ON public.bookings;
DROP POLICY IF EXISTS bookings_select ON public.bookings;
DROP POLICY IF EXISTS bookings_update ON public.bookings;

CREATE POLICY bookings_select ON public.bookings
  FOR SELECT TO authenticated
  USING (
    patient_id = (SELECT auth.uid())
    OR booking_created_by = (SELECT auth.uid())
    OR (SELECT public.has_permission('bookings'))
    OR (SELECT public.has_permission('queue'))
  );

-- queue_state / clinic configuration: public read (TV display, patient app).
ALTER TABLE public.queue_state ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS queue_state_read ON public.queue_state;
CREATE POLICY queue_state_read ON public.queue_state
  FOR SELECT TO anon, authenticated USING (true);

ALTER TABLE public.clinic_settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS clinic_settings_read ON public.clinic_settings;
CREATE POLICY clinic_settings_read ON public.clinic_settings
  FOR SELECT TO anon, authenticated USING (true);

ALTER TABLE public.working_hours ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS working_hours_read ON public.working_hours;
CREATE POLICY working_hours_read ON public.working_hours
  FOR SELECT TO anon, authenticated USING (true);

-- staff: admins read (RPCs do the rest). The old JWT-role policy never matched.
DROP POLICY IF EXISTS "Admins can manage staff" ON public.staff;
DROP POLICY IF EXISTS staff_admin_read ON public.staff;
CREATE POLICY staff_admin_read ON public.staff
  FOR SELECT TO authenticated
  USING ((SELECT public.is_admin_user()) OR user_id = (SELECT auth.uid()));
