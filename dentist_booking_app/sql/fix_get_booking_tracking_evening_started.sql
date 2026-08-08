-- Purpose: Fix false "evening queue has not started" when staff has already
-- advanced queue_state.evening today, but get_current_shift() is still morning
-- or NULL (between shifts / continue-after-window). Only force current=0 when
-- evening has NOT actually started today.
-- Also keeps day-reset + future-date zeroing from the prior shift-aware patch.
-- Run in the Supabase SQL Editor against the project database.
--
-- Verify after apply:
-- 1) Evening ticket AFTER staff starts evening queue → real current_queue_number
--    (not "الطابور المسائي لم يبدأ بعد").
-- 2) Evening ticket BEFORE evening starts, during morning → still "لم يبدأ بعد".

CREATE OR REPLACE FUNCTION "public"."get_booking_tracking"("ticket_code_param" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    booking_record RECORD;
    qs RECORD;
    profile_meta JSONB;
    patient_name TEXT;
    patient_phone TEXT;
    patient_address TEXT;
    total_in_queue INTEGER;
    effective_current INTEGER;
    patients_before INTEGER;
    estimated_wait INTEGER;
    clock_shift booking_shift;
    evening_started_today BOOLEAN;
    booking_day DATE;
    today_date DATE := CURRENT_DATE;
    result JSONB;
BEGIN
    SELECT * INTO booking_record
    FROM bookings
    WHERE ticket_code = ticket_code_param;

    IF booking_record IS NULL THEN
        RETURN NULL;
    END IF;

    booking_day := booking_record.booking_date::date;

    IF booking_record.patient_id IS NOT NULL AND booking_record.patient_type = 'registered' THEN
        SELECT meta INTO profile_meta
        FROM profiles
        WHERE user_id = booking_record.patient_id;
    ELSE
        profile_meta := NULL;
    END IF;

    -- Prefer guest_* when booking is for another person; else fall back to profile.
    patient_name := COALESCE(
      NULLIF(TRIM(booking_record.guest_name), ''),
      profile_meta->'raw_user_meta_data'->>'full_name'
    );
    patient_phone := COALESCE(
      NULLIF(TRIM(booking_record.guest_phone), ''),
      profile_meta->'raw_user_meta_data'->>'phone'
    );
    patient_address := COALESCE(
      NULLIF(TRIM(booking_record.guest_address), ''),
      profile_meta->'raw_user_meta_data'->>'address'
    );

    SELECT COUNT(*) INTO total_in_queue
    FROM bookings b
    WHERE b.shift = booking_record.shift
      AND b.booking_date::date = booking_day
      AND b.booking_status IN ('pending', 'confirmed');

    SELECT * INTO qs
    FROM queue_state
    WHERE shift = booking_record.shift;

    IF qs IS NULL THEN
        INSERT INTO queue_state (shift, current_queue_number, is_paused)
        VALUES (booking_record.shift, 0, false)
        RETURNING * INTO qs;
    END IF;

    -- Day-reset for today's bookings (same pattern as queue_status).
    IF booking_day = today_date
       AND qs.updated_at IS NOT NULL
       AND (qs.updated_at)::date < today_date THEN
        UPDATE queue_state
        SET current_queue_number = 0, updated_at = NOW()
        WHERE shift = booking_record.shift;
        SELECT * INTO qs FROM queue_state WHERE shift = booking_record.shift;
    END IF;

    effective_current := qs.current_queue_number;

    -- Future booking date: queue has not started.
    IF booking_day > today_date THEN
        effective_current := 0;
    END IF;

    -- Evening not-started guard: zero only if evening was NOT started today
    -- and we are still in morning / outside evening clock window.
    -- If staff already advanced evening today (current > 0, updated today),
    -- keep the real pointer even when get_current_shift() is NULL/morning.
    IF booking_day = today_date AND booking_record.shift = 'evening' THEN
        clock_shift := get_current_shift();
        evening_started_today := (
            qs.current_queue_number > 0
            AND qs.updated_at IS NOT NULL
            AND (qs.updated_at)::date = today_date
        );
        IF NOT evening_started_today
           AND (clock_shift IS NULL OR clock_shift = 'morning') THEN
            effective_current := 0;
        END IF;
    END IF;

    patients_before := GREATEST(0, booking_record.queue_number::INT - effective_current);
    estimated_wait := patients_before * 15;

    result := jsonb_build_object(
        'booking', jsonb_build_object(
            'id', booking_record.id,
            'booking_date', booking_record.booking_date,
            'patient_id', booking_record.patient_id,
            'patient_name', patient_name,
            'patient_phone', patient_phone,
            'patient_address', patient_address,
            'patient_type', booking_record.patient_type,
            'shift', booking_record.shift,
            'booking_status', booking_record.booking_status,
            'created_at', booking_record.created_at,
            'updated_at', booking_record.updated_at,
            'cancelled_at', booking_record.cancelled_at,
            'completed_at', booking_record.completed_at,
            'cancelled_by', booking_record.cancelled_by,
            'cancel_reason', booking_record.cancel_reason,
            'booking_created_by', booking_record.booking_created_by,
            'queue_number', booking_record.queue_number,
            'ticket_code', booking_record.ticket_code,
            'people_before', patients_before
        ),
        'queue_stats', jsonb_build_object(
            'current_queue_number', effective_current,
            'is_paused', qs.is_paused,
            'last_updated', qs.updated_at,
            'patients_before_you', patients_before,
            'total_in_queue', total_in_queue,
            'estimated_wait_time', estimated_wait
        )
    );

    RETURN result;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_booking_tracking(text) TO anon, authenticated;
