# إعداد إشعارات الدور (Android + FCM)

هذا الدليل يكمل الكود الموجود في المستودع. التكلفة ≈ **0$/شهر** لعيادة واحدة على Android.

## ما الذي أُنجز في الكود؟

| جزء | الموقع |
|-----|--------|
| جداول + enqueue + triggers | [`dentist_booking_admin/supabase/migrations/20260924000001_push_queue_notifications.sql`](../dentist_booking_admin/supabase/migrations/20260924000001_push_queue_notifications.sql) |
| نسخة للصق في SQL Editor | [`dentist_booking_app/sql/push_queue_notifications.sql`](sql/push_queue_notifications.sql) |
| Edge Function | [`dentist_booking_admin/supabase/functions/send-push/`](../dentist_booking_admin/supabase/functions/send-push/) |
| تطبيق المريض (FCM) | `firebase_messaging` + [`lib/core/services/push_notification_service.dart`](lib/core/services/push_notification_service.dart) |
| `google-services.json` | موجود مسبقاً في `android/app/` لحزمة `com.samaadev.drbellem` |

## 1) تطبيق SQL على Supabase

من Dashboard → SQL Editor، نفّذ ملف الهجرة كاملاً، أو عبر CLI:

```bash
cd dentist_booking_admin
supabase db push
# أو: supabase migration up
```

تحقق سريع:

```sql
select to_regclass('public.device_tokens');
select to_regclass('public.notification_jobs');
```

## 2) Firebase Service Account

1. افتح [Firebase Console](https://console.firebase.google.com/) → مشروع `dentist-booking-admin`
2. Project settings → **Service accounts** → Generate new private key
3. احفظ JSON محلياً (لا ترفعه إلى Git)

## 3) نشر Edge Function + الأسرار

```bash
cd dentist_booking_admin

# Service account كاملاً كسلسلة JSON واحدة
supabase secrets set FIREBASE_SERVICE_ACCOUNT="$(cat /path/to/service-account.json)"

# اختياري: سر إضافي لاستدعاء الدالة يدوياً
supabase secrets set PUSH_WEBHOOK_SECRET="choose-a-long-random-string"

supabase functions deploy send-push --no-verify-jwt
```

URL المتوقع:

`https://agyqdghxqylwinpcvvmn.supabase.co/functions/v1/send-push`

## 4) ربط الإرسال (اختر واحداً)

### أ) المُفضّل — Database Webhook

1. Supabase Dashboard → **Database** → **Webhooks**
2. Create a new hook:
   - Table: `notification_jobs`
   - Events: **Insert**
   - Type: Supabase Edge Function → `send-push`
   - أو HTTP → URL الدالة أعلاه
3. أضف Header إن فعّلت السر: `x-push-secret: <PUSH_WEBHOOK_SECRET>`
   أو استخدم Authorization بـ service role حسب إعداد الـ Webhook

### ب) بديل — pg_net من Postgres

بعد نشر الدالة:

```sql
update public.push_config
set
  enabled = true,
  edge_function_url = 'https://agyqdghxqylwinpcvvmn.supabase.co/functions/v1/send-push',
  updated_at = now()
where id = 1;
```

ملاحظة: تريغر `notification_jobs_dispatch` يحاول إرسال `Authorization: Bearer` من
`app.settings.service_role_key` إن وُجد. إن بقي فارغاً، عيّن `PUSH_WEBHOOK_SECRET`
واستدعِ الدالة بـ Webhook، أو عالج المهام يدوياً:

```bash
curl -X POST \
  'https://agyqdghxqylwinpcvvmn.supabase.co/functions/v1/send-push' \
  -H "Authorization: Bearer $SERVICE_ROLE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"process_pending": true}'
```

## 5) بناء تطبيق المريض

```bash
cd dentist_booking_app
flutter pub get
flutter run  # جهاز Android حقيقي مفضّل لاختبار FCM
```

عند تسجيل الدخول بـ Google يُطلب إذن الإشعارات ويُحفظ التوكن في `device_tokens`.

## 6) اختبار يدوي

1. سجّل دخول مريض على جهاز حقيقي ووافق على الإشعارات
2. تأكد من وجود صف في `device_tokens`
3. أنشئ حجزاً → يجب أن يصل إشعار «تم حجز موعدك — قبلك N»
4. من الأدمن نفّذ `queue_next` عدة مرات → يُستبدل نفس الإشعار (tag = booking_id) بـ «أصبح قبلك …» ثم «حان دورك»
5. تقدّم للدور التالي → لا مزيد من إشعارات للمريض السابق
6. اضغط الإشعار → يفتح تبويب تتبع الدور مع `ticket_code`

فحص المهام:

```sql
select id, kind, people_before, status, error_message, created_at
from notification_jobs
order by created_at desc
limit 20;
```

## سلوك المنتج

- **حجز:** `booking_confirmed`
- **كل تقدّم للدور:** `position_update` لكل من `queue_number > current`
- **دوره الآن:** `your_turn` عندما `queue_number = current`
- **بعد تجاوزه:** لا يُدرَج في الـ enqueue
- **استبدال الإشعار:** `collapse_key` / Android `tag` = `booking_id`

## iOS لاحقاً

يتطلب حساب Apple Developer (~99$/سنة)، مفتاح APNs في Firebase، و`GoogleService-Info.plist` + صلاحيات iOS في التطبيق.

## استكشاف أخطاء شائعة

| عرض | سبب محتمل |
|-----|-----------|
| لا توكن في `device_tokens` | رفض إذن الإشعارات / لم يُكمل Google login |
| jobs تبقى `pending` | Webhook غير مربوط أو الدالة غير منشورة |
| jobs = `failed` / `no_device_token` | المستخدم بلا توكن |
| `UNREGISTERED` | توكن قديم — يُحذف تلقائياً من `device_tokens` |
| لا إشعار في المحاكي | اختبر على جهاز حقيقي مع Google Play services |
