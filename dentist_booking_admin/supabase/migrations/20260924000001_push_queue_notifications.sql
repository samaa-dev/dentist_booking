-- Push notifications for queue: device tokens, outbox jobs, enqueue on book / queue advance.
-- Delivery is handled by Edge Function `send-push` (Database Webhook or pg_net).

-- =============================================================================
-- Tables
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.device_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  token text NOT NULL,
  platform text NOT NULL DEFAULT 'android'
    CHECK (platform IN ('android', 'ios')),
  updated_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT device_tokens_token_unique UNIQUE (token)
);

CREATE INDEX IF NOT EXISTS device_tokens_user_id_idx
  ON public.device_tokens (user_id);

CREATE TABLE IF NOT EXISTS public.notification_jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  booking_id uuid REFERENCES public.bookings (id) ON DELETE SET NULL,
  kind text NOT NULL
    CHECK (kind IN ('booking_confirmed', 'position_update', 'your_turn')),
  people_before integer NOT NULL DEFAULT 0,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  status text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'sent', 'failed')),
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now(),
  sent_at timestamptz
);

CREATE INDEX IF NOT EXISTS notification_jobs_status_created_idx
  ON public.notification_jobs (status, created_at);

CREATE INDEX IF NOT EXISTS notification_jobs_user_id_idx
  ON public.notification_jobs (user_id);

