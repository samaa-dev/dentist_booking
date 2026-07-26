# Realtime: الاستماع لتغيّرات الحجوزات وتحديث الواجهة

> **الجمهور:** فريق تطبيق المرضى (`dentist_booking_app`) — لتطبيق نفس النمط عند عرض حالة/معلومات حجز الزبون.  
> **المرجع في الأدمن:** `dentist_booking_admin` — قائمة الحجوزات + بطاقة الطابور.

---

## الفكرة باختصار

لا نعتمد على polling يدوي. نفتح **اشتراك Realtime** على جداول Supabase. عند أي `INSERT` / `UPDATE` / `DELETE` على صف يراه المستخدم (حسب RLS)، يصل حدث عبر WebSocket → نستدعي **refresh** (إعادة جلب البيانات من RPC أو query) ونحدّث الـ UI.

**تطبيق المرضى (الرئيسية / الحجز الفعال):** اشتراكان — `bookings` **و** `queue_state` (لأن «التالي» من الأدمن يحدّث `queue_state` فقط).

```
تغيير في DB (أدمن، تطبيق مريض، TV…)
        ↓
Postgres → supabase_realtime (publication)
        ↓
Supabase Realtime (WebSocket)
        ↓
Flutter: stream على bookings و/أو queue_state
        ↓
listen → debounce → refresh (RPC / query) → emit state جديد
```

---

## متطلبات Supabase (مرة واحدة)

1. **تفعيل Realtime على الجداول**  
   في المشروع:

   ```sql
   ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.bookings;
   ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.queue_state;
   ```

   (انظر migration `20250525000001_add_queue_state_realtime.sql`.)

   تحقق من Dashboard: **Database → Replication** — `bookings` و `queue_state` مفعّلان.

2. **RLS**  
   المريض يرى فقط صفوفه (حسب سياساتكم). Realtime يحترم RLS: يصل للعميل فقط التغييرات على الصفوف المسموح بقراءتها.

3. **حزمة Flutter**  
   `supabase_flutter` (موجودة في الأدمن والتطبيق).

---

## الـ API الأساسي في Flutter

مصدر واحد في الريبو:

```dart
Stream<List<Map<String, dynamic>>> watchBookings() {
  return _client.from('bookings').stream(primaryKey: ['id']);
}
```

| الخيار | المعنى |
|--------|--------|
| `from('bookings')` | الجدول |
| `.stream(primaryKey: ['id'])` | اشتراك Postgres Changes على المفتاح الأساسي |
| القيمة المرجعة | `Stream` — كل حدث يعيد **قائمة** (أو تحديث جزئي حسب إصدار SDK) |

**ملاحظة:** الـ stream يخبرك أن «شيء تغيّر»؛ البيانات الكاملة للعرض (فلاتر، joins، queue) تُجلب عبر **نفس RPC** الذي تستخدمه اليوم بعد التغيير.

### تصفية على المريض (موصى به لتطبيق المرضى)

لتقليل الضوضاء عند تغيّر حجوزات آخرين (إن سمح RLS بذلك):

```dart
Stream<List<Map<String, dynamic>>> watchMyBookings(String userId) {
  return _client
      .from('bookings')
      .stream(primaryKey: ['id'])
      .eq('patient_id', userId);
}
```

أو `.eq('booking_created_by', userId)` حسب منطق الحجز عندكم. اختبر مع سياسات RLS الفعلية.

---

## النمط 1 — قائمة الحجوزات (الأدمن)

**الملفات:**

| طبقة | مسار |
|------|------|
| Repo | `lib/features/booking/repo/booking_repo.dart` → `getBookingsStream()` |
| Cubit | `lib/features/booking/blocs/booking/booking_cubit.dart` |

**التدفق:**

1. في `BookingCubit` constructor: `listenbookings()`.
2. الاشتراك:

```dart
_bookingsSub = _bookingRepo.getBookingsStream().listen((_) async {
  emit(const BookingState.loading());
  final bookingList = await _bookingRepo.getBookingsWithFilters(
    endDate: DateTime.now(),
    startDate: DateTime.now(),
    searchQuery: "",
    shift: null,
    status: null,
  );
  emit(BookingState.loaded(bookingList));
});
```

3. في `close()`: `_bookingsSub?.cancel()`.

**الدرس:** أي تعديل على `bookings` (تأكيد، إلغاء، رقم طابور…) يعيد تحميل القائمة تلقائياً.

---

## النمط 2 — بطاقة الطابور (الأدمن)

**الملفات:**

| طبقة | مسار |
|------|------|
| Repo | `lib/features/queue/repo/queue_repo.dart` → `watchBookings()` |
| Cubit | `lib/features/queue/blocs/queue/queue_cubit.dart` |

