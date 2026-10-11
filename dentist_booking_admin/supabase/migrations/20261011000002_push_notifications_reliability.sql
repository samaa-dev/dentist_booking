-- Push notifications reliability.
--   * notification_jobs.status gains 'processing' so send-push can claim a job
--     atomically (Database Webhook + pg_net can both fire without double sends).
--   * pg_net dispatch can authenticate with push_config.webhook_secret
--     (matches the PUSH_WEBHOOK_SECRET Edge Function secret).
--   * pg_net dispatch is enabled by default for this project.
--   * Queue notifications use the clinic date (clinic_now) instead of UTC
--     CURRENT_DATE, and people_before skips cancelled bookings.
-- Requires 20261011000001_booking_window_server_time (clinic_now).

ALTER TABLE public.notification_jobs
  DROP CONSTRAINT IF EXISTS notification_jobs_status_check;
ALTER TABLE public.notification_jobs
  ADD CONSTRAINT notification_jobs_status_check
  CHECK (status IN ('pending', 'processing', 'sent', 'failed'));

ALTER TABLE public.push_config
  ADD COLUMN IF NOT EXISTS webhook_secret text;

UPDATE public.push_config
SET edge_function_url = 'https://agyqdghxqylwinpcvvmn.supabase.co/functions/v1/send-push',
    enabled = true,
    updated_at = now()
WHERE id = 1
  AND (edge_function_url IS NULL OR trim(edge_function_url) = '');

CREATE OR REPLACE FUNCTION public.trg_notification_jobs_dispatch()
RETURNS trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_url text;
  v_enabled boolean;
  v_secret text;
  v_headers jsonb;
BEGIN
  SELECT pc.edge_function_url, pc.enabled, NULLIF(trim(pc.webhook_secret), '')
  INTO v_url, v_enabled, v_secret
  FROM public.push_config pc
  WHERE pc.id = 1;

  IF NOT COALESCE(v_enabled, false)
     OR v_url IS NULL
     OR trim(v_url) = '' THEN
    RETURN NEW;
  END IF;

  v_headers := jsonb_build_object('Content-Type', 'application/json');
  IF v_secret IS NOT NULL THEN
    v_headers := v_headers || jsonb_build_object('x-push-secret', v_secret);
  END IF;

  PERFORM net.http_post(
    url := trim(v_url),
    headers := v_headers,
    body := jsonb_build_object(
      'type', 'INSERT',
      'table', 'notification_jobs',
      'record', to_jsonb(NEW)
    )
  );

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Never block booking / queue on push dispatch failure
    RAISE WARNING 'push dispatch failed: %', SQLERRM;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.enqueue_queue_notifications(p_shift public.booking_shift)
RETURNS integer
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_current integer;
  v_today date := public.clinic_now()::date;
  r RECORD;
  v_people_before integer;
  v_kind text;
  v_count integer := 0;
BEGIN
  SELECT qs.current_queue_number
  INTO v_current
  FROM public.queue_state qs
  WHERE qs.shift = p_shift;

  IF v_current IS NULL OR v_current <= 0 THEN
    RETURN 0;
  END IF;

  FOR r IN
    SELECT
      b.id,
      b.patient_id,
      b.queue_number,
      b.ticket_code
    FROM public.bookings b
    WHERE DATE(b.booking_date) = v_today
      AND b.shift = p_shift
      AND b.booking_status IN ('pending', 'confirmed')
      AND b.queue_number >= v_current
      AND b.patient_id IS NOT NULL
    ORDER BY b.queue_number
  LOOP
    IF r.queue_number = v_current THEN
      v_kind := 'your_turn';
      v_people_before := 0;
    ELSE
      v_kind := 'position_update';
      -- The patient being served now + active bookings between them and us.
      SELECT 1 + COUNT(*)::integer
      INTO v_people_before
      FROM public.bookings b2
      WHERE DATE(b2.booking_date) = v_today
        AND b2.shift = p_shift
        AND b2.booking_status IN ('pending', 'confirmed')
        AND b2.queue_number > v_current
        AND b2.queue_number < r.queue_number;
    END IF;

    IF public.enqueue_notification_job(
      r.patient_id,
      r.id,
      v_kind,
      v_people_before,
      r.ticket_code,
      r.queue_number
    ) IS NOT NULL THEN
      v_count := v_count + 1;
    END IF;
  END LOOP;

  RETURN v_count;
END;
$$;

-- Diagnostics for the admin (SQL Editor): where is the push pipeline stuck?
CREATE OR REPLACE FUNCTION public.push_diagnostics()
RETURNS jsonb
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path = public
AS $$
  SELECT jsonb_build_object(
    'device_tokens', (SELECT COUNT(*) FROM public.device_tokens),
    'users_with_tokens', (SELECT COUNT(DISTINCT user_id) FROM public.device_tokens),
    'jobs_by_status', (
      SELECT COALESCE(jsonb_object_agg(status, n), '{}'::jsonb)
      FROM (
        SELECT status, COUNT(*) AS n
        FROM public.notification_jobs
        WHERE created_at > now() - interval '7 days'
        GROUP BY status
      ) s
    ),
    'last_errors', (
      SELECT COALESCE(jsonb_agg(e), '[]'::jsonb)
      FROM (
        SELECT created_at, kind, error_message
        FROM public.notification_jobs
        WHERE status = 'failed'
        ORDER BY created_at DESC
        LIMIT 5
      ) e
    ),
    'dispatch_enabled', (SELECT enabled FROM public.push_config WHERE id = 1),
    'dispatch_url', (SELECT edge_function_url FROM public.push_config WHERE id = 1),
    'dispatch_has_secret', (
      SELECT webhook_secret IS NOT NULL AND trim(webhook_secret) <> ''
      FROM public.push_config WHERE id = 1
    )
  );
$$;

REVOKE ALL ON FUNCTION public.push_diagnostics() FROM PUBLIC, anon, authenticated;

-- =============================================================================
-- Notification triggers must never block booking creation or queue advance.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.trg_bookings_enqueue_confirmed()
RETURNS trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_people_before integer;
BEGIN
  IF NEW.patient_id IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.booking_status NOT IN ('pending', 'confirmed') THEN
    RETURN NEW;
  END IF;

  SELECT COUNT(*)::integer
  INTO v_people_before
  FROM public.bookings b2
  WHERE DATE(b2.booking_date) = DATE(NEW.booking_date)
    AND b2.shift = NEW.shift
    AND b2.booking_status IN ('pending', 'confirmed')
    AND b2.queue_number < NEW.queue_number;

  PERFORM public.enqueue_notification_job(
    NEW.patient_id,
    NEW.id,
    'booking_confirmed',
    v_people_before,
    NEW.ticket_code,
    NEW.queue_number
  );

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'enqueue booking notification failed: %', SQLERRM;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.trg_queue_state_enqueue_notifications()
RETURNS trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
BEGIN
  IF NEW.current_queue_number IS DISTINCT FROM OLD.current_queue_number
     AND NEW.current_queue_number > 0 THEN
    PERFORM public.enqueue_queue_notifications(NEW.shift);
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'enqueue queue notifications failed: %', SQLERRM;
    RETURN NEW;
END;
$$;
