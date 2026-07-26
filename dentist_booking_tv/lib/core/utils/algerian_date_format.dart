import 'package:dentist_booking_tv/core/utils/latin_digits.dart';

/// Date/time formatting with Algerian Arabic month names (French-derived).
abstract final class AlgerianDateFormat {
  static const _weekdays = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  static const _months = [
    'جانفي',
    'فيفري',
    'مارس',
    'أفريل',
    'ماي',
    'جوان',
    'جويلية',
    'أوت',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  /// e.g. `الاثنين، 13 جويلية`
  static String formatDate(DateTime dateTime) {
    final wd = dateTime.weekday;
    final weekdayAr = wd >= 1 && wd <= 7 ? _weekdays[wd - 1] : '';
    final monthAr = dateTime.month >= 1 && dateTime.month <= 12
        ? _months[dateTime.month - 1]
        : '';
    return toLatinDigits('$weekdayAr، ${dateTime.day} $monthAr');
  }

  /// e.g. `09:30 AM`
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return toLatinDigits(
      '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm',
    );
  }
}