-- Optional URL for pg_net self-invoke (Database Webhook is preferred; see PUSH_SETUP.md)
CREATE TABLE IF NOT EXISTS public.push_config (
  id integer PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  edge_function_url text,
  enabled boolean NOT NULL DEFAULT false,
  updated_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.push_config (id, enabled)
VALUES (1, false)
ON CONFLICT (id) DO NOTHING;

-- =============================================================================
-- RLS
-- =============================================================================

ALTER TABLE public.device_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.push_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS device_tokens_select_own ON public.device_tokens;
CREATE POLICY device_tokens_select_own
  ON public.device_tokens FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS device_tokens_insert_own ON public.device_tokens;
CREATE POLICY device_tokens_insert_own
  ON public.device_tokens FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS device_tokens_update_own ON public.device_tokens;
CREATE POLICY device_tokens_update_own
  ON public.device_tokens FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS device_tokens_delete_own ON public.device_tokens;
CREATE POLICY device_tokens_delete_own
  ON public.device_tokens FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Clients do not read/write jobs or push_config (service role / triggers only)
DROP POLICY IF EXISTS notification_jobs_no_client ON public.notification_jobs;
CREATE POLICY notification_jobs_no_client
  ON public.notification_jobs FOR ALL
  TO authenticated
  USING (false)
  WITH CHECK (false);

DROP POLICY IF EXISTS push_config_no_client ON public.push_config;
CREATE POLICY push_config_no_client
  ON public.push_config FOR ALL
  TO authenticated
  USING (false)
  WITH CHECK (false);

-- =============================================================================
-- Upsert device token (patient app)
-- =============================================================================

CREATE OR REPLACE FUNCTION public.upsert_device_token(
  p_token text,
  p_platform text DEFAULT 'android'
) RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  IF p_token IS NULL OR trim(p_token) = '' THEN
    RAISE EXCEPTION 'token_required';
  END IF;

  IF p_platform IS NULL OR p_platform NOT IN ('android', 'ios') THEN
    RAISE EXCEPTION 'invalid_platform';
  END IF;

  INSERT INTO public.device_tokens (user_id, token, platform, updated_at)
  VALUES (v_uid, trim(p_token), p_platform, now())
  ON CONFLICT (token) DO UPDATE
    SET user_id = EXCLUDED.user_id,
        platform = EXCLUDED.platform,
        updated_at = now();
END;
$$;

REVOKE ALL ON FUNCTION public.upsert_device_token(text, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.upsert_device_token(text, text) TO authenticated;

CREATE OR REPLACE FUNCTION public.delete_device_token(p_token text)
RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RETURN;
  END IF;

  DELETE FROM public.device_tokens
  WHERE user_id = v_uid
    AND token = trim(p_token);
END;
$$;

REVOKE ALL ON FUNCTION public.delete_device_token(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.delete_device_token(text) TO authenticated;

-- =============================================================================
-- Build Arabic payload helpers
-- =============================================================================

CREATE OR REPLACE FUNCTION public.build_push_payload(
  p_kind text,
  p_people_before integer,
  p_booking_id uuid,
  p_ticket_code text,
  p_queue_number integer
) RETURNS jsonb
  LANGUAGE plpgsql
  IMMUTABLE
AS $$
DECLARE
  v_title text;
  v_body text;
BEGIN
  IF p_kind = 'booking_confirmed' THEN
    v_title := 'تم حجز موعدك';
    IF p_people_before <= 0 THEN
      v_body := 'تم تأكيد حجزك. أنت التالي في الدور.';
    ELSIF p_people_before = 1 THEN
      v_body := 'تم تأكيد حجزك. قبلك شخص واحد.';
    ELSE
      v_body := format('تم تأكيد حجزك. قبلك %s أشخاص.', p_people_before);
    END IF;
  ELSIF p_kind = 'your_turn' THEN
    v_title := 'حان دورك';
    v_body := 'حان دورك الآن — توجه إلى العيادة.';
  ELSE
    -- position_update
    v_title := 'تحديث الدور';
    IF p_people_before <= 0 THEN
      v_body := 'أصبحت التالي في الدور.';
    ELSIF p_people_before = 1 THEN
      v_body := 'أصبح قبلك شخص واحد.';
    ELSE
      v_body := format('أصبح قبلك %s أشخاص.', p_people_before);
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'title', v_title,
    'body', v_body,
    'booking_id', p_booking_id,
    'ticket_code', p_ticket_code,
    'queue_number', p_queue_number,
    'people_before', p_people_before,
    'kind', p_kind,
    'collapse_key', p_booking_id::text
  );
END;
$$;

-- =============================================================================
-- Enqueue helpers
-- =============================================================================

CREATE OR REPLACE FUNCTION public.enqueue_notification_job(
  p_user_id uuid,
  p_booking_id uuid,
  p_kind text,
  p_people_before integer,
  p_ticket_code text,
  p_queue_number integer
) RETURNS uuid
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_job_id uuid;
BEGIN
  IF p_user_id IS NULL THEN
    RETURN NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.device_tokens dt WHERE dt.user_id = p_user_id
  ) THEN
    RETURN NULL;
  END IF;

  INSERT INTO public.notification_jobs (
    user_id, booking_id, kind, people_before, payload, status
  )
  VALUES (
    p_user_id,
    p_booking_id,
    p_kind,
    COALESCE(p_people_before, 0),
    public.build_push_payload(
      p_kind,
      COALESCE(p_people_before, 0),
      p_booking_id,
      p_ticket_code,
      p_queue_number
    ),
    'pending'
  )
  RETURNING id INTO v_job_id;

  RETURN v_job_id;
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
  v_today date := CURRENT_DATE;
  r RECORD;
  v_people_before integer;
  v_kind text;
  v_count integer := 0;
  v_recipient uuid;
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
    v_recipient := r.patient_id;
    v_people_before := GREATEST(r.queue_number - v_current, 0);

    IF r.queue_number = v_current THEN
      v_kind := 'your_turn';
      v_people_before := 0;
    ELSE
      v_kind := 'position_update';
    END IF;

    IF public.enqueue_notification_job(
      v_recipient,
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

-- =============================================================================
-- Triggers: booking insert → confirmed; queue_state advance → position / turn
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
END;
$$;

DROP TRIGGER IF EXISTS bookings_enqueue_confirmed_notification ON public.bookings;
CREATE TRIGGER bookings_enqueue_confirmed_notification
  AFTER INSERT ON public.bookings
  FOR EACH ROW
  EXECUTE FUNCTION public.trg_bookings_enqueue_confirmed();

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
END;
$$;

DROP TRIGGER IF EXISTS queue_state_enqueue_notifications ON public.queue_state;
CREATE TRIGGER queue_state_enqueue_notifications
  AFTER UPDATE OF current_queue_number ON public.queue_state
  FOR EACH ROW
  EXECUTE FUNCTION public.trg_queue_state_enqueue_notifications();

-- =============================================================================
-- Optional: invoke Edge Function via pg_net when push_config.enabled
-- Prefer Database Webhook in Dashboard (no service-role secret in DB).
-- =============================================================================

-- pg_net is usually pre-enabled on hosted Supabase (schema net).
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'pg_net extension not created: %', SQLERRM;
END;
$$;

CREATE OR REPLACE FUNCTION public.trg_notification_jobs_dispatch()
RETURNS trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
AS $$
DECLARE
  v_url text;
  v_enabled boolean;
  v_headers jsonb;
  v_auth text;
BEGIN
  SELECT pc.edge_function_url, pc.enabled
  INTO v_url, v_enabled
  FROM public.push_config pc
  WHERE pc.id = 1;

  IF NOT COALESCE(v_enabled, false)
     OR v_url IS NULL
     OR trim(v_url) = '' THEN
    RETURN NEW;
  END IF;

  v_auth := coalesce(current_setting('app.settings.service_role_key', true), '');
  v_headers := jsonb_build_object('Content-Type', 'application/json');
  IF v_auth <> '' THEN
    v_headers := v_headers || jsonb_build_object('Authorization', 'Bearer ' || v_auth);
  END IF;

  -- Prefer Database Webhook; this path is optional when push_config.enabled = true
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

DROP TRIGGER IF EXISTS notification_jobs_dispatch ON public.notification_jobs;
CREATE TRIGGER notification_jobs_dispatch
  AFTER INSERT ON public.notification_jobs
  FOR EACH ROW
  EXECUTE FUNCTION public.trg_notification_jobs_dispatch();

COMMENT ON TABLE public.device_tokens IS
  'FCM device tokens per authenticated patient; managed via upsert_device_token / delete_device_token.';
COMMENT ON TABLE public.notification_jobs IS
  'Outbox for queue push notifications. Consumed by Edge Function send-push.';
COMMENT ON FUNCTION public.enqueue_queue_notifications(public.booking_shift) IS
  'Enqueues position_update / your_turn jobs for active bookings at or after current queue number.';
