-- Purpose: enable patient home live queue updates when staff advances
-- queue_state (queue_next only updates this table, not the patient's booking row).
-- Run in the Supabase SQL Editor against the project database.
-- Safe to re-run: skips if queue_state is already in the publication.

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'queue_state'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.queue_state;
  END IF;
END $$;
