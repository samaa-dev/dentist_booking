


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "http" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."account_status" AS ENUM (
    'active',
    'vacation',
    'suspended',
    'resigned',
    'terminated',
    'inactive',
    'banned',
    'paused',
    'appMaintenance'
);


ALTER TYPE "public"."account_status" OWNER TO "postgres";


CREATE TYPE "public"."announcement_audience" AS ENUM (
    'all',
    'appOnly',
    'tvOnly'
);


ALTER TYPE "public"."announcement_audience" OWNER TO "postgres";


CREATE TYPE "public"."booking_shift" AS ENUM (
    'morning',
    'evening'
);


ALTER TYPE "public"."booking_shift" OWNER TO "postgres";


CREATE TYPE "public"."booking_status" AS ENUM (
    'pending',
    'confirmed',
    'completed',
    'cancelledByPatient',
    'cancelledByStaff',
    'noShow'
);


ALTER TYPE "public"."booking_status" OWNER TO "postgres";


CREATE TYPE "public"."patient_type" AS ENUM (
    'registered',
    'guest'
);


ALTER TYPE "public"."patient_type" OWNER TO "postgres";


CREATE TYPE "public"."shift_type" AS ENUM (
    'morning',
    'evening',
    'mixed'
);


ALTER TYPE "public"."shift_type" OWNER TO "postgres";


CREATE TYPE "public"."staff_position" AS ENUM (
    'nurse',
    'receptionist',
    'assistant',
    'technician',
    'cleaner',
    'manager'
);


ALTER TYPE "public"."staff_position" OWNER TO "postgres";


CREATE TYPE "public"."user_role" AS ENUM (
    'admin',
    'doctor',
    'staff',
    'patient'
);


ALTER TYPE "public"."user_role" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."call_next_ticket"("p_shift" "public"."booking_shift" DEFAULT NULL::"public"."booking_shift") RETURNS TABLE("action_type" "text", "ticket_id" "uuid", "ticket_code" character varying, "queue_number" integer, "shift" "public"."booking_shift", "patient_name" "text", "patient_phone" "text", "message" "text", "next_in_queue" integer)
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    current_ticket RECORD;
    next_ticket_record RECORD;
    current_shift public.booking_shift;
BEGIN
    -- تحديد الشيفت الحالي إذا لم يتم تحديده
    IF p_shift IS NULL THEN
        SELECT INTO current_shift 
            CASE 
                WHEN EXTRACT(HOUR FROM CURRENT_TIME) < 12 THEN 'morning'::booking_shift
                ELSE 'evening'::booking_shift
            END;
    ELSE
        current_shift := p_shift;
    END IF;

    -- البحث عن التذكرة التالية (الأصغر queue_number ولم تكتمل)
    SELECT 
        b.id,
        b.ticket_code,
        b.queue_number,
        b.shift,
        CASE 
            WHEN b.patient_type = 'registered' THEN p.full_name
            ELSE b.guest_name
        END as patient_name,
        CASE 
            WHEN b.patient_type = 'registered' THEN p.phone
            ELSE b.guest_phone
        END as patient_phone
    INTO current_ticket
    FROM 
        public.bookings b
    LEFT JOIN 
        public.profiles p ON b.patient_id = p.user_id
    WHERE 
        DATE(b.booking_date) = CURRENT_DATE
        AND b.shift = current_shift
        AND b.booking_status = 'confirmed'
        AND b.completed_at IS NULL
        AND b.cancelled_at IS NULL
    ORDER BY 
        b.queue_number ASC
    LIMIT 1;

    -- إذا وجدت تذكرة
    IF current_ticket.id IS NOT NULL THEN
        -- تحديث التذكرة كمكتملة (تم استدعاؤها)
        UPDATE public.bookings 
        SET 
            completed_at = NOW(),
            updated_at = NOW(),
            booking_status = 'completed'
        WHERE id = current_ticket.id;

        -- البحث عن التذكرة التالية بعد الاستدعاء
        SELECT 
            queue_number
        INTO next_ticket_record
        FROM 
            public.bookings 
        WHERE 
            DATE(booking_date) = CURRENT_DATE
            AND shift = current_shift
            AND booking_status = 'confirmed'
            AND completed_at IS NULL
            AND cancelled_at IS NULL
        ORDER BY 
            queue_number ASC
        LIMIT 1;

        -- إرجاع بيانات التذكرة المستدعاة
        action_type := 'called';
        ticket_id := current_ticket.id;
        ticket_code := current_ticket.ticket_code;
        queue_number := current_ticket.queue_number;
        shift := current_shift;
        patient_name := current_ticket.patient_name;
        patient_phone := current_ticket.patient_phone;
        message := 'تم استدعاء التذكرة بنجاح';
        next_in_queue := next_ticket_record.queue_number;

        RETURN NEXT;
    ELSE
        -- لا توجد تذاكر
        action_type := 'no_tickets';
        ticket_id := NULL;
        ticket_code := NULL;
        queue_number := NULL;
        shift := current_shift;
        patient_name := NULL;
        patient_phone := NULL;
        message := 'لا توجد تذاكر في الانتظار لهذا الشيفت';
        next_in_queue := NULL;

        RETURN NEXT;
    END IF;
END;
$$;


ALTER FUNCTION "public"."call_next_ticket"("p_shift" "public"."booking_shift") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."can_book"("p_booking_datetime" timestamp without time zone, "p_shift" "public"."booking_shift", "p_patient_type" "public"."patient_type", "p_patient_id" "uuid" DEFAULT NULL::"uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  booking_date date := DATE(p_booking_datetime);
  booking_time time := p_booking_datetime::time;

  iso INT;
  dow INT;

  wh RECORD;
  cs RECORD;

  existing_count INT;
  already_booked INT;

  allowed_start TIME;
  allowed_end TIME;

  user_role public.user_role;
BEGIN
  ---------------------------------------------------------------------
  -- 1) Get user role
  ---------------------------------------------------------------------
  SELECT public.current_user_role() INTO user_role;

  ---------------------------------------------------------------------
  -- 2) Convert weekday (Saturday = 1)
  ---------------------------------------------------------------------
  iso := EXTRACT(isodow FROM booking_date);
  dow := CASE 
           WHEN iso = 6 THEN 1
           WHEN iso = 7 THEN 2
           ELSE iso + 2
         END;

  ---------------------------------------------------------------------
  -- 3) Load working hours
  ---------------------------------------------------------------------
  SELECT * INTO wh
  FROM working_hours
  WHERE day_of_week = dow;

  IF wh IS NULL THEN
    RETURN jsonb_build_object(
      'can_book', false, 
      'reason', 'day_not_exist',
      'message', jsonb_build_object(
        'ar', 'اليوم المحدد غير متوفر للحجوزات',
        'en', 'The selected day is not available for bookings'
      )
    );
  END IF;

  IF NOT wh.is_open THEN
    RETURN jsonb_build_object(
      'can_book', false, 
      'reason', 'clinic_closed',
      'message', jsonb_build_object(
        'ar', 'العيادة مغلقة في هذا اليوم',
        'en', 'Clinic is closed on this day'
      )
    );
  END IF;

  ---------------------------------------------------------------------
  -- 4) Load clinic settings
  ---------------------------------------------------------------------
  SELECT * INTO cs
  FROM clinic_settings
  WHERE id = 1;

  IF NOT cs.is_booking_enabled THEN
    RETURN jsonb_build_object(
      'can_book', false, 
      'reason', 'booking_disabled',
      'message', jsonb_build_object(
        'ar', 'نظام الحجوزات معطل حالياً',
        'en', 'Booking system is currently disabled'
      )
    );
  END IF;

  ---------------------------------------------------------------------
  -- 5) Morning shift
  ---------------------------------------------------------------------
  IF p_shift = 'morning' THEN
    -- تحقق من أن morning_end ليس NULL
    IF wh.morning_end IS NULL THEN
      RETURN jsonb_build_object(
        'can_book', false, 
        'reason', 'invalid_working_hours',
        'message', jsonb_build_object(
          'ar', 'أوقات العمل غير محددة للفترة المحدد',
          'en', 'Working hours are not specified for the selected period'
        )
      );
    END IF;

    allowed_start := cs.booking_morning_start_time;
    allowed_end := wh.morning_end - (cs.allow_before_minutes * INTERVAL '1 minute');

    IF booking_time < allowed_start THEN
      RETURN jsonb_build_object(
        'can_book', false, 
        'reason', 'too_early_morning',
        'message', jsonb_build_object(
          'ar', 'الحجز الصباحي يبدأ من الساعة ' || allowed_start || ' يرجى اختيار وقت لاحق',
          'en', 'Morning booking starts from ' || allowed_start || ' please choose a later time',
          'allowed_start', allowed_start
        )
      );
    END IF;

    IF booking_time > allowed_end THEN
      RETURN jsonb_build_object(
        'can_book', false, 
        'reason', 'too_late_morning',
        'message', jsonb_build_object(
          'ar', 'لقد تجاوزت وقت الحجز الصباحي، يرجى التسجيل في المسائي',
          'en', 'You have exceeded the morning booking time, please register for the evening shift'
        )
      );
    END IF;
  END IF;

  ---------------------------------------------------------------------
  -- 6) Evening shift
  ---------------------------------------------------------------------
  IF p_shift = 'evening' THEN
    -- تحقق من أن evening_end ليس NULL
    IF wh.evening_end IS NULL THEN
      RETURN jsonb_build_object(
        'can_book', false, 
        'reason', 'invalid_working_hours',
        'message', jsonb_build_object(
          'ar', 'أوقات العمل غير محددة للفترة المحدد',
          'en', 'Working hours are not specified for the selected period'
        )
      );
    END IF;

    allowed_start := TIME '00:00';
    allowed_end := wh.evening_end - (cs.allow_before_minutes * INTERVAL '1 minute');

    IF booking_time < allowed_start THEN
      RETURN jsonb_build_object(
        'can_book', false, 
        'reason', 'too_early_evening',
        'message', jsonb_build_object(
          'ar', 'وقت الحجز غير مناسب للفترة المسائية',
          'en', 'Booking time is not suitable for the evening period'
        )
      );
    END IF;

    IF booking_time > allowed_end THEN
      RETURN jsonb_build_object(
        'can_book', false, 
        'reason', 'too_late_evening',
        'message', jsonb_build_object(
          'ar', 'لقد تجاوزت وقت الحجز المسائي',
          'en', 'You have exceeded the evening booking time'
        )
      );
    END IF;
  END IF;

  ---------------------------------------------------------------------
  -- 7) Admin/Staff bypass
  ---------------------------------------------------------------------
  IF user_role IN ('admin','staff') THEN
    RETURN jsonb_build_object(
      'can_book', true, 
      'reason', 'allowed_admin_staff',
      'message', jsonb_build_object(
        'ar', 'تم السماح للحجز (موظف/مدير)',
        'en', 'Booking allowed (staff/admin)'
      )
    );
  END IF;

  ---------------------------------------------------------------------
  -- 8) Capacity check
  ---------------------------------------------------------------------
  SELECT COUNT(*)
  INTO existing_count
  FROM bookings
  WHERE DATE(booking_date) = booking_date
    AND shift = p_shift
    AND booking_status IN ('pending','confirmed')
    AND booking_created_by NOT IN (
        SELECT user_id FROM profiles WHERE role IN ('admin','staff')
    );

  IF p_shift = 'morning' AND existing_count >= cs.morning_count_limit THEN
    RETURN jsonb_build_object(
      'can_book', false, 
      'reason', 'morning_full',
      'message', jsonb_build_object(
        'ar', 'لقد تم تعبئة الحجز الصباحي، يرجى التسجيل في المسائي',
        'en', 'Morning shift is full, please register for the evening shift'
      )
    );
  END IF;

  IF p_shift = 'evening' AND existing_count >= cs.evening_count_limit THEN
    RETURN jsonb_build_object(
      'can_book', false, 
      'reason', 'evening_full',
      'message', jsonb_build_object(
        'ar', 'لقد تم تعبئة الحجز المسائي',
        'en', 'Evening shift is full'
      )
    );
  END IF;

  ---------------------------------------------------------------------
  -- 9) Registered patient cannot book twice per day
  ---------------------------------------------------------------------
  IF p_patient_type = 'registered' THEN
    SELECT COUNT(*)
    INTO already_booked
    FROM bookings
    WHERE patient_id = p_patient_id
      AND DATE(booking_date) = booking_date
      AND booking_status IN ('pending','confirmed');

    IF already_booked > 0 THEN
      RETURN jsonb_build_object(
        'can_book', false, 
        'reason', 'already_booked',
        'message', jsonb_build_object(
          'ar', 'لديك حجز مسبق في هذا اليوم',
          'en', 'You already have a booking for this day'
        )
      );
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'can_book', true, 
    'reason', 'allowed',
    'message', jsonb_build_object(
      'ar', 'يمكنك المتابعة مع الحجز',
      'en', 'You can proceed with the booking'
    )
  );
