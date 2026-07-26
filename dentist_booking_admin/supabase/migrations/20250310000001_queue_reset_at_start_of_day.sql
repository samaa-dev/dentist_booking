-- Reset queue_state.current_queue_number at start of new day so "بدء الطابور" works.
-- Run in Supabase SQL Editor.

-- 1) queue_next: after reading queue_state, if last update was on a previous day, reset to 0 then re-read.
CREATE OR REPLACE FUNCTION "public"."queue_next"("p_datetime" timestamp without time zone) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $body$
DECLARE
  qs RECORD;
  next_booking RECORD;
  current_shift booking_shift;
  now_time TIME := p_datetime::time;
  today_date DATE := p_datetime::date;

  wh RECORD;
  iso INT := EXTRACT(isodow FROM today_date);
  dow INT;
BEGIN
  dow := CASE
           WHEN iso = 6 THEN 1
           WHEN iso = 7 THEN 2
           ELSE iso + 2
         END;

  SELECT * INTO wh FROM working_hours WHERE day_of_week = dow;

  IF wh IS NULL OR wh.is_open = FALSE THEN
    RETURN jsonb_build_object('success',false,'code','CLINIC_CLOSED');
  END IF;

  IF now_time BETWEEN wh.morning_start AND wh.morning_end THEN
    current_shift := 'morning';
  ELSIF now_time BETWEEN wh.evening_start AND wh.evening_end THEN
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

  -- بداية يوم جديد: إعادة ضبط الطابور لليوم الحالي
  IF qs.updated_at IS NOT NULL AND (qs.updated_at)::date < today_date THEN
    UPDATE queue_state
    SET current_queue_number = 0, updated_at = NOW()
    WHERE shift = current_shift;
    SELECT * INTO qs FROM queue_state WHERE shift = current_shift;
  END IF;

  IF qs.is_paused THEN
    RETURN jsonb_build_object('success',false,'code','QUEUE_PAUSED');
  END IF;

  -- التصحيح: تجاهل booking_status تماماً - أخذ الحجز التالي بغض النظر عن حالته
  SELECT *
  INTO next_booking
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number > qs.current_queue_number
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
$body$;


-- 2) queue_status: same logic – if last update was previous day, reset to 0 then use for "next" query.
CREATE OR REPLACE FUNCTION "public"."queue_status"("p_datetime" timestamp with time zone) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $body$
DECLARE
  now_time TIME := p_datetime::time;
  today_date DATE := p_datetime::date;

  wh RECORD;
  qs RECORD;
  nb RECORD;
  result_booking JSONB;

  iso INT := EXTRACT(isodow FROM today_date);
  dow INT;
  current_shift booking_shift;
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

  IF now_time BETWEEN wh.morning_start AND wh.morning_end THEN
    current_shift := 'morning';
  ELSIF now_time BETWEEN wh.evening_start AND wh.evening_end THEN
    current_shift := 'evening';
  ELSE
    RETURN jsonb_build_object('state','OUT_OF_WORKING_HOURS','message','Outside working hours');
  END IF;

  SELECT * INTO qs
  FROM queue_state
  WHERE shift = current_shift;

  -- إذا لا يوجد سجل، إنشاؤه (نفس سلوك queue_next عند عدم وجود سجل)
  IF qs IS NULL THEN
    INSERT INTO queue_state (shift, current_queue_number, is_paused)
    VALUES (current_shift, 0, false)
    RETURNING * INTO qs;
  END IF;

  -- بداية يوم جديد: إعادة ضبط الطابور لليوم الحالي
  IF qs.updated_at IS NOT NULL AND (qs.updated_at)::date < today_date THEN
    UPDATE queue_state
    SET current_queue_number = 0, updated_at = NOW()
    WHERE shift = current_shift;
    SELECT * INTO qs FROM queue_state WHERE shift = current_shift;
  END IF;

  IF qs.is_paused THEN
    RETURN jsonb_build_object('state','PAUSED','shift',current_shift,'message','Queue is paused');
  END IF;

  SELECT *
  INTO nb
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND booking_status = 'confirmed'
    AND queue_number > qs.current_queue_number
  ORDER BY queue_number ASC
  LIMIT 1;

  IF nb IS NULL THEN
    RETURN jsonb_build_object(
      'state',
        CASE current_shift
          WHEN 'morning' THEN 'NO_MORE_BOOKINGS_MORNING'
          WHEN 'evening' THEN 'NO_MORE_BOOKINGS_EVENING'
          ELSE 'NO_MORE_BOOKINGS'
        END,
      'shift', current_shift
    );
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
      CASE
        WHEN nb.patient_type = 'guest' THEN nb.guest_name
        ELSE (
          SELECT COALESCE(
            p.meta->'raw_user_meta_data'->>'full_name',
            p.meta->>'name',
            'Unknown'
          )
          FROM profiles p WHERE p.user_id = nb.patient_id
        )
      END,

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

  RETURN jsonb_build_object(
    'state','NORMAL',
    'shift',current_shift,
    'current_queue_number', qs.current_queue_number,
    'next_booking', result_booking
  );

END;
$body$;
