-- Enable Supabase Realtime on queue_state (current turn, pause, etc.)
ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.queue_state;
