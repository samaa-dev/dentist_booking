# كيفية إخراج نسخة EXE (مثبّت Windows)

هذا الدليل يشرح **ماذا تفعل بالضبط** لإخراج ملف تثبيت واحد
`Dashboard-Clinic-El-Wafa-Setup-x.y.z.exe` يمكن تشغيله على أي جهاز Windows.

---

## الفكرة باختصار

| الخطوة | ماذا يحدث |
|--------|-----------|
| 1 | تبني التطبيق بـ Flutter على جهاز **Windows** |
| 2 | سكربت PowerShell يغلّف الملفات داخل مثبّت **Inno Setup** |
| 3 | النتيجة تظهر في مجلد `output/windows/` |

> **مهم:** هذا لا يعمل من macOS أو Linux. يجب استخدام جهاز/VM بنظام **Windows**.

---

## ما تحتاجه قبل البدء

ثبّت على جهاز Windows:

1. **Flutter SDK**  
   وتأكد أن منصة Windows مفعّلة:
   ```powershell
   flutter doctor
   flutter config --enable-windows-desktop
   ```

2. **Visual Studio 2022** مع workload:
   - **Desktop development with C++**

3. **Inno Setup 6**  
   تحميل: https://jrsoftware.org/isinfo.php  
   أثناء التثبيت اترك الخيار الافتراضي (يضيف `ISCC.exe`).

4. انسخ مشروعك إلى جهاز Windows (أو اسحبه عبر Git).

5. تأكد من وجود ملف `.env` في **جذر المشروع** بالمفتاحين:
   - `URL_SUPABASE`
   - `SUPABASE_KEY`

   السكربت يقرأهما تلقائياً ويمرّرهما عبر `--dart-define` أثناء بناء Release (بدونها التطبيق المُثبَّت لن يعمل).

---

## الطريقة الأسهل (ملف واحد)

افتح **PowerShell** داخل مجلد المشروع، ثم نفّذ:

```powershell
powershell -ExecutionPolicy Bypass -File installer\windows\build_release.ps1
```

السكربت يقوم تلقائياً بـ:

1. قراءة رقم الإصدار من `pubspec.yaml`
2. `flutter pub get`
3. قراءة `URL_SUPABASE` و `SUPABASE_KEY` من `.env` وتمريرهما عبر `--dart-define`
4. `flutter build windows --release`
5. تحميل **Visual C++ Redistributable** إن لم يكن موجوداً (متطلب تشغيل للتطبيق)
6. بناء المثبّت عبر Inno Setup
7. حفظ الملف النهائي في:

```text
output\windows\Dashboard-Clinic-El-Wafa-Setup-1.0.1.exe
```

(الرقم يتغير حسب `version` في `pubspec.yaml`)

وزّع **هذا الملف فقط** للعميل/الجهاز النهائي.

---

## خيارات إضافية للسكربت

```powershell
# بناء نظيف من الصفر
.\installer\windows\build_release.ps1 -Clean

# إعادة إنشاء المثبّت فقط (بدون إعادة بناء Flutter)
.\installer\windows\build_release.ps1 -SkipBuild

# حفظ المخرجات في مجلد آخر
.\installer\windows\build_release.ps1 -OutputDir D:\releases
```

---

## تغيير اسم التطبيق / الناشر / الإصدار

| ماذا تريد تغييره | أين |
|------------------|-----|
| الإصدار (مثل 1.0.1) | `pubspec.yaml` → السطر `version: 1.0.1+2` |
| اسم التطبيق / الناشر / GUID | `installer/windows/config.ps1` |

بعد تعديل الإصدار في `pubspec.yaml`، شغّل السكربت من جديد؛ لا حاجة لتعديل ملف `.iss` يدوياً.

---

## ماذا لو ظهر خطأ؟

| الرسالة | الحل |
|---------|------|
| `flutter not found` | أضف Flutter إلى PATH ثم افتح PowerShell جديد |
| `ISCC.exe not found` | ثبّت Inno Setup 6، أو عيّن المتغير `INNO_SETUP_PATH` لمجلد التثبيت |
| `Missing .env` / `Missing URL_SUPABASE or SUPABASE_KEY` | أنشئ `.env` في جذر المشروع بالمفتاحين المطلوبين |
| `Release executable not found` | تأكد أن `flutter build windows` نجح بدون أخطاء |
| فشل تحميل VC++ redist | حمّل يدوياً من https://aka.ms/vs/17/release/vc_redist.x64.exe وضعه في `installer\windows\redist\VC_redist.x64.exe` |

---

## البناء عبر GitHub Actions (CI)

الـ workflow في جذر المستودع (monorepo):

`.github/workflows/admin-windows-release.yml`

يشغّل نفس السكربت المحلي `installer\windows\build_release.ps1` على `windows-latest`، وينتج **ملف Setup واحد** (ليس مجلد `Release`).

### الأسرار المطلوبة (مرة واحدة)

في GitHub → **Settings** → **Secrets and variables** → **Actions**، أضف:

| Secret | القيمة |
|--------|--------|
| `URL_SUPABASE` | رابط مشروع Supabase |
| `SUPABASE_KEY` | مفتاح anon / public |

### التشغيل

1. افتح تبويب **Actions**
2. اختر **Build Admin Windows Release**
3. **Run workflow**
4. بعد النجاح، حمّل الـ artifact باسم `Dashboard-Clinic-El-Wafa-Setup` (ملف `.exe` داخل `output\windows\`)

---

## ملاحظات مهمة

- الملف الذي تعطيه للناس هو **مثبّت Setup** وليس مجلد `Release` كاملاً.
- المثبّت يثبّت التطبيق تحت Program Files ويضع اختصاراً، ويثبّت VC++ تلقائياً إن لزم.
- لا تحتاج لرفع `VC_redist.x64.exe` إلى Git؛ السكربت يحمّله عند الحاجة.
- اسم الملف التنفيذي داخل المثبّت هو `dentist_booking_admin.exe` (مطابق لـ `BINARY_NAME` في CMake).
- وضع Release لا يقرأ `.env` وقت التشغيل؛ القيم تُحقَن وقت البناء عبر `--dart-define` من السكربت.

---

## ملخص سريع

1. افتح المشروع على **Windows**
2. ثبّت Flutter + Visual Studio (C++) + Inno Setup 6
3. شغّل:
   ```powershell
   powershell -ExecutionPolicy Bypass -File installer\windows\build_release.ps1
   ```
4. خذ الملف من `output\windows\`