END;
$$;


ALTER FUNCTION "public"."can_book"("p_booking_datetime" timestamp without time zone, "p_shift" "public"."booking_shift", "p_patient_type" "public"."patient_type", "p_patient_id" "uuid") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."announcements" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "body" "text" NOT NULL,
    "images" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "audience" "public"."announcement_audience" DEFAULT 'all'::"public"."announcement_audience" NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_by_user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "link_url" "text"
);


ALTER TABLE "public"."announcements" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_announcement"("p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_created_by_user_id" "uuid") RETURNS "public"."announcements"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  new_row announcements;
BEGIN
  INSERT INTO announcements (
    title,
    body,
    audience,
    images,
    is_active,
    created_by_user_id
  )
  VALUES (
    p_title,
    p_body,
    p_link_url,
    p_audience,
    p_images,
    p_is_active,
    p_created_by_user_id
  )
  RETURNING * INTO new_row;

  RETURN new_row;
END;
$$;


ALTER FUNCTION "public"."create_announcement"("p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_created_by_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_booking"("p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  check_result JSONB;
  new_booking bookings%ROWTYPE;
  next_queue INT;
  people_before_count INT;
  ticket_code_val VARCHAR(12);
  formatted_queue_number TEXT;
  result_data JSONB;

  booking_day DATE := DATE(p_booking_date);
BEGIN
  ------------------------------------------------------------------
  -- 1) التحقق من إمكانية الحجز
  ------------------------------------------------------------------
  check_result := can_book(
    p_booking_date,
    p_shift,
    p_patient_type,
    p_patient_id
  );

  IF (check_result->>'can_book') = 'false' THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', check_result->>'reason'
    );
  END IF;

  ------------------------------------------------------------------
  -- 2) حساب رقم الدور (queue_number) 
  ------------------------------------------------------------------
  WITH existing_bookings AS (
    SELECT queue_number
    FROM bookings
    WHERE DATE(booking_date) = booking_day
      AND shift = p_shift
      AND booking_status IN ('pending','confirmed')
  )
  SELECT COALESCE(MAX(queue_number), 0) + 1
  INTO next_queue
  FROM existing_bookings;

  -- تنسيق queue_number كـ 0001
  formatted_queue_number := LPAD(next_queue::TEXT, 4, '0');

  ------------------------------------------------------------------
  -- 3) إنشاء ticket_code فريد
  ------------------------------------------------------------------
  ticket_code_val := generate_unique_ticket_code();

  ------------------------------------------------------------------
  -- 4) إدخال سجل الحجز
  ------------------------------------------------------------------
  INSERT INTO bookings (
      booking_date,
      patient_id,
      patient_type,
      guest_name,
      guest_phone,
      guest_address,
      shift,
      booking_status,
      booking_created_by,
      queue_number,
      ticket_code,
      created_at,
      updated_at,
      cancelled_at,
      completed_at,
      cancelled_by,
      cancel_reason
  )
  VALUES (
      p_booking_date,
      p_patient_id,
      p_patient_type,
      p_guest_name,
      p_guest_phone,
      p_guest_address,
      p_shift,
      p_booking_status,
      p_booking_created_by,
      next_queue,
      ticket_code_val,
      p_created_at,
      p_updated_at,
      p_cancelled_at,
      p_completed_at,
      p_cancelled_by,
      p_cancel_reason
  )
  RETURNING * INTO new_booking;

  ------------------------------------------------------------------
  -- 5) حساب people_before
  ------------------------------------------------------------------
  SELECT COUNT(*)
  INTO people_before_count
  FROM bookings b2
  WHERE DATE(b2.booking_date) = booking_day
    AND b2.shift = new_booking.shift
    AND b2.booking_status IN ('pending','confirmed')
    AND b2.queue_number < new_booking.queue_number;

  ------------------------------------------------------------------
  -- 6) بناء data النهائية
  ------------------------------------------------------------------
  result_data := jsonb_build_object(
    'id', new_booking.id,
    'booking_date', new_booking.booking_date,
    'patient_id', new_booking.patient_id,
    'patient_type', new_booking.patient_type,
    'guest_name', new_booking.guest_name,
    'guest_phone', new_booking.guest_phone,
    'guest_address', new_booking.guest_address,
    'shift', new_booking.shift,
    'booking_status', new_booking.booking_status,
    'booking_created_by', new_booking.booking_created_by,
    'queue_number', formatted_queue_number,
    'ticket_code', new_booking.ticket_code,
    'people_before', people_before_count,
    'created_at', new_booking.created_at,
    'updated_at', new_booking.updated_at,
    'cancelled_at', new_booking.cancelled_at,
    'completed_at', new_booking.completed_at,
    'cancelled_by', new_booking.cancelled_by,
    'cancel_reason', new_booking.cancel_reason
  );

  ------------------------------------------------------------------
  -- 7) النتيجة النهائية
  ------------------------------------------------------------------
  RETURN jsonb_build_object(
    'success', true,
    'data', result_data
  );
END;
$$;


ALTER FUNCTION "public"."create_booking"("p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_staff"("p_user_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status" DEFAULT 'active'::"public"."account_status") RETURNS TABLE("id" "uuid", "user_id" "uuid", "full_name" "text", "email" "text", "phone" "text", "position" "public"."staff_position", "shift_type" "public"."shift_type", "account_status" "public"."account_status", "created_at" timestamp with time zone, "updated_at" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  -- 1) إنشاء الموظف
  RETURN QUERY
  WITH inserted AS (
    INSERT INTO public.staff AS s (
      user_id,
      full_name,
      email,
      phone,
      position,
      shift_type,
      status
    )
    VALUES (
      p_user_id,
      p_full_name,
      p_email,
      p_phone,
      p_position,
      p_shift,
      p_status
    )
    RETURNING s.*
  ),

  -- 2) تحديث role داخل profiles بعد الإدراج
  updated_profile AS (
    UPDATE public.profiles p
    SET 
      role = 'staff'::public.user_role,   -- 👈 إضافة role
      status = p_status,                  -- 👈 إضافة status
      updated_at = NOW()
    WHERE p.user_id = p_user_id
    RETURNING p.user_id
  )

  -- 3) إرجاع بيانات الموظف الجديدة
  SELECT
    i.id,
    i.user_id,
    i.full_name,
    i.email,
    i.phone,
    i.position,
    i.shift_type,
    i.status AS account_status,
    i.created_at,
    i.updated_at
  FROM inserted i;
END;
$$;


