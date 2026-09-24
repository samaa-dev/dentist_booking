-- Preview how many pending/confirmed bookings are ahead for a day+shift
-- before the patient creates a booking. Matches create_booking people_before
-- logic (count of pending/confirmed for that day+shift = people ahead of the
-- next ticket).

CREATE OR REPLACE FUNCTION public.get_people_ahead_for_shift(
  p_date date,
  p_shift public.booking_shift
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  ahead_count integer;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  SELECT COUNT(*)::integer
  INTO ahead_count
  FROM bookings b
  WHERE DATE(b.booking_date) = p_date
    AND b.shift = p_shift
    AND b.booking_status IN ('pending', 'confirmed');

  RETURN COALESCE(ahead_count, 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_people_ahead_for_shift(date, public.booking_shift)
  FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_people_ahead_for_shift(date, public.booking_shift)
  TO authenticated;

COMMENT ON FUNCTION public.get_people_ahead_for_shift(date, public.booking_shift) IS
  'Returns count of pending/confirmed bookings for day+shift (people ahead if booking now). Patient app pre-create confirm.';
