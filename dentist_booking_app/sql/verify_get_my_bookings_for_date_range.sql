-- Manual verification for get_my_bookings_for_date_range.
-- Run each STEP separately in the Supabase SQL Editor.
-- Replace the uid / ticket / dates with your real values.
--
--   uid    = 4e4a498a-5ed9-46a1-a9e3-62516034c172
--   ticket = TIC-1685
--   day    = 2026-08-16

-- ===== STEP 1: does the function exist, and is it SECURITY DEFINER? =====
SELECT
  n.nspname AS schema,
  p.proname AS name,
  pg_get_function_identity_arguments(p.oid) AS args,
  p.prosecdef AS security_definer
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
  AND p.proname IN (
    'get_my_bookings_for_date_range',
    'get_all_bookings_with_filters_app'
  );
-- Expected: get_my_bookings_for_date_range | p_start_date date, p_end_date date, p_search_query text | true
-- If missing  -> the migration was never applied. Apply
--                20260816000001_get_my_bookings_for_date_range.sql first.


-- ===== STEP 2: can role authenticated execute it? =====
SELECT has_function_privilege(
  'authenticated',
  'public.get_my_bookings_for_date_range(date,date,text)',
  'EXECUTE'
) AS authenticated_can_execute;
-- Expected: true


-- ===== STEP 3: the raw row exists and belongs to the patient =====
SELECT
  id,
  patient_id,
  booking_created_by,
  patient_type,
  booking_date,
  booking_date::date AS booking_day,
  booking_status,
  queue_number,
  ticket_code
FROM public.bookings
WHERE ticket_code = 'TIC-1685';
-- Check: patient_id = 4e4a498a-5ed9-46a1-a9e3-62516034c172
--        booking_day = 2026-08-16


-- ===== STEP 4: call the RPC as that patient (simulated JWT) =====
-- auth.uid() is NULL in the SQL Editor, so the session must be simulated.
BEGIN;

SELECT set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', '4e4a498a-5ed9-46a1-a9e3-62516034c172',
    'role', 'authenticated'
  )::text,
  true
);
SET LOCAL ROLE authenticated;

SELECT auth.uid() AS acting_as;
-- Expected: 4e4a498a-5ed9-46a1-a9e3-62516034c172

SELECT id, ticket_code, booking_date, booking_status, queue_number, people_before
FROM public.get_my_bookings_for_date_range('2026-08-16', '2026-08-16', NULL);
-- Expected: one row with ticket_code = TIC-1685

ROLLBACK;


-- ===== STEP 5: no date filter (rules out a date-range problem) =====
BEGIN;
SELECT set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', '4e4a498a-5ed9-46a1-a9e3-62516034c172',
    'role', 'authenticated'
  )::text,
  true
);
SET LOCAL ROLE authenticated;

SELECT id, ticket_code, booking_date::date, booking_status
FROM public.get_my_bookings_for_date_range(NULL, NULL, NULL);

ROLLBACK;


-- ===== STEP 6: another user must NOT see this booking =====
BEGIN;
SELECT set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', '00000000-0000-0000-0000-000000000000',
    'role', 'authenticated'
  )::text,
  true
);
SET LOCAL ROLE authenticated;

SELECT count(*) AS should_be_zero
FROM public.get_my_bookings_for_date_range('2026-08-16', '2026-08-16', NULL);

ROLLBACK;


-- ===== STEP 7: compare with the old RPC used before the fix =====
BEGIN;
SELECT set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', '4e4a498a-5ed9-46a1-a9e3-62516034c172',
    'role', 'authenticated'
  )::text,
  true
);
SET LOCAL ROLE authenticated;

SELECT count(*) AS old_rpc_rows
FROM public.get_all_bookings_with_filters_app(
  '4e4a498a-5ed9-46a1-a9e3-62516034c172'::uuid,
  '2026-08-16',
  '2026-08-16',
  NULL, NULL, NULL, NULL
);
-- 0 here while STEP 4 returns 1 confirms the old RPC / RLS was the blocker.

ROLLBACK;


-- ===== STEP 8: refresh the PostgREST schema cache =====
-- A newly created function stays invisible to the app (404 / "function not
-- found") until PostgREST reloads.
NOTIFY pgrst, 'reload schema';
