-- URGENT security hotfix: admin-only RPCs were callable by anyone holding the
-- public anon key (create/update/delete staff, change roles via update_patient,
-- clinic settings, working hours). Each function body is the production
-- definition unchanged, plus one guard line: PERFORM public.require_admin();
-- Also blocks clients from changing profiles.role/status directly and removes
-- client access to the http extension functions.

CREATE OR REPLACE FUNCTION public.require_admin()
RETURNS void
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.user_id = auth.uid()
      AND p.role IN ('admin', 'doctor')
      AND p.status = 'active'
  ) THEN
    RAISE EXCEPTION 'forbidden: admin only' USING ERRCODE = '42501';
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.require_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.require_admin() TO authenticated;

-- Clients may edit their own profile data, never their role or status.
CREATE OR REPLACE FUNCTION public.trg_profiles_protect_role_status()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF current_user IN ('anon', 'authenticated') THEN
    IF TG_OP = 'INSERT' AND (NEW.role <> 'patient' OR NEW.status <> 'active') THEN
      RAISE EXCEPTION 'forbidden: role/status are managed by the clinic' USING ERRCODE = '42501';
    END IF;
    IF TG_OP = 'UPDATE' AND (NEW.role IS DISTINCT FROM OLD.role
                             OR NEW.status IS DISTINCT FROM OLD.status) THEN
      RAISE EXCEPTION 'forbidden: role/status are managed by the clinic' USING ERRCODE = '42501';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS profiles_protect_role_status ON public.profiles;
CREATE TRIGGER profiles_protect_role_status
  BEFORE INSERT OR UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.trg_profiles_protect_role_status();

-- http extension functions must not be callable from the API.
DO $$
DECLARE
  f record;
BEGIN
  FOR f IN
    SELECT p.oid::regprocedure AS sig
    FROM pg_proc p
    JOIN pg_depend d ON d.objid = p.oid AND d.deptype = 'e'
    JOIN pg_extension e ON e.oid = d.refobjid AND e.extname = 'http'
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC, anon, authenticated', f.sig);
  END LOOP;
END;
$$;

-- =============================================================================
-- Admin-only RPCs (production bodies + guard)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.create_staff(p_user_id uuid, p_full_name text, p_email text, p_phone text, p_position staff_position, p_shift shift_type, p_status account_status DEFAULT 'active'::account_status)
 RETURNS TABLE(id uuid, user_id uuid, full_name text, email text, phone text, "position" staff_position, shift_type shift_type, account_status account_status, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public.require_admin();
  -- 1) إنشاء الموظف
  RETURN QUERY
  WITH inserted AS (
    INSERT INTO public.staff AS s (
      user_id,
      full_name,
      email,
      phone,
      position,
      shift_type,
      status
    )
    VALUES (
      p_user_id,
      p_full_name,
      p_email,
      p_phone,
      p_position,
      p_shift,
      p_status
    )
    RETURNING s.*
  ),

  -- 2) تحديث role داخل profiles بعد الإدراج
  updated_profile AS (
    UPDATE public.profiles p
    SET 
      role = 'staff'::public.user_role,   -- 👈 إضافة role
      status = p_status,                  -- 👈 إضافة status
      updated_at = NOW()
    WHERE p.user_id = p_user_id
    RETURNING p.user_id
  )

  -- 3) إرجاع بيانات الموظف الجديدة
  SELECT
    i.id,
    i.user_id,
    i.full_name,
    i.email,
    i.phone,
    i.position,
    i.shift_type,
    i.status AS account_status,
    i.created_at,
    i.updated_at
  FROM inserted i;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_staff(p_id uuid, p_full_name text, p_email text, p_phone text, p_position staff_position, p_shift shift_type, p_status account_status)
 RETURNS TABLE(id uuid, user_id uuid, full_name text, email text, phone text, "position" staff_position, shift_type shift_type, account_status account_status, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public.require_admin();
  RETURN QUERY
  UPDATE public.staff s
  SET
    full_name = p_full_name,
    email = p_email,
    phone = p_phone,
    position = p_position,
    shift_type = p_shift,
    status = p_status,     -- ✔ تعديل هنا
    updated_at = NOW()
  WHERE s.id = p_id
  RETURNING
    s.id,
    s.user_id,
    s.full_name,
    s.email,
    s.phone,
    s.position,
    s.shift_type,
    s.status AS account_status,   -- ✔ alias
    s.created_at,
    s.updated_at;
END;
$function$;

CREATE OR REPLACE FUNCTION public.delete_staff(p_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_admin();
  delete from public.staff s
    where s.id = p_id;

  return found;
end;
$function$;

CREATE OR REPLACE FUNCTION public.get_all_staff()
 RETURNS TABLE(id uuid, user_id uuid, full_name text, email text, phone text, "position" staff_position, shift_type shift_type, account_status account_status, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
    s.shift_type,
    s.status AS account_status,   -- ✔ التعديل هنا
    s.created_at,
    s.updated_at
  FROM public.staff s
  ORDER BY s.created_at DESC;
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_patient(p_user_id uuid, p_meta jsonb, p_role user_role, p_status account_status)
 RETURNS TABLE(user_id uuid, meta jsonb, role user_role, status account_status, created_at timestamp with time zone, updated_at timestamp with time zone, last_seen timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  PERFORM public.require_admin();
  -- 🔐 لا نسمح إلا بتحديث المرضى فقط
  IF NOT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE profiles.user_id = p_user_id
      AND profiles.role = 'patient'
  ) THEN
    RAISE EXCEPTION 'Only patient profiles can be updated using update_patient()';
  END IF;

  -- ✔ تنفيذ عملية التحديث
  RETURN QUERY
  UPDATE public.profiles AS p
  SET
    meta       = COALESCE(p_meta, p.meta),
    role       = COALESCE(p_role, p.role),
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
$function$;

CREATE OR REPLACE FUNCTION public.save_clinic_config(p_settings jsonb, p_hours jsonb)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_admin();
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
  PERFORM public.require_admin();
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

CREATE OR REPLACE FUNCTION public.update_clinic_settings(p_morning_count_limit integer, p_evening_count_limit integer, p_is_booking_enabled boolean, p_booking_morning_start_time time without time zone, p_allow_before_minutes integer, p_auto_confirm boolean, p_stop_reason text, p_clinic_phone text DEFAULT NULL::text, p_ticket_note text DEFAULT NULL::text, p_min_version_patient text DEFAULT NULL::text, p_min_version_admin text DEFAULT NULL::text, p_min_version_desktop text DEFAULT NULL::text, p_min_version_tv text DEFAULT NULL::text, p_update_min_versions boolean DEFAULT false)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_admin();
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

CREATE OR REPLACE FUNCTION public.update_clinic_settings(p_morning_count_limit integer, p_evening_count_limit integer, p_is_booking_enabled boolean, p_booking_morning_start_time time without time zone, p_allow_before_minutes integer, p_auto_confirm boolean, p_stop_reason text, p_clinic_phone text DEFAULT NULL::text, p_ticket_note text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  PERFORM public.require_admin();
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

CREATE OR REPLACE FUNCTION public.update_working_hours(p_hours jsonb)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  item jsonb;
BEGIN
  PERFORM public.require_admin();
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
