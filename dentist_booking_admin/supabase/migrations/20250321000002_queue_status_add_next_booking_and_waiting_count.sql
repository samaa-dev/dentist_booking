-- Minimal addition to queue_status: restore next_booking and waiting_count for TV display.
-- All existing logic and current_booking fields are unchanged.
-- Changes from 20250321000001:
--   1. DECLARE: added next_nb RECORD, next_result_booking JSONB, v_waiting_count INT
--   2. current_queue_number = 0 block: added waiting_count to RETURN
--   3. After result_booking: query next_nb + v_waiting_count, build next_result_booking
--   4. IF NOT EXISTS block → replaced with next_nb IS NULL; added next_booking+waiting_count to RETURN
--   5. Final NORMAL RETURN: added next_booking and waiting_count

CREATE OR REPLACE FUNCTION "public"."queue_status"("p_datetime" timestamp with time zone) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $body$
DECLARE
  now_time TIME := p_datetime::time;
  today_date DATE := p_datetime::date;

  wh RECORD;
  qs RECORD;
  nb RECORD;
  next_nb RECORD;
  result_booking JSONB;
  next_result_booking JSONB;
  v_waiting_count INT;

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

  -- [CHANGE 1] لم يبدأ الطابور بعد: إرجاع NORMAL مع next_booking وwaiting_count
  IF qs.current_queue_number = 0 THEN
    SELECT COUNT(*) INTO v_waiting_count
    FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = current_shift;

    SELECT * INTO next_nb
    FROM bookings
    WHERE DATE(booking_date) = today_date
      AND shift = current_shift
    ORDER BY queue_number ASC
    LIMIT 1;

    IF next_nb IS NOT NULL THEN
      next_result_booking := jsonb_build_object(
        'queue_number', next_nb.queue_number::text,
        'ticket_code',  next_nb.ticket_code
      );
    END IF;

    RETURN jsonb_build_object(
      'state', 'NORMAL',
      'shift', current_shift,
      'current_queue_number', 0,
      'next_booking', next_result_booking,
      'waiting_count', v_waiting_count
    );
  END IF;

  -- [CHANGE 2] جلب الحجز الحالي (= current_queue_number) بدلاً من القادم (> current_queue_number)
  SELECT *
  INTO nb
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number = qs.current_queue_number
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

  -- [+] جلب الحجز القادم — بدون فلتر booking_status (مثل queue_next تماماً)
  SELECT * INTO next_nb
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number > qs.current_queue_number
  ORDER BY queue_number ASC
  LIMIT 1;

  -- [+] عدد المنتظرين — بدون فلتر booking_status
  SELECT COUNT(*) INTO v_waiting_count
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number > qs.current_queue_number;

  -- [+] بناء next_result_booking إن وُجد
  IF next_nb IS NOT NULL THEN
    next_result_booking := jsonb_build_object(
      'queue_number', next_nb.queue_number::text,
      'ticket_code',  next_nb.ticket_code
    );
  END IF;

  -- [CHANGE 3] استبدال IF NOT EXISTS بـ next_nb IS NULL (نفس المنطق، بدون استعلام مكرر)
  -- [+] إضافة next_booking و waiting_count للـ RETURN
  IF next_nb IS NULL THEN
    RETURN jsonb_build_object(
      'state',
        CASE current_shift
          WHEN 'morning' THEN 'NO_MORE_BOOKINGS_MORNING'
          WHEN 'evening' THEN 'NO_MORE_BOOKINGS_EVENING'
          ELSE 'NO_MORE_BOOKINGS'
        END,
      'shift', current_shift,
      'current_queue_number', qs.current_queue_number,
      'current_booking', result_booking,
      'next_booking',    NULL,
      'waiting_count',   0
    );
  END IF;

  -- [CHANGE 5] تغيير next_booking إلى current_booking + [+] إضافة next_booking و waiting_count
  RETURN jsonb_build_object(
    'state','NORMAL',
    'shift',current_shift,
    'current_queue_number', qs.current_queue_number,
    'current_booking', result_booking,
    'next_booking',    next_result_booking,
    'waiting_count',   v_waiting_count
  );

END;
$body$;
