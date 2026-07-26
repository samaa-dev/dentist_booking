-- Minimum accepted app versions per client

ALTER TABLE public.clinic_settings
  ADD COLUMN IF NOT EXISTS min_version_patient text NULL,
  ADD COLUMN IF NOT EXISTS min_version_admin text NULL,
  ADD COLUMN IF NOT EXISTS min_version_desktop text NULL,
  ADD COLUMN IF NOT EXISTS min_version_tv text NULL;

CREATE OR REPLACE FUNCTION public.get_min_app_versions()
RETURNS jsonb
LANGUAGE sql
SECURITY DEFINER
SET search_path TO 'public'
STABLE
AS $$
  SELECT jsonb_build_object(
    'min_version_patient', min_version_patient,
    'min_version_admin', min_version_admin,
    'min_version_desktop', min_version_desktop,
    'min_version_tv', min_version_tv
  )
  FROM clinic_settings
  WHERE id = 1;
$$;

GRANT EXECUTE ON FUNCTION public.get_min_app_versions() TO anon, authenticated;

CREATE OR REPLACE FUNCTION public.update_clinic_settings(
  p_morning_count_limit integer,
  p_evening_count_limit integer,
  p_is_booking_enabled boolean,
  p_booking_morning_start_time time without time zone,
  p_allow_before_minutes integer,
  p_auto_confirm boolean,
  p_stop_reason text,
  p_clinic_phone text DEFAULT NULL,
  p_ticket_note text DEFAULT NULL,
  p_min_version_patient text DEFAULT NULL,
  p_min_version_admin text DEFAULT NULL,
  p_min_version_desktop text DEFAULT NULL,
  p_min_version_tv text DEFAULT NULL,
  p_update_min_versions boolean DEFAULT false
) RETURNS void
  LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public'
  AS $$
begin
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
$$;

CREATE OR REPLACE FUNCTION public.save_clinic_config(p_settings jsonb, p_hours jsonb) RETURNS void
  LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public'
  AS $$
begin
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
    (p_settings ? 'min_version_patient'
      OR p_settings ? 'min_version_admin'
      OR p_settings ? 'min_version_desktop'
      OR p_settings ? 'min_version_tv')
  );
  perform update_working_hours(p_hours);
end;
$$;