الطابور لا يُعرض مباشرة من صف `bookings` بل من RPC `queue_status`. لذلك:

1. نفس `watchBookings()` على الجدول.
2. عند الحدث → **debounce 400ms** → `loadStatus()` → `queue_status`.

```dart
void listenBookings() {
  _bookingsSub = _queueRepo.watchBookings().listen(
    (_) => _scheduleStatusRefresh(),
    onError: (e) => debugPrint('Queue bookings stream error: $e'),
  );
}

void _scheduleStatusRefresh() {
  _statusRefreshDebounceTimer?.cancel();
  _statusRefreshDebounceTimer = Timer(const Duration(milliseconds: 400), () {
    if (isClosed) return;
    if (state.maybeWhen(processing: () => true, orElse: () => false)) return;
    loadStatus();
  });
}
```

**الدرس:** Realtime = **محفّز**؛ المصدر الحقيقي للشاشة يبقى RPC (`queue_status` في الأدمن).

---

## تطبيق على تطبيق المرضى (`dentist_booking_app`)

### ماذا تريد أن يتحدّث تلقائياً؟

| شاشة / حالة | مصدر البيانات الحالي | عند التغيير استدعِ |
|-------------|----------------------|-------------------|
| قائمة حجوزاتي | `BookingRepo.getBookings` → RPC `get_all_bookings_with_filters_app` | نفس `getBookings` بنفس التواريخ |
| تتبع الطابور | `QueueRepo.getBookingQueue` → RPC `get_booking_tracking` | `getBookingQueue(ticketCode: …)` |
| حجز اليوم النشط | `getActiveBookingQueue` (يجمع الحجز + tracking) | إعادة نفس الدالة |
| حالة الحجز العامة (إن وُجدت) | `BookingStatusRepo.getBookingStatus` → `get_booking_status` | `getBookingStatus()` |

### هيكل مقترح (مطابق للأدمن)

**1) Repo — إضافة stream**

```dart
// lib/features/booking/repo/booking_repo.dart
Stream<List<Map<String, dynamic>>> watchBookings() {
  return _client.from('bookings').stream(primaryKey: ['id']);
}
```

**2) Cubit / Controller للشاشة الرئيسية أو تتبع الطابور**

```dart
class MyBookingCubit extends Cubit<MyBookingState> {
  final BookingRepo _bookingRepo;
  final QueueRepo _queueRepo;
  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSub;
  Timer? _refreshDebounce;

  MyBookingCubit({required BookingRepo bookingRepo, required QueueRepo queueRepo})
      : _bookingRepo = bookingRepo,
        _queueRepo = queueRepo,
        super(MyBookingState.initial()) {
    _listenBookings();
  }

  void _listenBookings() {
    _bookingsSub?.cancel();
    _bookingsSub = _bookingRepo.watchBookings().listen(
      (_) => _scheduleRefresh(),
      onError: (e) => debugPrint('Patient bookings stream error: $e'),
    );
  }

  void _scheduleRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 400), () {
      if (isClosed) return;
      refreshActiveBooking(); // الدالة التي تجلب RPCs وتحدّث emit
    });
  }

  Future<void> refreshActiveBooking() async {
    // مثال: إعادة جلب tracking للحجز النشط
    final tracking = await _queueRepo.getActiveBookingQueue();
    emit(MyBookingState.loaded(tracking));
  }

  @override
  Future<void> close() {
    _bookingsSub?.cancel();
    _refreshDebounce?.cancel();
    return super.close();
  }
}
```

**3) تهيئة الاشتراك**

- أنشئ الـ Cubit مرة واحدة (مثل `BlocProvider` في `main` أو شاشة التتبع).
- لا تفتح اشتراكاً جديداً في كل `build` — فقط في constructor الـ Cubit.

**4) أثناء عمليات المستخدم (إلغاء، إنشاء حجز)**

- يمكن الإبقاء على `await` ثم `refresh` يدوياً كما اليوم.
- Realtime يغطي التغييرات **من الأدمن أو جهاز آخر** بدون pull-to-refresh.

### متى لا تعيد التحميل؟

كما في `QueueCubit` للأدمن: أثناء `processing` (زر «التالي» / «بدء» قيد التنفيذ) يُؤجَّل refresh لتجنب سباق مع استجابة RPC. في تطبيق المريض: أثناء `cancelBooking` أو إنشاء حجز يمكن تخطي refresh من الـ stream إذا الحالة `loading` من نفس العملية.

---

## Debounce (موصى به)