ALTER FUNCTION "public"."create_staff"("p_user_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."current_user_role"() RETURNS "public"."user_role"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  r public.user_role;
BEGIN
  SELECT role INTO r
  FROM public.profiles
  WHERE user_id = auth.uid();

  RETURN r;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;
$$;


ALTER FUNCTION "public"."current_user_role"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_announcement"("p_id" "uuid") RETURNS TABLE("deleted_id" "uuid")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  DELETE FROM announcements
  WHERE id = p_id
  RETURNING id;
END;
$$;


ALTER FUNCTION "public"."delete_announcement"("p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_booking"("p_booking_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
declare
  exists_count int;
begin
  -- تحقق: هل الحجز موجود؟
  select count(*) into exists_count
  from bookings
  where id = p_booking_id;

  if exists_count = 0 then
    return jsonb_build_object(
      'success', false,
      'reason', 'booking_not_found'
    );
  end if;

  -- تنفيذ حذف الحجز
  delete from bookings
  where id = p_booking_id;

  return jsonb_build_object(
    'success', true,
    'reason', 'deleted'
  );
end;
$$;


ALTER FUNCTION "public"."delete_booking"("p_booking_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."delete_staff"("p_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  delete from public.staff s
    where s.id = p_id;

  return found;
end;
$$;


ALTER FUNCTION "public"."delete_staff"("p_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."generate_unique_ticket_code"() RETURNS character varying
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  new_number INT;
  new_code VARCHAR(12);
  counter INTEGER := 0;
BEGIN
  LOOP
    -- توليد رقم عشوائي بين 1 و 9999
    new_number := FLOOR(RANDOM() * 9999) + 1;
    
    -- تنسيق الرقم كـ 00001
    new_code := 'TIC-' || LPAD(new_number::TEXT, 4, '0');
    
    -- التحقق من عدم التكرار
    IF NOT EXISTS (SELECT 1 FROM bookings WHERE ticket_code = new_code) THEN
      RETURN new_code;
    END IF;
    
    -- منع loop لا نهائي
    counter := counter + 1;
    IF counter > 100 THEN
      RAISE EXCEPTION 'Unable to generate unique ticket code after 100 attempts';
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."generate_unique_ticket_code"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_all_announcements"() RETURNS TABLE("id" "uuid", "title" "text", "body" "text", "link_url" "text", "audience" "public"."announcement_audience", "images" "jsonb", "is_active" boolean, "created_by_user_id" "uuid", "created_at" timestamp with time zone, "updated_at" timestamp with time zone)
    LANGUAGE "sql"
    AS $$
  SELECT 
    a.id,
    a.title,
    a.body,
    a.link_url, 
    a.audience::public.announcement_audience,
    a.images,
    a.is_active,
    a.created_by_user_id,
    a.created_at,
    a.updated_at
  FROM public.announcements a
  ORDER BY a.created_at DESC;
$$;


ALTER FUNCTION "public"."get_all_announcements"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_all_bookings"("p_start_date" "date" DEFAULT NULL::"date", "p_end_date" "date" DEFAULT NULL::"date", "p_specific_date" "date" DEFAULT NULL::"date") RETURNS TABLE("id" "uuid", "booking_date" timestamp with time zone, "patient_id" "uuid", "patient_type" "public"."patient_type", "patient_name" "text", "patient_phone" "text", "patient_address" "text", "shift" "public"."booking_shift", "booking_status" "public"."booking_status", "booking_created_by" "uuid", "queue_number" "text", "ticket_code" "text", "people_before" integer, "created_at" timestamp with time zone, "updated_at" timestamp with time zone, "cancelled_at" timestamp with time zone, "completed_at" timestamp with time zone, "cancelled_by" "uuid", "cancel_reason" "text")
    LANGUAGE "sql"
    AS $$
  WITH filtered_bookings AS (
    SELECT *
    FROM bookings b
    WHERE 
      -- إذا تم تحديد تاريخ محدد
      (p_specific_date IS NOT NULL AND DATE(b.booking_date) = p_specific_date)
      OR
      -- إذا تم تحديد فترة زمنية
      (p_start_date IS NOT NULL AND p_end_date IS NOT NULL AND 
       DATE(b.booking_date) BETWEEN p_start_date AND p_end_date)
      OR
      -- إذا لم يتم تحديد أي تصفية، إرجاع جميع البيانات
      (p_specific_date IS NULL AND p_start_date IS NULL AND p_end_date IS NULL)
  ),
  ranked AS (
    SELECT
      fb.*,
      -- رقم الانتظار داخل اليوم والشفت
      ROW_NUMBER() OVER (
        PARTITION BY DATE(fb.booking_date), fb.shift
        ORDER BY fb.booking_date ASC
      ) AS rn,

      -- عدد الأشخاص قبله
      (
        ROW_NUMBER() OVER (
          PARTITION BY DATE(fb.booking_date), fb.shift
          ORDER BY fb.booking_date ASC
        ) - 1
      ) AS pb
    FROM filtered_bookings fb
  )
  SELECT
    r.id,
    r.booking_date,
    r.patient_id,
    r.patient_type,

    -- Patient Name
    CASE 
      WHEN r.patient_type = 'registered'
        THEN COALESCE(
          p.meta -> 'raw_user_meta_data' ->> 'full_name',
          p.meta ->> 'name',
          'Unknown'
        )
      ELSE r.guest_name
    END AS patient_name,

    -- Patient Phone
    CASE
      WHEN r.patient_type = 'registered'
        THEN COALESCE(
          p.meta ->> 'phone',
          p.meta -> 'raw_user_meta_data' ->> 'phone',
          ''
        )
      ELSE r.guest_phone
    END AS patient_phone,

    -- Patient Address
    CASE
      WHEN r.patient_type = 'registered'
        THEN COALESCE(
          p.meta -> 'raw_user_meta_data' ->> 'address',
          ''
        )
      ELSE r.guest_address
    END AS patient_address,

    r.shift,
    r.booking_status,
    r.booking_created_by,

    -- تنسيق queue_number كـ 0001
    LPAD(r.queue_number::text, 4, '0') AS queue_number,
    
    -- إضافة ticket_code
    r.ticket_code,

    r.pb AS people_before,

    r.created_at,
    r.updated_at,
    r.cancelled_at,
    r.completed_at,
    r.cancelled_by,
    r.cancel_reason

  FROM ranked r
  LEFT JOIN profiles p ON p.user_id = r.patient_id
  ORDER BY 
    DATE(r.booking_date) DESC,   -- التاريخ من الأحدث إلى الأقدم
    r.shift,   
    r.queue_number ASC;         -- رقم الدور من الأكبر إلى الأصغر
$$;


ALTER FUNCTION "public"."get_all_bookings"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_all_bookings_with_filters"("p_start_date" "date" DEFAULT NULL::"date", "p_end_date" "date" DEFAULT NULL::"date", "p_specific_date" "date" DEFAULT NULL::"date", "p_status" "public"."booking_status" DEFAULT NULL::"public"."booking_status", "p_shift" "public"."booking_shift" DEFAULT NULL::"public"."booking_shift", "p_search_query" "text" DEFAULT NULL::"text") RETURNS TABLE("id" "uuid", "booking_date" timestamp with time zone, "patient_id" "uuid", "patient_type" "public"."patient_type", "patient_name" "text", "patient_phone" "text", "patient_address" "text", "shift" "public"."booking_shift", "booking_status" "public"."booking_status", "booking_created_by" "uuid", "queue_number" "text", "ticket_code" "text", "people_before" integer, "created_at" timestamp with time zone, "updated_at" timestamp with time zone, "cancelled_at" timestamp with time zone, "completed_at" timestamp with time zone, "cancelled_by" "uuid", "cancel_reason" "text")
    LANGUAGE "sql"
    AS $$
  WITH filtered_bookings AS (
    SELECT *
    FROM bookings b
    WHERE
      
      -----------------------------------------
      -- 📌 فلترة التاريخ — منطق صحيح 100%
      -----------------------------------------
      (
        -- 1) تاريخ محدد (يوم واحد)
        (p_specific_date IS NOT NULL AND DATE(b.booking_date) = p_specific_date)

        OR

        -- 2) تحديد فترة (range)
        (p_specific_date IS NULL AND p_start_date IS NOT NULL AND p_end_date IS NOT NULL
          AND DATE(b.booking_date) BETWEEN p_start_date AND p_end_date)

        OR

        -- 3) بدون أي فلترة تاريخ
        (p_specific_date IS NULL AND p_start_date IS NULL AND p_end_date IS NULL)
      )

      -----------------------------------------
      -- 📌 فلترة الحالة
      -----------------------------------------
      AND (p_status IS NULL OR b.booking_status = p_status)

      -----------------------------------------
      -- 📌 فلترة الوردية SHIFT — إصلاح كامل
      -----------------------------------------
      AND (p_shift IS NULL OR b.shift = p_shift)

      -----------------------------------------
      -- 📌 فلترة البحث (Name — Phone — Address — Ticket)
      -----------------------------------------
      AND (
        p_search_query IS NULL OR p_search_query = '' OR (

          -- البحث في registered patient
          (
            b.patient_type = 'registered' AND EXISTS (
              SELECT 1 FROM profiles p 
              WHERE p.user_id = b.patient_id AND (
                p.meta -> 'raw_user_meta_data' ->> 'full_name' ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'name' ILIKE '%' || p_search_query || '%'
                OR p.meta ->> 'phone' ILIKE '%' || p_search_query || '%'
                OR p.meta -> 'raw_user_meta_data' ->> 'phone' ILIKE '%' || p_search_query || '%'
                OR p.meta -> 'raw_user_meta_data' ->> 'address' ILIKE '%' || p_search_query || '%'
              )
            )
          )

          OR

          -- البحث في guest patient
          (
            b.patient_type = 'guest'
            AND (
              b.guest_name ILIKE '%' || p_search_query || '%'
              OR b.guest_phone ILIKE '%' || p_search_query || '%'
              OR b.guest_address ILIKE '%' || p_search_query || '%'
            )
          )

          OR

          -- البحث في ticket
          b.ticket_code ILIKE '%' || p_search_query || '%'
        )
      )
  ),

  ranked AS (
    SELECT
      fb.*,
      ROW_NUMBER() OVER (
        PARTITION BY DATE(fb.booking_date), fb.shift
        ORDER BY fb.booking_date ASC
      ) AS rn,
      (
        ROW_NUMBER() OVER (
          PARTITION BY DATE(fb.booking_date), fb.shift
          ORDER BY fb.booking_date ASC
        ) - 1
      ) AS pb
    FROM filtered_bookings fb
  )

  SELECT
    r.id,
    r.booking_date,
    r.patient_id,
    r.patient_type,

    -- patient_name
    CASE 
      WHEN r.patient_type = 'registered'
        THEN COALESCE(
          p.meta -> 'raw_user_meta_data' ->> 'full_name',
          p.meta ->> 'name',
          'Unknown'
        )
      ELSE r.guest_name
    END AS patient_name,

    -- patient_phone
    CASE
      WHEN r.patient_type = 'registered'
        THEN COALESCE(
          p.meta ->> 'phone',
          p.meta -> 'raw_user_meta_data' ->> 'phone',
          ''
        )
      ELSE r.guest_phone
    END AS patient_phone,

    -- patient_address
    CASE
      WHEN r.patient_type = 'registered'
        THEN COALESCE(
          p.meta -> 'raw_user_meta_data' ->> 'address',
          ''
        )
      ELSE r.guest_address
    END AS patient_address,

    r.shift,
    r.booking_status,
    r.booking_created_by,
    LPAD(r.queue_number::text, 4, '0') AS queue_number,
    r.ticket_code,
    r.pb AS people_before,
    r.created_at,
    r.updated_at,
    r.cancelled_at,
    r.completed_at,
    r.cancelled_by,
    r.cancel_reason

  FROM ranked r
  LEFT JOIN profiles p ON p.user_id = r.patient_id

  ORDER BY 
    DATE(r.booking_date) DESC,
    r.shift,
    r.queue_number ASC;
$$;


ALTER FUNCTION "public"."get_all_bookings_with_filters"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date", "p_status" "public"."booking_status", "p_shift" "public"."booking_shift", "p_search_query" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_all_patients"() RETURNS TABLE("user_id" "uuid", "meta" "jsonb", "role" "public"."user_role", "status" "public"."account_status", "created_at" timestamp with time zone, "updated_at" timestamp with time zone, "last_seen" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$BEGIN
  -- 🔐 السماح فقط للإدمن باستدعاء الدالة
  -- IF NOT public.is_admin_user() THEN
  --   RAISE EXCEPTION 'Access denied: only admin can view patient list';
  -- END IF;

  -- ✔ إرجاع المستخدمين الذين role = 'patient'
  RETURN QUERY
    SELECT
      p.user_id,
      p.meta,
      p.role,
      p.status,
      p.created_at,
      p.updated_at,
      p.last_seen
    FROM public.profiles p
    WHERE p.role = 'patient'::public.user_role
    ORDER BY p.last_seen DESC;

END;$$;


ALTER FUNCTION "public"."get_all_patients"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_all_profile"() RETURNS TABLE("user_id" "uuid", "meta" "jsonb")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  -- 🔐 لا يسمح إلا للـ Admin باستدعاء الدالة
  IF NOT public.is_admin_user() THEN
    RAISE EXCEPTION 'Access denied: only admin can view profiles';
  END IF;

  -- ✔ إرجاع جميع المستخدمين باستثناء الإدمن
  RETURN QUERY
    SELECT
      p.user_id,
      p.meta
      -- p.role,
      -- p.status,
      -- p.created_at,
      -- p.updated_at,
      -- p.last_seen
    FROM public.profiles p
    WHERE p.role <> 'admin'::public.user_role   -- 👈 هذا هو الشرط
    ORDER BY p.created_at DESC;

END;
$$;


ALTER FUNCTION "public"."get_all_profile"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_all_staff"() RETURNS TABLE("id" "uuid", "user_id" "uuid", "full_name" "text", "email" "text", "phone" "text", "position" "public"."staff_position", "shift_type" "public"."shift_type", "account_status" "public"."account_status", "created_at" timestamp with time zone, "updated_at" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    s.id,
    s.user_id,
    s.full_name,
    s.email,
    s.phone,
    s.position,
    s.shift_type,
    s.status AS account_status,   -- ✔ التعديل هنا
    s.created_at,
    s.updated_at
  FROM public.staff s
  ORDER BY s.created_at DESC;
END;
$$;


ALTER FUNCTION "public"."get_all_staff"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_current_shift"() RETURNS "public"."booking_shift"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  wh RECORD;
  now_time TIME := NOW()::time;
  iso INT := EXTRACT(isodow FROM CURRENT_DATE);
  dow INT;
BEGIN
  -- تحويل اليوم لنظامك (السبت = 1)
  dow := CASE
           WHEN iso = 6 THEN 1
           WHEN iso = 7 THEN 2
           ELSE iso + 2
         END;

  SELECT * INTO wh
  FROM working_hours
  WHERE day_of_week = dow;

  IF wh IS NULL OR wh.is_open = FALSE THEN
    RETURN NULL; -- مغلق
  END IF;

  IF now_time BETWEEN wh.morning_start AND wh.morning_end THEN
    RETURN 'morning';
  ELSIF now_time BETWEEN wh.evening_start AND wh.evening_end THEN
    RETURN 'evening';
  ELSE
    RETURN NULL; -- خارج أوقات العمل
  END IF;
END;
$$;


ALTER FUNCTION "public"."get_current_shift"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_daily_bookings"("p_date" "date") RETURNS TABLE("id" "uuid", "patient_type" "public"."patient_type", "patient_id" "uuid", "guest_name" "text", "guest_phone" "text", "booking_time" time without time zone, "shift" "public"."booking_shift", "booking_status" "public"."booking_status", "created_at" timestamp with time zone)
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
  select
    b.id,
    b.patient_type,
    b.patient_id,
    b.guest_name,
    b.guest_phone,
    b.booking_time,
    b.shift,
    b.booking_status,
    b.created_at
  from bookings b
  where b.booking_date = p_date
  order by b.booking_time asc;
$$;


ALTER FUNCTION "public"."get_daily_bookings"("p_date" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_daily_bookings"("p_date" "date", "p_shift" "public"."booking_shift" DEFAULT NULL::"public"."booking_shift") RETURNS TABLE("id" "uuid", "patient_type" "public"."patient_type", "patient_id" "uuid", "guest_name" "text", "guest_phone" "text", "booking_time" time without time zone, "shift" "public"."booking_shift", "booking_status" "public"."booking_status", "created_at" timestamp with time zone, "updated_at" timestamp with time zone)
    LANGUAGE "sql"
    AS $$
  select 
    b.id,
    b.patient_type,
    b.patient_id,
    b.guest_name,
    b.guest_phone,
    b.booking_time,
    b.shift,
    b.booking_status,
    b.created_at,
    b.updated_at
  from bookings b
  where b.booking_date = p_date
    and (p_shift is null or b.shift = p_shift)
  order by b.booking_time asc;
$$;


ALTER FUNCTION "public"."get_daily_bookings"("p_date" "date", "p_shift" "public"."booking_shift") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_dashboard_full_stats"() RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
declare
  -- ===============================
  -- اليوم
  -- ===============================
  total_bookings_today int;
  confirmed_today int;
  cancelled_today int;
  no_show_today int;
  new_patients_today int;
  total_staff int;
  active_announcements int;

  -- ===============================
  -- الأسبوع
  -- ===============================
  weekly_counts int[];
  
  -- ===============================
  -- insights
  -- ===============================
  peak_hour_start text;
  peak_hour_end text;
  avg_wait_mins int;
  most_active_staff text;

  -- ===============================
  -- آخر الأنشطة
  -- ===============================
  latest_logs jsonb;
begin
  --------------------------------------------------------------------
  -- 1) إحصائيات اليوم
  --------------------------------------------------------------------
  select count(*) into total_bookings_today
  from bookings
  where booking_date = current_date;

  select count(*) into confirmed_today
  from bookings
  where booking_date = current_date
    and booking_status = 'confirmed';

  select count(*) into cancelled_today
  from bookings
  where booking_date = current_date
    and booking_status in ('cancelledByPatient','cancelledByStaff');

  select count(*) into no_show_today
  from bookings
  where booking_date = current_date
    and booking_status = 'noShow';

  select count(*) into new_patients_today
  from profiles
  where role = 'patient'
    and created_at::date = current_date;

  select count(*) into total_staff from staff;

  select count(*) into active_announcements
  from announcements
  where is_active = true;

  --------------------------------------------------------------------
  -- 2) Weekly Stats (7 أيام)
  --------------------------------------------------------------------
  select array[
    (select count(*) from bookings where booking_date = current_date - 6),
    (select count(*) from bookings where booking_date = current_date - 5),
    (select count(*) from bookings where booking_date = current_date - 4),
    (select count(*) from bookings where booking_date = current_date - 3),
    (select count(*) from bookings where booking_date = current_date - 2),
    (select count(*) from bookings where booking_date = current_date - 1),
    (select count(*) from bookings where booking_date = current_date)
  ] into weekly_counts;

  --------------------------------------------------------------------
  -- 3) Insights
  --------------------------------------------------------------------
  -- أكثر فترة ازدحاماً (تجريبية)
  peak_hour_start := '09:00';
  peak_hour_end   := '11:00';

  -- متوسط وقت الانتظار (تجريبي)
  avg_wait_mins := 12;

  -- الموظف الأكثر نشاطاً (تجريبي)
  most_active_staff := 'أحمد';

  --------------------------------------------------------------------
  -- 4) آخر الأنشطة (آخر 5 عمليات)
  --------------------------------------------------------------------
  select jsonb_agg(row_to_json(t)) into latest_logs
  from (
    select title, created_at
    from announcements
    order by created_at desc
    limit 5
  ) t;

  --------------------------------------------------------------------
  -- RETURN JSON
  --------------------------------------------------------------------
  return jsonb_build_object(
    'daily', jsonb_build_object(
      'total_bookings_today', total_bookings_today,
      'confirmed_today', confirmed_today,
      'cancelled_today', cancelled_today,
      'no_show_today', no_show_today,
      'new_patients_today', new_patients_today,
      'total_staff', total_staff,
      'active_announcements', active_announcements
    ),
    'weekly', jsonb_build_object(
      'counts', weekly_counts
    ),
    'insights', jsonb_build_object(
      'peak_hour_start', peak_hour_start,
      'peak_hour_end', peak_hour_end,
      'avg_wait_mins', avg_wait_mins,
      'most_active_staff', most_active_staff
    ),
    'latest_logs', latest_logs
  );
