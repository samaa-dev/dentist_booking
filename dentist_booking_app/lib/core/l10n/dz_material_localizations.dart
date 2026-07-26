import 'package:dentist_booking_app/core/l10n/algerian_months.dart';
import 'package:dentist_booking_app/core/l10n/latin_digits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

/// Arabic Material strings with Algerian month names and Latin digits.
class DzMaterialLocalizations extends MaterialLocalizationAr {
  const DzMaterialLocalizations({
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  }) : super(localeName: 'ar');

  static const _weekdays = <String>[
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  String _weekday(DateTime date) => _weekdays[date.weekday - 1];

  @override
  String formatDecimal(int number) => '$number';

  @override
  String formatYear(DateTime date) => '${date.year}';

  @override
  String formatMonthYear(DateTime date) {
    return toLatinDigits('${AlgerianMonths.nameOf(date.month)} ${date.year}');
  }

  @override
  String formatShortMonthDay(DateTime date) {
    return toLatinDigits('${date.day} ${AlgerianMonths.nameOf(date.month)}');
  }

  @override
  String formatFullDate(DateTime date) {
    return toLatinDigits(
      '${_weekday(date)}، ${date.day} ${AlgerianMonths.nameOf(date.month)} ${date.year}',
    );
  }

  @override
  String formatMediumDate(DateTime date) {
    return toLatinDigits(
      '${_weekday(date)}، ${date.day} ${AlgerianMonths.nameOf(date.month)}',
    );
  }

  @override
  String formatShortDate(DateTime date) {
    return toLatinDigits(
      '${date.day} ${AlgerianMonths.nameOf(date.month)} ${date.year}',
    );
  }

  @override
  String formatCompactDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}/$m/$d';
  }

  @override
  String formatMinute(TimeOfDay timeOfDay) {
    return timeOfDay.minute.toString().padLeft(2, '0');
  }

  @override
  String formatHour(TimeOfDay timeOfDay, {bool alwaysUse24HourFormat = false}) {
    switch (hourFormat(
      of: timeOfDayFormat(alwaysUse24HourFormat: alwaysUse24HourFormat),
    )) {
      case HourFormat.HH:
        return timeOfDay.hour.toString().padLeft(2, '0');
      case HourFormat.H:
        return '${timeOfDay.hour}';
      case HourFormat.h:
        final hour = timeOfDay.hourOfPeriod;
        return '${hour == 0 ? 12 : hour}';
    }
  }
}

class DzMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const DzMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    // Latin digits via English number patterns; Arabic long format for weekdays.
    final fullYearFormat = intl.DateFormat.y('en');
    final compactDateFormat = intl.DateFormat.yMd('en');
    final shortDateFormat = intl.DateFormat.yMMMd('en');
    final mediumDateFormat = intl.DateFormat.MMMEd('en');
    final longDateFormat = intl.DateFormat.yMMMMEEEEd('ar');
    final yearMonthFormat = intl.DateFormat.yMMMM('en');
    final shortMonthDayFormat = intl.DateFormat.MMMd('en');
    final decimalFormat = intl.NumberFormat.decimalPattern('en');
    final twoDigitZeroPaddedFormat = intl.NumberFormat('00', 'en');

    return SynchronousFuture<MaterialLocalizations>(
      DzMaterialLocalizations(
        fullYearFormat: fullYearFormat,
        compactDateFormat: compactDateFormat,
        shortDateFormat: shortDateFormat,
        mediumDateFormat: mediumDateFormat,
        longDateFormat: longDateFormat,
        yearMonthFormat: yearMonthFormat,
        shortMonthDayFormat: shortMonthDayFormat,
        decimalFormat: decimalFormat,
        twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
      ),
    );
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<MaterialLocalizations> old) =>
      false;
}
