# 06 — Cross-Cutting Conventions & NFR

## الغرض والنطاق

اصطلاحات مشتركة لكل أسطح الـ API، مع تخصيصات حسب القناة عند الحاجة. لا يكرر قوائم endpoints (`04`).

## قرارات مفروضة

- Versioning بالمسار: `/v1/...`
- أخطاء بصيغة موحّدة
- Pagination تعتمد cursor للسرد الكبير
- Idempotency إلزامي لعمليات إنشاء حجز وبدء checkout
- كل استجابة خطأ/نجاح حساسة تحمل `request_id` للتتبع

## نموذج الخطأ الموحّد

```text
{
  "error": {
    "code": "morning_full",
    "message": "Human readable message",
    "details": [ { "field": "shift", "issue": "..." } ],
    "request_id": "..."
  }
}
```

| فئة HTTP مفاهيمية | أمثلة codes |
|-------------------|-------------|
| 400 | `validation_error`, `patient_name_required` |
| 401 | `unauthenticated`, `invalid_device_session` |
| 403 | `forbidden`, `subscription_blocks_new_bookings` |
| 404 | `clinic_not_found`, `booking_not_found` |
| 409 | `already_has_self_booking_today`, `idempotency_conflict` |
| 429 | `rate_limited` |
| 503 | `clinic_suspended_display` |

رموز المجال التفصيلية للحجز/الطابور تُعرَّف في `03` وتُستخدم كما هي في أجسام الخطأ.

## Pagination / Filtering / Sorting

- `cursor` + `limit` (حد أقصى موثّق لكل قناة)
- الفلاتر الشائعة للحجوزات: تاريخ من/إلى، وردية، حالة، نص بحث
- الترتيب الافتراضي: الأحدث أو رقم الطابور حسب المورد
- الاستجابة تشمل `next_cursor` إن وُجد

## Idempotency

| العملية | القناة | الرأس المفاهيمي |
|---------|--------|-----------------|
| إنشاء حجز | Clinic, Patient | `Idempotency-Key` |
| بدء checkout | Clinic, Platform | `Idempotency-Key` |
| queue/next | Clinic | موصى به لتقليل النقر المزدوج |

إعادة نفس المفتاح بنفس الجسم → نفس النتيجة؛ جسم مختلف → `idempotency_conflict`.

## Versioning

- البادئة `/v1` إلزامية
- التغييرات الكاسرة تتطلب `/v2` أو تفاوض نسخة موثّق
- الحقول الجديدة تُضاف بشكل متوافق للخلف داخل v1

## Rate limiting (مفاهيمي حسب القناة)

| القناة | تشديد | ملاحظات |
|--------|-------|---------|
| Platform | متوسط | حماية إدارة |
| Clinic | متوسط | مستخدمون موثوقون نسبياً |
| Patient | عالٍ على المسارات العامة (slug/availability/create) | مكافحة إساءة الحجز |
| Display | متوسط/عالٍ للقراءة | أجهزة كثيرة مسموحة ضمن الخطة |

عند الحد: `429` + `Retry-After` مفاهيمي.

## Request correlation

- العميل قد يرسل `X-Request-Id`؛ وإلا يولّد الخادم
- يُعاد في الاستجابة ويُسجَّل مع audit عند العمليات الحساسة

## Webhooks / Events catalog

أحداث تُصدَّر للمنصة أو لتكامل العيادة (إن فُعّل لاحقاً):

| Event | متى |
|-------|-----|
| `clinic.registered` | تسجيل عيادة |
| `subscription.activated` | تفعيل |
| `subscription.past_due` | تعثر |
| `subscription.suspended` | تعليق |
| `subscription.cancelled` | إلغاء |
| `invoice.paid` | دفع فاتورة |
| `invoice.payment_failed` | فشل دفع |
| `booking.created` | إنشاء حجز |
| `booking.cancelled` | إلغاء |
| `booking.status_changed` | تغير حالة |
| `queue.advanced` | تقدم الطابور |
| `queue.paused` | إيقاف |
| `staff.invite_accepted` | قبول دعوة |

تسليم webhook: توقيع، إعادة محاولة متدرجة، على الأقل-once مع idempotency عند المستلم.

## Realtime

| القناة | موارد موصى بها |
|--------|----------------|
| Clinic | bookings، queue_state |
| Display | queue_status، announcements TV |
| Patient | اختياري لتتبع التذكرة |
| Platform | غير مطلوب تشغيلياً |

## NFR (غير وظيفية)

| البند | هدف مفاهيمي |
|-------|-------------|
| عزل المستأجر | صفر تسرّب عبر `clinic_id` |
| اتساق الطابور | تقدم آمن تحت التزامن (موظفان لا يستهلكان نفس التذكرة) |
| توفر قراءة Display | تأخير منخفض مقبول لغرفة الانتظار |
| حجم الصفحة | حدود `limit` صارمة |
| PII | لا تُرجع قناة Display بيانات مرضى حساسة غير لازمة للعرض |
| التدقيق | عمليات التعليق/الحذف/الإعدادات الحرجة مُسجّلة |

## رؤوس شائعة

| Header | الاستخدام |
|--------|-----------|
| `Authorization` | جلسة القناة |
| `Idempotency-Key` | إنشاء حساس |
| `X-Request-Id` | تتبع |
| `Accept-Language` | رسائل اختيارية |

## ما لا يُفرض هنا

- اختيار بروتوكول Realtime بعينه
- اختيار بوابة API أو شبكة CDN
- تفاصيل تشفير التخزين

## حالة الملف

مرجع عرضي إلزامي قبل تنفيذ `04`.