end;
$$;


ALTER FUNCTION "public"."get_dashboard_full_stats"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_dashboard_stats"() RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
declare
  -- Daily stats
  total_bookings_today int := 0;
  confirmed_today int := 0;
  cancelled_today int := 0;
  no_show_today int := 0;
  new_patients_today int := 0;
  total_staff int := 0;
  active_announcements int := 0;

  -- Weekly stats
  weekly_counts int[] := '{}';

  -- Today summary (working hours)
  v_morning_start time;
  v_morning_end   time;
  v_evening_start time;
  v_evening_end   time;

  -- Clinic settings
  v_morning_limit int := 10;
  v_evening_limit int := 10;

  -- Load ratio
  v_limit int := 0;
  load_ratio numeric := 0;

  -- Today day of week
  dow int := extract(isodow from now());
begin
  ---------------------------------------------------------------------------
  -- DAILY STATS
  ---------------------------------------------------------------------------
  select count(*) into total_bookings_today
  from bookings
  where booking_date = current_date;

  select count(*) into confirmed_today
  from bookings
  where booking_date = current_date
    and booking_status = 'confirmed';

  select count(*) into cancelled_today
  from bookings
  where booking_date = current_date
    and booking_status in ('cancelledByPatient','cancelledByStaff');

  select count(*) into no_show_today
  from bookings
  where booking_date = current_date
    and booking_status = 'noShow';

  select count(*) into new_patients_today
  from profiles
  where role = 'patient'
    and created_at::date = current_date;

  select count(*) into total_staff
  from staff;

  select count(*) into active_announcements
  from announcements
  where is_active = true;

  ---------------------------------------------------------------------------
  -- WEEKLY BOOKINGS (Sat → Fri)
  ---------------------------------------------------------------------------
  weekly_counts := array[]::int[];

  for x in 1..7 loop
    weekly_counts := array_append(
      weekly_counts,
      (
        select count(*)
        from bookings
        where booking_date = (current_date - ((7 - x))::int)
      )
    );
  end loop;

  ---------------------------------------------------------------------------
  -- TODAY WORKING HOURS
  ---------------------------------------------------------------------------
  select wh.morning_start, wh.morning_end,
         wh.evening_start, wh.evening_end
  into v_morning_start, v_morning_end,
       v_evening_start, v_evening_end
  from working_hours wh
  where wh.day_of_week = dow
  limit 1;

  ---------------------------------------------------------------------------
  -- CLINIC SETTINGS (morning + evening limits)
  ---------------------------------------------------------------------------
  select morning_limit, evening_limit
  into v_morning_limit, v_evening_limit
  from clinic_settings
  where id = 1
  limit 1;

  ---------------------------------------------------------------------------
  -- LOAD RATIO (Dynamic)
  ---------------------------------------------------------------------------
  if now()::time between v_morning_start and v_morning_end then
    v_limit := v_morning_limit;
  elsif now()::time between v_evening_start and v_evening_end then
    v_limit := v_evening_limit;
  else
    v_limit := v_morning_limit + v_evening_limit;
  end if;

  load_ratio := total_bookings_today::numeric / nullif(v_limit, 0);

  ---------------------------------------------------------------------------
  -- RETURN JSON
  ---------------------------------------------------------------------------
  return jsonb_build_object(
    'daily', jsonb_build_object(
      'total_bookings_today', total_bookings_today,
      'confirmed_today', confirmed_today,
      'cancelled_today', cancelled_today,
      'no_show_today', no_show_today,
      'new_patients_today', new_patients_today,
      'total_staff', total_staff,
      'active_announcements', active_announcements
    ),

    'weekly', jsonb_build_object(
      'counts', weekly_counts
    ),

    'today_summary', jsonb_build_object(
      'morning_start', v_morning_start,
      'morning_end', v_morning_end,
      'evening_start', v_evening_start,
      'evening_end', v_evening_end,
      'load_ratio', load_ratio
    )
  );