| بدون debounce | مع debounce ~400ms |
|---------------|-------------------|
| عدة أحداث متتالية → عدة RPC | دفعة واحدة من التحديث |
| ضغط على الشبكة والـ UI | أخف وأكثر استقراراً |

استخدم `Timer` + `cancel` على المؤقت السابق (نفس `QueueCubit`).

---

## دورة الحياة (إلزامي)

```dart
@override
Future<void> close() {
  _bookingsSub?.cancel();
  _refreshDebounce?.cancel();
  return super.close();
}
```

بدون `cancel` → تسريب اشتراك وتحديثات على widget مُدمَّر.

---

## ماذا يحدث عند تغيير الأدمن؟

مثال: موظف يؤكّد الحجز (`booking_status` → `confirmed`) أو يحدّث `queue_number`:

1. `UPDATE` على `bookings`.
2. Realtime يصل لتطبيق المريض (إن RLS يسمح بقراءة ذلك الصف).
3. `listen` يشغّل `_scheduleRefresh`.
4. `get_all_bookings_with_filters_app` / `get_booking_tracking` يعيدان بيانات محدّثة.
5. الشاشة تعرض الحالة الجديدة (مؤكد، رقم الطابور، عدد المتبقيين…).

---

## استكشاف الأخطاء

| المشكلة | تحقق |
|---------|------|
| لا يصل أي حدث | Replication على `bookings`؛ اتصال شبكة؛ المستخدم مسجّل دخول |
| يصل في الأدمن ولا في تطبيق المريض | RLS: هل سياسة `SELECT` تسمح للمريض بقراءة صفه؟ |
| تحديثات كثيرة جداً | زِد debounce؛ أو `.eq` على `patient_id` |
| UI يومض loading | لا تعرض loading كامل عند refresh من realtime — حدّث البيانات بصمت أو `refreshing` خفيف |
| خطأ في الـ stream | `onError` في `listen` + `debugPrint` |

---

## ملخص للـ Agent (تطبيق المرضى)

1. أضف `watchBookings()` في `BookingRepo` (سطر واحد — نفس الأدمن).
2. في Cubit شاشة «حجزي / تتبع الطابور»: اشترك في constructor، debounce، ثم أعد استدعاء RPCs الموجودة (`getBookings`, `getBookingQueue`, `getActiveBookingQueue`, …).
3. ألغِ الاشتراك في `close()`.
4. لا تستبدل RPCs بقراءة مباشرة من الـ stream إلا إذا أردتم تبسيط النموذج لاحقاً — النمط المعتمد: **stream = trigger، RPC = source of truth للعرض**.

---

## مراجع الكود في الأدمن

```dart
// booking_repo.dart
Stream<List<Map<String, dynamic>>> getBookingsStream() {
  return _client.from('bookings').stream(primaryKey: ['id']);
}

// queue_repo.dart
Stream<List<Map<String, dynamic>>> watchBookings() {
  return _client.from('bookings').stream(primaryKey: ['id']);
}
```

- `BookingCubit.listenbookings()` — refresh قائمة كاملة.
- `QueueCubit.listenBookings()` — debounce + `loadStatus()` / `queue_status`.

---

## تطبيق TV (`dentist_booking_tv`)

| طبقة | مسار |
|------|------|
| Repo | `lib/features/display/repo/queue_repo.dart` → `watchBookings()`, `watchQueueState()` |
| Cubit | `lib/features/display/blocs/tv_display_cubit.dart` |

- **Realtime:** اشتراك على `bookings` و `queue_state` → debounce 400ms → `_refreshQueue()` → RPC `queue_status` فقط (الإعلانات تُحدَّث عند التحميل الأول + poll كل 5 دقائق).
- **Fallback:** poll كل **60 ثانية** لتحديث الطابور عندما RLS يمنع `anon` من أحداث `bookings` (تأكيد/إلغاء حجز بدون تغيير `queue_state`).
- **Migration مطلوبة على Supabase:** `supabase/migrations/20250525000001_add_queue_state_realtime.sql` — تحقق من Replication لـ `queue_state` و `bookings`.

---

## اختبار قبول (تطبيق المريض)

1. افتح شاشة تتبع الحجز على جهاز المريض.
2. من الأدمن: أكّد الحجز أو غيّر الحالة / رقم الطابور.
3. خلال أقل من ثانية (مع debounce): تتحدّث الشاشة بدون سحب للتحديث.
4. أغلق الشاشة: لا استدعاءات RPC بعد الخروج (تحقق من logs).
5. إلغاء من تطبيق المريض: يعمل التحديث الفوري + لا تعارض مع refresh من stream.