end;
$$;


ALTER FUNCTION "public"."get_dashboard_stats"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_full_clinic_config"() RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  settings jsonb;
  hours jsonb;
begin
  -- Get clinic settings
  select to_jsonb(cs.*)
  into settings
  from clinic_settings cs
  where cs.id = 1;

  -- Get working hours list
  select jsonb_agg(to_jsonb(wh.*) order by wh.day_of_week)
  into hours
  from working_hours wh;

  -- Merge them in one JSON
  return jsonb_build_object(
    'settings', settings,
    'working_hours', hours
  );
end;
$$;


ALTER FUNCTION "public"."get_full_clinic_config"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_next_booking"() RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'id', b.id,
    'ticket_code', b.ticket_code,
    'queue_number', b.queue_number,
    'booking_date', b.booking_date,
    'shift', b.shift,
    'booking_status', b.booking_status
  )
  INTO result
  FROM public.bookings b
  WHERE b.booking_status = 'confirmed'
    AND DATE(b.booking_date) = '2025-11-23'
  ORDER BY b.booking_date ASC, b.queue_number ASC
  LIMIT 1;

  -- إذا لا يوجد أي حجز
  IF result IS NULL THEN
    RETURN jsonb_build_object(
      'message', 'no_booking_found',
      'date', CURRENT_DATE
    );
  END IF;

  RETURN result;
END;
$$;


ALTER FUNCTION "public"."get_next_booking"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$begin
  insert into public.profiles (user_id, meta, role, status)
  values (
    new.id,
    jsonb_build_object(
      'raw_user_meta_data', coalesce(new.raw_user_meta_data, '{}'::jsonb),
      'provider', coalesce(new.raw_user_meta_data->>'provider', 'email'),
      'name', coalesce(new.raw_user_meta_data->>'name', new.email),
      'avatar', coalesce(new.raw_user_meta_data->>'avatar_url', '')
    ),
    'patient'::public.user_role,
    'active'::public.account_status
  );

  return new;
end;$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_admin_user"() RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'pg_temp'
    AS $$
DECLARE
  user_role public.user_role;
BEGIN
  SELECT role INTO user_role
  FROM public.profiles
  WHERE user_id = auth.uid();
  
  RETURN user_role IN ('admin');
EXCEPTION
  WHEN OTHERS THEN
    RETURN false;
END;
$$;


ALTER FUNCTION "public"."is_admin_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."on_staff_delete"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- عند حذف موظف → نوقف حسابه في profiles
  UPDATE public.profiles
  SET
    status = 'inactive',  -- يمكن تغييرها إلى suspended أو inactive حسب رغبتك
    updated_at = NOW()
  WHERE user_id = OLD.user_id;

  RETURN OLD;
END;
$$;


ALTER FUNCTION "public"."on_staff_delete"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."queue_next"("p_datetime" timestamp without time zone) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
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

  IF qs.is_paused THEN
    RETURN jsonb_build_object('success',false,'code','QUEUE_PAUSED');
  END IF;

  -- التصحيح: تجاهل booking_status تماماً - أخذ الحجز التالي بغض النظر عن حالته
  SELECT *
  INTO next_booking
  FROM bookings
  WHERE DATE(booking_date) = today_date
    AND shift = current_shift
    AND queue_number > qs.current_queue_number  -- فقط أكبر من الرقم الحالي
  ORDER BY queue_number ASC
  LIMIT 1;

  IF next_booking IS NULL THEN
    RETURN jsonb_build_object('success',false,'code','NO_MORE_BOOKINGS');
  END IF;

  -- تحديث queue_state إلى رقم الحجز التالي
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
$$;


ALTER FUNCTION "public"."queue_next"("p_datetime" timestamp without time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."queue_pause"("p_shift" "public"."booking_shift") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  UPDATE queue_state
  SET is_paused = TRUE, updated_at = NOW()
  WHERE shift = p_shift;

  RETURN jsonb_build_object('success', true, 'message', 'Queue paused');
END;
$$;


ALTER FUNCTION "public"."queue_pause"("p_shift" "public"."booking_shift") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."queue_restart"("p_shift" "public"."booking_shift") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- إعادة تعيين current_queue_number إلى 0
  UPDATE queue_state
  SET current_queue_number = 0,
      is_paused = false,
      updated_at = NOW()
  WHERE shift = p_shift;

  -- إذا لم يكن هناك سجل، قم بإنشائه
  IF NOT FOUND THEN
    INSERT INTO queue_state (shift, current_queue_number, is_paused)
    VALUES (p_shift, 0, false);
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Queue restarted successfully'
  );
END;
$$;


ALTER FUNCTION "public"."queue_restart"("p_shift" "public"."booking_shift") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."queue_resume"("p_shift" "public"."booking_shift") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  UPDATE queue_state
  SET is_paused = FALSE, updated_at = NOW()
  WHERE shift = p_shift;

  RETURN jsonb_build_object('success', true, 'message', 'Queue resumed');
END;
$$;


ALTER FUNCTION "public"."queue_resume"("p_shift" "public"."booking_shift") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."queue_status"("p_datetime" timestamp with time zone) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
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
$$;


ALTER FUNCTION "public"."queue_status"("p_datetime" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."save_clinic_config"("p_settings" "jsonb", "p_hours" "jsonb") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  -- Update settings
  perform update_clinic_settings(
    (p_settings->>'morning_count_limit')::int,
    (p_settings->>'evening_count_limit')::int,
    -- (p_settings->>'emergency_limit')::int,
    (p_settings->>'is_booking_enabled')::boolean,
    (p_settings->>'booking_morning_start_time')::time,
    -- (p_settings->>'booking_end_time')::time,
    (p_settings->>'allow_before_minutes')::int,
    (p_settings->>'auto_confirm')::boolean,
    (p_settings->>'stop_reason')::text
    -- (p_settings->>'allow_weekend')::boolean
  );

  -- Update working hours
  perform update_working_hours(p_hours);

end;
$$;


ALTER FUNCTION "public"."save_clinic_config"("p_settings" "jsonb", "p_hours" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_profile_to_staff"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- منع اللوب
  IF NEW.status = OLD.status THEN
    RETURN NEW;
  END IF;

  UPDATE public.staff
  SET
    status = NEW.status,
    updated_at = NOW()
  WHERE user_id = NEW.user_id;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."sync_profile_to_staff"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_staff_profile"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  update public.profiles
  set 
    meta = meta || jsonb_build_object(
      'full_name', new.full_name,
      'phone', new.phone,
      'email', new.email
    ),
    updated_at = now()
  where user_id = new.user_id;

  return new;
end;
$$;


ALTER FUNCTION "public"."sync_staff_profile"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_staff_to_profile"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- منع اللوب: لا تحدث profiles إذا لم تتغير الحالة
  IF NEW.status = OLD.status THEN
    RETURN NEW;
  END IF;

  UPDATE public.profiles
  SET
    status = NEW.status,
    updated_at = NOW()
  WHERE user_id = NEW.user_id;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."sync_staff_to_profile"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_announcement"("p_id" "uuid", "p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_updated_by_user_id" "uuid") RETURNS "public"."announcements"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  updated_row announcements;
BEGIN
  UPDATE announcements
  SET
    title = p_title,
    body = p_body,
    link_url = p_link_url,
    audience = p_audience,
    images = p_images,
    is_active = p_is_active,
    updated_at = NOW(),
    created_by_user_id = p_updated_by_user_id
  WHERE id = p_id
  RETURNING * INTO updated_row;

  RETURN updated_row;
END;
$$;


ALTER FUNCTION "public"."update_announcement"("p_id" "uuid", "p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_updated_by_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_announcement_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_announcement_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_booking"("p_id" "uuid", "p_booking_date" timestamp with time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp with time zone, "p_updated_at" timestamp with time zone, "p_cancelled_at" timestamp with time zone DEFAULT NULL::timestamp with time zone, "p_completed_at" timestamp with time zone DEFAULT NULL::timestamp with time zone, "p_cancelled_by" "uuid" DEFAULT NULL::"uuid", "p_cancel_reason" "text" DEFAULT NULL::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  check_result JSONB;
  old_booking bookings%ROWTYPE;
  updated_row bookings%ROWTYPE;
  new_queue_number INT;
  formatted_queue_number TEXT;
  result_data JSONB;
  
  booking_day DATE := DATE(p_booking_date);
  booking_timestamp TIMESTAMP;
BEGIN
  -- 1) التأكد أن الحجز موجود
  SELECT * INTO old_booking
  FROM bookings WHERE id = p_id;

  IF old_booking IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'reason', 'booking_not_found'
    );
  END IF;

  -- تحويل timestamptz إلى timestamp
  booking_timestamp := p_booking_date::timestamp;

  -- 2) التحقق من إمكانية التعديل
  IF DATE(old_booking.booking_date) != booking_day 
     OR old_booking.shift != p_shift 
     OR old_booking.patient_id != p_patient_id THEN
    
    check_result := can_book(
      booking_timestamp,
      p_shift,
      p_patient_type,
      p_patient_id
    );

    IF (check_result->>'can_book') = 'false' THEN
      RETURN jsonb_build_object(
        'success', false,
        'reason', check_result->>'reason'
      );
    END IF;
  END IF;

  -- 3) حساب queue_number الجديد إذا تغير التاريخ أو الشفت
  IF DATE(old_booking.booking_date) != booking_day OR old_booking.shift != p_shift THEN
    SELECT COALESCE(MAX(queue_number), 0) + 1
    INTO new_queue_number
    FROM bookings
    WHERE DATE(booking_date) = booking_day
      AND shift = p_shift
      AND booking_status IN ('pending','confirmed')
      AND id != p_id;
  ELSE
    new_queue_number := old_booking.queue_number;
  END IF;

  -- تنسيق queue_number
  formatted_queue_number := LPAD(new_queue_number::TEXT, 4, '0');

  -- 4) تنفيذ عملية التحديث
  UPDATE bookings
  SET
    booking_date = p_booking_date,
    patient_id = p_patient_id,
    patient_type = p_patient_type,
    guest_name = p_guest_name,
    guest_phone = p_guest_phone,
    guest_address = p_guest_address,
    shift = p_shift,
    booking_status = p_booking_status,
    booking_created_by = p_booking_created_by,
    queue_number = new_queue_number,
    -- ticket_code يبقى كما هو ولا يتغير
    created_at = p_created_at,
    updated_at = p_updated_at,
    cancelled_at = p_cancelled_at,
    completed_at = p_completed_at,
    cancelled_by = p_cancelled_by,
    cancel_reason = p_cancel_reason
  WHERE id = p_id
  RETURNING * INTO updated_row;

  -- 5) بناء data النهائية
  result_data := jsonb_build_object(
    'id', updated_row.id,
    'booking_date', updated_row.booking_date,
    'patient_id', updated_row.patient_id,
    'patient_type', updated_row.patient_type,
    'guest_name', updated_row.guest_name,
    'guest_phone', updated_row.guest_phone,
    'guest_address', updated_row.guest_address,
    'shift', updated_row.shift,
    'booking_status', updated_row.booking_status,
    'booking_created_by', updated_row.booking_created_by,
    'queue_number', formatted_queue_number,
    'ticket_code', updated_row.ticket_code,
    'created_at', updated_row.created_at,
    'updated_at', updated_row.updated_at,
    'cancelled_at', updated_row.cancelled_at,
    'completed_at', updated_row.completed_at,
    'cancelled_by', updated_row.cancelled_by,
    'cancel_reason', updated_row.cancel_reason
  );

  -- 6) الإرجاع النهائي
  RETURN jsonb_build_object(
    'success', true,
    'data', result_data
  );
END;
$$;


ALTER FUNCTION "public"."update_booking"("p_id" "uuid", "p_booking_date" timestamp with time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp with time zone, "p_updated_at" timestamp with time zone, "p_cancelled_at" timestamp with time zone, "p_completed_at" timestamp with time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_booking_queue"("p_id" "uuid", "p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  check_result JSONB;
  old_booking bookings%ROWTYPE;
  updated_row bookings%ROWTYPE;
  new_queue_number INT;
  formatted_queue_number TEXT;
  result_data JSONB;

  booking_day DATE := DATE(p_booking_date);
  booking_timestamp TIMESTAMP;
BEGIN
  -- 1) استرجاع الحجز القديم
  SELECT * INTO old_booking
  FROM bookings WHERE id = p_id;

  IF old_booking IS NULL THEN
    RETURN jsonb_build_object('success',false,'reason','booking_not_found');
  END IF;

  booking_timestamp := p_booking_date::timestamp;

  -- 2) التحقق من إمكانية الحجز إذا تغيّر اليوم/الشيفت/المريض
  IF DATE(old_booking.booking_date) != booking_day 
     OR old_booking.shift != p_shift 
     OR old_booking.patient_id != p_patient_id THEN

    check_result := can_book(
      booking_timestamp,
      p_shift,
      p_patient_type,
      p_patient_id
    );

    IF (check_result->>'can_book') = 'false' THEN
      RETURN jsonb_build_object(
        'success', false,
        'reason', check_result->>'reason'
      );
    END IF;
  END IF;

  -- 3) حساب رقم الطابور إذا تغيّر اليوم أو الشيفت
  IF DATE(old_booking.booking_date) != booking_day 
     OR old_booking.shift != p_shift THEN

    SELECT COALESCE(MAX(queue_number), 0) + 1
    INTO new_queue_number
    FROM bookings
    WHERE DATE(booking_date) = booking_day
      AND shift = p_shift
      AND booking_status IN ('pending','confirmed')
      AND id != p_id;
  ELSE
    new_queue_number := old_booking.queue_number;
  END IF;

  formatted_queue_number := LPAD(new_queue_number::TEXT, 4, '0');

  -- 4) تحديث الحجز فقط (بدون لمس queue_state)
  UPDATE bookings
  SET
    booking_date = p_booking_date,
    patient_id = p_patient_id,
    patient_type = p_patient_type,
    guest_name = p_guest_name,
    guest_phone = p_guest_phone,
    guest_address = p_guest_address,
    shift = p_shift,
    booking_status = p_booking_status,
    booking_created_by = p_booking_created_by,
    queue_number = new_queue_number,
    created_at = p_created_at,
    updated_at = p_updated_at,
    cancelled_at = p_cancelled_at,
    completed_at = p_completed_at,
    cancelled_by = p_cancelled_by,
    cancel_reason = p_cancel_reason
  WHERE id = p_id
  RETURNING * INTO updated_row;

  -- 5) بناء JSON للبيانات
  result_data := to_jsonb(updated_row) ||
    jsonb_build_object('queue_number', formatted_queue_number);

  RETURN jsonb_build_object('success', true, 'data', result_data);
END;
$$;


ALTER FUNCTION "public"."update_booking_queue"("p_id" "uuid", "p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_clinic_settings"("p_morning_count_limit" integer, "p_evening_count_limit" integer, "p_is_booking_enabled" boolean, "p_booking_morning_start_time" time without time zone, "p_allow_before_minutes" integer, "p_auto_confirm" boolean, "p_stop_reason" "text") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  update clinic_settings
  set 
    morning_count_limit = p_morning_count_limit,
    evening_count_limit = p_evening_count_limit,

    is_booking_enabled = p_is_booking_enabled,
    booking_morning_start_time = p_booking_morning_start_time,
    
    -- booking_end_time = p_booking_end_time,

    allow_before_minutes = p_allow_before_minutes,
    auto_confirm = p_auto_confirm,
    stop_reason = p_stop_reason,

    updated_at = now()
  where id = 1;
end;
$$;


ALTER FUNCTION "public"."update_clinic_settings"("p_morning_count_limit" integer, "p_evening_count_limit" integer, "p_is_booking_enabled" boolean, "p_booking_morning_start_time" time without time zone, "p_allow_before_minutes" integer, "p_auto_confirm" boolean, "p_stop_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_last_seen"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$begin
  update public.profiles
  set last_seen = now()
  where user_id = new.id;
  return new;
end;$$;


ALTER FUNCTION "public"."update_last_seen"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_patient"("p_user_id" "uuid", "p_meta" "jsonb", "p_role" "public"."user_role", "p_status" "public"."account_status") RETURNS TABLE("user_id" "uuid", "meta" "jsonb", "role" "public"."user_role", "status" "public"."account_status", "created_at" timestamp with time zone, "updated_at" timestamp with time zone, "last_seen" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  -- 🔐 لا نسمح إلا بتحديث المرضى فقط
  IF NOT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE profiles.user_id = p_user_id
      AND profiles.role = 'patient'
  ) THEN
    RAISE EXCEPTION 'Only patient profiles can be updated using update_patient()';
  END IF;

  -- ✔ تنفيذ عملية التحديث
  RETURN QUERY
  UPDATE public.profiles AS p
  SET
    meta       = COALESCE(p_meta, p.meta),
    role       = COALESCE(p_role, p.role),
    status     = COALESCE(p_status, p.status),
    updated_at = NOW()
  WHERE p.user_id = p_user_id
  RETURNING
    p.user_id,
    p.meta,
    p.role,
    p.status,
    p.created_at,
    p.updated_at,
    p.last_seen;
END;
$$;


ALTER FUNCTION "public"."update_patient"("p_user_id" "uuid", "p_meta" "jsonb", "p_role" "public"."user_role", "p_status" "public"."account_status") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_staff"("p_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") RETURNS TABLE("id" "uuid", "user_id" "uuid", "full_name" "text", "email" "text", "phone" "text", "position" "public"."staff_position", "shift_type" "public"."shift_type", "account_status" "public"."account_status", "created_at" timestamp with time zone, "updated_at" timestamp with time zone)
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  UPDATE public.staff s
  SET
    full_name = p_full_name,
    email = p_email,
    phone = p_phone,
    position = p_position,
    shift_type = p_shift,
    status = p_status,     -- ✔ تعديل هنا
    updated_at = NOW()
  WHERE s.id = p_id
  RETURNING
    s.id,
    s.user_id,
    s.full_name,
    s.email,
    s.phone,
    s.position,
    s.shift_type,
    s.status AS account_status,   -- ✔ alias
    s.created_at,
    s.updated_at;
END;
$$;


ALTER FUNCTION "public"."update_staff"("p_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_staff_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."update_staff_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_working_hours"("p_hours" "jsonb") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  item jsonb;
begin
  -- Loop through each working hour record
  for item in select * from jsonb_array_elements(p_hours)
  loop
    update working_hours
    set
      is_open = (item->>'is_open')::boolean,
      morning_start = (item->>'morning_start')::time,
      morning_end = (item->>'morning_end')::time,
      evening_start = (item->>'evening_start')::time,
      evening_end = (item->>'evening_end')::time,
      updated_at = now()
    where id = (item->>'id')::uuid;
  end loop;
end;
$$;


ALTER FUNCTION "public"."update_working_hours"("p_hours" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."user_can_access_booking"("booking_patient_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  r public.user_role;
BEGIN
  -- الحصول على دور المستخدم الحالي
  SELECT role INTO r
  FROM profiles
  WHERE user_id = auth.uid();

  -- admin أو staff
  IF r IN ('admin', 'staff') THEN
    RETURN true;
  END IF;

  -- المريض صاحب الحجز
  IF booking_patient_id = auth.uid() THEN
    RETURN true;
  END IF;

  -- غير مسموح
  RETURN false;
END;
$$;


ALTER FUNCTION "public"."user_can_access_booking"("booking_patient_id" "uuid") OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."bookings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "patient_type" "public"."patient_type" NOT NULL,
    "patient_id" "uuid",
    "guest_name" "text",
    "guest_phone" "text",
    "guest_address" "text",
    "booking_date" timestamp without time zone NOT NULL,
    "shift" "public"."booking_shift" NOT NULL,
    "booking_status" "public"."booking_status" DEFAULT 'pending'::"public"."booking_status" NOT NULL,
    "booking_created_by" "uuid" DEFAULT "auth"."uid"(),
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "cancelled_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "cancelled_by" "uuid",
    "cancel_reason" "text",
    "queue_number" integer,
    "ticket_code" character varying(12)
);


ALTER TABLE "public"."bookings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."clinic_settings" (
    "id" bigint DEFAULT 1 NOT NULL,
    "morning_count_limit" integer DEFAULT 10 NOT NULL,
    "evening_count_limit" integer DEFAULT 10 NOT NULL,
    "is_booking_enabled" boolean DEFAULT true NOT NULL,
    "booking_morning_start_time" time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    "allow_before_minutes" integer DEFAULT 60 NOT NULL,
    "auto_confirm" boolean DEFAULT false NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "stop_reason" "text"
);


ALTER TABLE "public"."clinic_settings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "user_id" "uuid" NOT NULL,
    "meta" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "role" "public"."user_role" DEFAULT 'patient'::"public"."user_role" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "last_seen" timestamp with time zone DEFAULT "now"() NOT NULL,
    "status" "public"."account_status" DEFAULT 'active'::"public"."account_status" NOT NULL
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."queue_state" (
    "shift" "public"."booking_shift" NOT NULL,
    "current_queue_number" integer DEFAULT 0,
    "is_paused" boolean DEFAULT false,
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."queue_state" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."staff" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "full_name" "text" NOT NULL,
    "email" "text" NOT NULL,
    "phone" "text",
    "position" "public"."staff_position" NOT NULL,
    "shift_type" "public"."shift_type" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "status" "public"."account_status" DEFAULT 'active'::"public"."account_status" NOT NULL
);


ALTER TABLE "public"."staff" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."working_hours" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "day_of_week" integer NOT NULL,
    "is_open" boolean DEFAULT true NOT NULL,
    "morning_start" time without time zone,
    "morning_end" time without time zone,
    "evening_start" time without time zone,
    "evening_end" time without time zone,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "updated_at" timestamp without time zone DEFAULT "now"(),
    CONSTRAINT "working_hours_day_of_week_check" CHECK ((("day_of_week" >= 1) AND ("day_of_week" <= 7)))
);


ALTER TABLE "public"."working_hours" OWNER TO "postgres";


ALTER TABLE ONLY "public"."announcements"
    ADD CONSTRAINT "announcements_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_ticket_code_key" UNIQUE ("ticket_code");



ALTER TABLE ONLY "public"."clinic_settings"
    ADD CONSTRAINT "clinic_settings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."queue_state"
    ADD CONSTRAINT "queue_state_pkey" PRIMARY KEY ("shift");



ALTER TABLE ONLY "public"."staff"
    ADD CONSTRAINT "staff_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."working_hours"
    ADD CONSTRAINT "working_hours_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_bookings_date_shift_status" ON "public"."bookings" USING "btree" ("booking_date", "shift", "booking_status");



CREATE INDEX "idx_profiles_role" ON "public"."profiles" USING "btree" ("role");



CREATE INDEX "idx_profiles_user_id" ON "public"."profiles" USING "btree" ("user_id");



CREATE INDEX "idx_working_hours_day" ON "public"."working_hours" USING "btree" ("day_of_week");



CREATE OR REPLACE TRIGGER "staff_set_updated_at" BEFORE UPDATE ON "public"."staff" FOR EACH ROW EXECUTE FUNCTION "public"."update_staff_updated_at"();



CREATE OR REPLACE TRIGGER "trg_announcements_updated_at" BEFORE UPDATE ON "public"."announcements" FOR EACH ROW EXECUTE FUNCTION "public"."update_announcement_updated_at"();



CREATE OR REPLACE TRIGGER "trg_on_staff_delete" AFTER DELETE ON "public"."staff" FOR EACH ROW EXECUTE FUNCTION "public"."on_staff_delete"();



CREATE OR REPLACE TRIGGER "trg_sync_profile_to_staff" AFTER UPDATE OF "status" ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."sync_profile_to_staff"();



CREATE OR REPLACE TRIGGER "trg_sync_staff_profile" AFTER UPDATE ON "public"."staff" FOR EACH ROW EXECUTE FUNCTION "public"."sync_staff_profile"();



CREATE OR REPLACE TRIGGER "trg_sync_staff_to_profile" AFTER UPDATE OF "status" ON "public"."staff" FOR EACH ROW EXECUTE FUNCTION "public"."sync_staff_to_profile"();



ALTER TABLE ONLY "public"."announcements"
    ADD CONSTRAINT "announcements_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "public"."profiles"("user_id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_booking_created_by_fkey" FOREIGN KEY ("booking_created_by") REFERENCES "public"."profiles"("user_id") ON UPDATE CASCADE;



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "bookings_cancelled_by_fkey" FOREIGN KEY ("cancelled_by") REFERENCES "public"."profiles"("user_id") ON UPDATE CASCADE;



ALTER TABLE ONLY "public"."bookings"
    ADD CONSTRAINT "fk_patient" FOREIGN KEY ("patient_id") REFERENCES "public"."profiles"("user_id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."staff"
    ADD CONSTRAINT "staff_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("user_id") ON UPDATE CASCADE ON DELETE CASCADE;



CREATE POLICY "Admin can read all profiles" ON "public"."profiles" FOR SELECT USING ("public"."is_admin_user"());



CREATE POLICY "Admin can update all profiles" ON "public"."profiles" FOR UPDATE USING ((("auth"."jwt"() ->> 'role'::"text") = 'admin'::"text")) WITH CHECK (true);



CREATE POLICY "Admin full access" ON "public"."announcements" USING (("public"."current_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Admins can manage staff" ON "public"."staff" USING ((("auth"."jwt"() ->> 'role'::"text") = 'admin'::"text")) WITH CHECK ((("auth"."jwt"() ->> 'role'::"text") = 'admin'::"text"));



CREATE POLICY "Clinic settings editable only by admin" ON "public"."clinic_settings" FOR UPDATE USING (("public"."current_user_role"() = 'admin'::"public"."user_role")) WITH CHECK (("public"."current_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Clinic settings readable only by admin" ON "public"."clinic_settings" FOR SELECT USING (("public"."current_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "No delete allowed" ON "public"."profiles" FOR DELETE USING (false);



CREATE POLICY "No insert allowed" ON "public"."profiles" FOR INSERT WITH CHECK (false);



CREATE POLICY "Prevent deleting clinic settings" ON "public"."clinic_settings" FOR DELETE USING (false);



CREATE POLICY "Prevent deleting working hours" ON "public"."working_hours" FOR DELETE USING (false);



CREATE POLICY "Prevent inserting new clinic settings rows" ON "public"."clinic_settings" FOR INSERT WITH CHECK (false);



CREATE POLICY "Prevent inserting new working hours rows" ON "public"."working_hours" FOR SELECT USING (false);



CREATE POLICY "Public read ALL" ON "public"."announcements" FOR SELECT USING (("audience" = 'all'::"public"."announcement_audience"));



CREATE POLICY "Staff read announcements" ON "public"."announcements" FOR SELECT USING ((("audience" = ANY (ARRAY['all'::"public"."announcement_audience", 'appOnly'::"public"."announcement_audience"])) AND ("public"."current_user_role"() = 'staff'::"public"."user_role")));



CREATE POLICY "Users can read own profile" ON "public"."profiles" FOR SELECT USING (("user_id" = "auth"."uid"()));



CREATE POLICY "Users can update own profile" ON "public"."profiles" FOR UPDATE USING (("user_id" = "auth"."uid"())) WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "Working hours editable only by admin" ON "public"."working_hours" FOR UPDATE USING (("public"."current_user_role"() = 'admin'::"public"."user_role")) WITH CHECK (("public"."current_user_role"() = 'admin'::"public"."user_role"));



CREATE POLICY "Working hours readable by admin or staff" ON "public"."working_hours" FOR SELECT USING (("public"."current_user_role"() = 'admin'::"public"."user_role"));



ALTER TABLE "public"."announcements" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."bookings" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "bookings_delete" ON "public"."bookings" FOR DELETE USING ("public"."user_can_access_booking"("patient_id"));



CREATE POLICY "bookings_insert" ON "public"."bookings" FOR INSERT WITH CHECK (((EXISTS ( SELECT 1
   FROM "public"."profiles"
  WHERE (("profiles"."user_id" = "auth"."uid"()) AND ("profiles"."role" = ANY (ARRAY['admin'::"public"."user_role", 'staff'::"public"."user_role"]))))) OR ("patient_id" = "auth"."uid"())));



CREATE POLICY "bookings_select" ON "public"."bookings" FOR SELECT USING ("public"."user_can_access_booking"("patient_id"));



CREATE POLICY "bookings_update" ON "public"."bookings" FOR UPDATE USING ("public"."user_can_access_booking"("patient_id")) WITH CHECK ("public"."user_can_access_booking"("patient_id"));



ALTER TABLE "public"."clinic_settings" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."staff" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."working_hours" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."bookings";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."profiles";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";


































































































































































GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "postgres";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "anon";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "authenticated";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "service_role";



GRANT ALL ON FUNCTION "public"."call_next_ticket"("p_shift" "public"."booking_shift") TO "anon";
GRANT ALL ON FUNCTION "public"."call_next_ticket"("p_shift" "public"."booking_shift") TO "authenticated";
GRANT ALL ON FUNCTION "public"."call_next_ticket"("p_shift" "public"."booking_shift") TO "service_role";



GRANT ALL ON FUNCTION "public"."can_book"("p_booking_datetime" timestamp without time zone, "p_shift" "public"."booking_shift", "p_patient_type" "public"."patient_type", "p_patient_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."can_book"("p_booking_datetime" timestamp without time zone, "p_shift" "public"."booking_shift", "p_patient_type" "public"."patient_type", "p_patient_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_book"("p_booking_datetime" timestamp without time zone, "p_shift" "public"."booking_shift", "p_patient_type" "public"."patient_type", "p_patient_id" "uuid") TO "service_role";



GRANT ALL ON TABLE "public"."announcements" TO "anon";
GRANT ALL ON TABLE "public"."announcements" TO "authenticated";
GRANT ALL ON TABLE "public"."announcements" TO "service_role";



GRANT ALL ON FUNCTION "public"."create_announcement"("p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_created_by_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."create_announcement"("p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_created_by_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_announcement"("p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_created_by_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_booking"("p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_booking"("p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_booking"("p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_staff"("p_user_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") TO "anon";
GRANT ALL ON FUNCTION "public"."create_staff"("p_user_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_staff"("p_user_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") TO "service_role";



GRANT ALL ON FUNCTION "public"."current_user_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."current_user_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."current_user_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_announcement"("p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_announcement"("p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_announcement"("p_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_booking"("p_booking_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_booking"("p_booking_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_booking"("p_booking_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."delete_staff"("p_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."delete_staff"("p_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."delete_staff"("p_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."generate_unique_ticket_code"() TO "anon";
GRANT ALL ON FUNCTION "public"."generate_unique_ticket_code"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_unique_ticket_code"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_all_announcements"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_all_announcements"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_all_announcements"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_all_bookings"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."get_all_bookings"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_all_bookings"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_all_bookings_with_filters"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date", "p_status" "public"."booking_status", "p_shift" "public"."booking_shift", "p_search_query" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_all_bookings_with_filters"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date", "p_status" "public"."booking_status", "p_shift" "public"."booking_shift", "p_search_query" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_all_bookings_with_filters"("p_start_date" "date", "p_end_date" "date", "p_specific_date" "date", "p_status" "public"."booking_status", "p_shift" "public"."booking_shift", "p_search_query" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_all_patients"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_all_patients"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_all_patients"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_all_profile"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_all_profile"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_all_profile"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_all_staff"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_all_staff"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_all_staff"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_current_shift"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_current_shift"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_current_shift"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_daily_bookings"("p_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."get_daily_bookings"("p_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_daily_bookings"("p_date" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_daily_bookings"("p_date" "date", "p_shift" "public"."booking_shift") TO "anon";
GRANT ALL ON FUNCTION "public"."get_daily_bookings"("p_date" "date", "p_shift" "public"."booking_shift") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_daily_bookings"("p_date" "date", "p_shift" "public"."booking_shift") TO "service_role";



GRANT ALL ON FUNCTION "public"."get_dashboard_full_stats"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_dashboard_full_stats"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_dashboard_full_stats"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_dashboard_stats"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_dashboard_stats"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_dashboard_stats"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_full_clinic_config"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_full_clinic_config"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_full_clinic_config"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_next_booking"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_next_booking"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_next_booking"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "postgres";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "anon";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "service_role";



GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "postgres";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "anon";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "service_role";



GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "postgres";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "anon";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "service_role";



GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."is_admin_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."on_staff_delete"() TO "anon";
GRANT ALL ON FUNCTION "public"."on_staff_delete"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."on_staff_delete"() TO "service_role";



GRANT ALL ON FUNCTION "public"."queue_next"("p_datetime" timestamp without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."queue_next"("p_datetime" timestamp without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."queue_next"("p_datetime" timestamp without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."queue_pause"("p_shift" "public"."booking_shift") TO "anon";
GRANT ALL ON FUNCTION "public"."queue_pause"("p_shift" "public"."booking_shift") TO "authenticated";
GRANT ALL ON FUNCTION "public"."queue_pause"("p_shift" "public"."booking_shift") TO "service_role";



GRANT ALL ON FUNCTION "public"."queue_restart"("p_shift" "public"."booking_shift") TO "anon";
GRANT ALL ON FUNCTION "public"."queue_restart"("p_shift" "public"."booking_shift") TO "authenticated";
GRANT ALL ON FUNCTION "public"."queue_restart"("p_shift" "public"."booking_shift") TO "service_role";



GRANT ALL ON FUNCTION "public"."queue_resume"("p_shift" "public"."booking_shift") TO "anon";
GRANT ALL ON FUNCTION "public"."queue_resume"("p_shift" "public"."booking_shift") TO "authenticated";
GRANT ALL ON FUNCTION "public"."queue_resume"("p_shift" "public"."booking_shift") TO "service_role";



GRANT ALL ON FUNCTION "public"."queue_status"("p_datetime" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."queue_status"("p_datetime" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."queue_status"("p_datetime" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."save_clinic_config"("p_settings" "jsonb", "p_hours" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."save_clinic_config"("p_settings" "jsonb", "p_hours" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."save_clinic_config"("p_settings" "jsonb", "p_hours" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_profile_to_staff"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_profile_to_staff"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_profile_to_staff"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_staff_profile"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_staff_profile"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_staff_profile"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_staff_to_profile"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_staff_to_profile"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_staff_to_profile"() TO "service_role";



GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_announcement"("p_id" "uuid", "p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_updated_by_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."update_announcement"("p_id" "uuid", "p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_updated_by_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_announcement"("p_id" "uuid", "p_title" "text", "p_body" "text", "p_link_url" "text", "p_audience" "public"."announcement_audience", "p_images" "jsonb", "p_is_active" boolean, "p_updated_by_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_announcement_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_announcement_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_announcement_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_booking"("p_id" "uuid", "p_booking_date" timestamp with time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp with time zone, "p_updated_at" timestamp with time zone, "p_cancelled_at" timestamp with time zone, "p_completed_at" timestamp with time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."update_booking"("p_id" "uuid", "p_booking_date" timestamp with time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp with time zone, "p_updated_at" timestamp with time zone, "p_cancelled_at" timestamp with time zone, "p_completed_at" timestamp with time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_booking"("p_id" "uuid", "p_booking_date" timestamp with time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp with time zone, "p_updated_at" timestamp with time zone, "p_cancelled_at" timestamp with time zone, "p_completed_at" timestamp with time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_booking_queue"("p_id" "uuid", "p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."update_booking_queue"("p_id" "uuid", "p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_booking_queue"("p_id" "uuid", "p_booking_date" timestamp without time zone, "p_patient_id" "uuid", "p_patient_type" "public"."patient_type", "p_guest_name" "text", "p_guest_phone" "text", "p_guest_address" "text", "p_shift" "public"."booking_shift", "p_booking_status" "public"."booking_status", "p_booking_created_by" "uuid", "p_created_at" timestamp without time zone, "p_updated_at" timestamp without time zone, "p_cancelled_at" timestamp without time zone, "p_completed_at" timestamp without time zone, "p_cancelled_by" "uuid", "p_cancel_reason" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_clinic_settings"("p_morning_count_limit" integer, "p_evening_count_limit" integer, "p_is_booking_enabled" boolean, "p_booking_morning_start_time" time without time zone, "p_allow_before_minutes" integer, "p_auto_confirm" boolean, "p_stop_reason" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."update_clinic_settings"("p_morning_count_limit" integer, "p_evening_count_limit" integer, "p_is_booking_enabled" boolean, "p_booking_morning_start_time" time without time zone, "p_allow_before_minutes" integer, "p_auto_confirm" boolean, "p_stop_reason" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_clinic_settings"("p_morning_count_limit" integer, "p_evening_count_limit" integer, "p_is_booking_enabled" boolean, "p_booking_morning_start_time" time without time zone, "p_allow_before_minutes" integer, "p_auto_confirm" boolean, "p_stop_reason" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_last_seen"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_last_seen"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_last_seen"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_patient"("p_user_id" "uuid", "p_meta" "jsonb", "p_role" "public"."user_role", "p_status" "public"."account_status") TO "anon";
GRANT ALL ON FUNCTION "public"."update_patient"("p_user_id" "uuid", "p_meta" "jsonb", "p_role" "public"."user_role", "p_status" "public"."account_status") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_patient"("p_user_id" "uuid", "p_meta" "jsonb", "p_role" "public"."user_role", "p_status" "public"."account_status") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_staff"("p_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") TO "anon";
GRANT ALL ON FUNCTION "public"."update_staff"("p_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_staff"("p_id" "uuid", "p_full_name" "text", "p_email" "text", "p_phone" "text", "p_position" "public"."staff_position", "p_shift" "public"."shift_type", "p_status" "public"."account_status") TO "service_role";



GRANT ALL ON FUNCTION "public"."update_staff_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_staff_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_staff_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_working_hours"("p_hours" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."update_working_hours"("p_hours" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_working_hours"("p_hours" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "service_role";



GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."user_can_access_booking"("booking_patient_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."user_can_access_booking"("booking_patient_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_can_access_booking"("booking_patient_id" "uuid") TO "service_role";



























GRANT ALL ON TABLE "public"."bookings" TO "anon";
GRANT ALL ON TABLE "public"."bookings" TO "authenticated";
GRANT ALL ON TABLE "public"."bookings" TO "service_role";



GRANT ALL ON TABLE "public"."clinic_settings" TO "anon";
GRANT ALL ON TABLE "public"."clinic_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."clinic_settings" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."queue_state" TO "anon";
GRANT ALL ON TABLE "public"."queue_state" TO "authenticated";
GRANT ALL ON TABLE "public"."queue_state" TO "service_role";



GRANT ALL ON TABLE "public"."staff" TO "anon";
GRANT ALL ON TABLE "public"."staff" TO "authenticated";
GRANT ALL ON TABLE "public"."staff" TO "service_role";



GRANT ALL ON TABLE "public"."working_hours" TO "anon";
GRANT ALL ON TABLE "public"."working_hours" TO "authenticated";
GRANT ALL ON TABLE "public"."working_hours" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































