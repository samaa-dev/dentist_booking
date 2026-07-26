import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/l10n/latin_digits.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class CalendarDate {
  static Future<void> selectDateRange({
    required BuildContext context,
    required Function(DateTime? start, DateTime? end) onChangedDateRange,
    required DateTime? rangeStart,
    required DateTime? rangeEnd,
    VoidCallback? onReset,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final today = DateTime.now();

    /// القيم الأولية
    List<DateTime?> selectedDates = [
      rangeStart,
      rangeEnd,
    ];
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 480,
          height: 440,
          child: Column(
            children: [
              const SizedBox(height: 14),

              Text(
                LocaleKeys.calendar_select_range_title.trnsltd,
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withOpacity(0.3),
              ),

              const SizedBox(height: 4),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CalendarDatePicker2(
                    value: selectedDates,
                    onValueChanged: (values) => selectedDates = values,
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.range,
                      currentDate: today,
                      firstDate: DateTime(today.year - 1),
                      lastDate: DateTime(today.year + 1),
                      dayTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDayTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                      selectedRangeDayTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),

                      yearTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      disabledYearTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),

                      selectedYearTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                      selectedDayHighlightColor: colorScheme.primary,
                      controlsTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),

              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withOpacity(0.3),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    onReset == null
                        ? SizedBox.shrink()
                        : OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              onReset();
                            },
                            icon: const Icon(Icons.restore_outlined, size: 18),
                            label: Text(
                              LocaleKeys.reset_button_text.trnsltd,
                              style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.error,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(
                                color: colorScheme.error.withOpacity(0.5),
                              ),
                            ),
                          ),

                    const Spacer(),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        LocaleKeys.cancel_button_text.trnsltd,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);

                        if (selectedDates.length == 2) {
                          onChangedDateRange(
                            selectedDates[0],
                            selectedDates[1],
                          );
                        } else if (selectedDates.length == 1) {
                          onChangedDateRange(
                            selectedDates[0],
                            selectedDates[0],
                          );
                        } else {
                          onChangedDateRange(today, today);
                        }
                      },
                      child: Text(
                        LocaleKeys.confirm_button_text.trnsltd,
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> selectDate({
    required BuildContext context,
    required Function(DateTime? start) onChangedDateRange,
    required DateTime? selectStart,
    VoidCallback? onReset,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final today = DateTime.now();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 480,
          height: 440,
          child: Column(
            children: [
              const SizedBox(height: 14),

              Text(
                LocaleKeys.select_day.trnsltd,
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withOpacity(0.3),
              ),

              const SizedBox(height: 4),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CalendarDatePicker2(
                    value: [
                      selectStart,
                    ],
                    onValueChanged: (values) {
                      selectStart = values.first;
                    },
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      currentDate: today,
                      firstDate: DateTime(today.year - 1),
                      lastDate: DateTime(today.year + 1),
                      dayTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDayTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                      selectedRangeDayTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),

                      yearTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      disabledYearTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),

                      selectedYearTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                      selectedDayHighlightColor: colorScheme.primary,
                      controlsTextStyle: textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),

              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withOpacity(0.3),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    onReset == null
                        ? SizedBox.shrink()
                        : OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              onReset();
                            },
                            icon: const Icon(Icons.restore_outlined, size: 18),
                            label: Text(
                              LocaleKeys.reset_button_text.trnsltd,
                              style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.error,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(
                                color: colorScheme.error.withOpacity(0.5),
                              ),
                            ),
                          ),

                    const Spacer(),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        LocaleKeys.cancel_button_text.trnsltd,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onChangedDateRange(
                          selectStart,
                        );
                      },
                      child: Text(
                        LocaleKeys.confirm_button_text.trnsltd,
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static String getFormattedDateRange({
    required BuildContext context,
    required DateTime? rangeStart,
    required DateTime? rangeEnd,
  }) {
    final today = DateTime.now();

    if (rangeStart == null && rangeEnd == null) {
      return LocaleKeys.choose_date_range.trnsltd;
    }

    if (rangeStart != null && rangeEnd != null) {
      final isSingleDay =
          rangeStart.year == rangeEnd.year &&
          rangeStart.month == rangeEnd.month &&
          rangeStart.day == rangeEnd.day;

      if (isSingleDay) {
        final isToday =
            rangeStart.year == today.year &&
            rangeStart.month == today.month &&
            rangeStart.day == today.day;

        if (isToday) {
          return LocaleKeys.today.trnsltd;
        } else {
          return getFormatSingleDate(rangeStart);
        }
      } else {
        return _formatDateRange(rangeStart, rangeEnd);
      }
    }

    return LocaleKeys.choose_date_range.trnsltd;
  }

  static String getFormatSingleDate(DateTime date) {
    final today = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return LocaleKeys.today.trnsltd;
    }

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return LocaleKeys.yesterday.trnsltd;
    }

    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return LocaleKeys.tomorrow.trnsltd;
    }

    final now = DateTime.now();
    if (date.year == now.year) {
      return toLatinDigits(
        "${_getDayName(date.weekday)}، ${date.day} ${_getMonthName(date.month)}",
      );
    } else {
      return toLatinDigits(
        "${_getDayName(date.weekday)}، ${date.day} ${_getMonthName(date.month)} ${date.year}",
      );
    }
  }

  static String _formatDateRange(DateTime start, DateTime end) {
    final now = DateTime.now();

    if (start.year == end.year && start.month == end.month) {
      if (start.year == now.year) {
        return toLatinDigits(
          "${start.day} - ${end.day} ${_getMonthName(start.month)}",
        );
      } else {
        return toLatinDigits(
          "${start.day} - ${end.day} ${_getMonthName(start.month)} ${start.year}",
        );
      }
    } else if (start.year == end.year) {
      if (start.year == now.year) {
        return toLatinDigits(
          "${start.day} ${_getMonthName(start.month)} - ${end.day} ${_getMonthName(end.month)}",
        );
      } else {
        return toLatinDigits(
          "${start.day} ${_getMonthName(start.month)} - ${end.day} ${_getMonthName(end.month)} ${start.year}",
        );
      }
    } else {
      return toLatinDigits(
        "${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}",
      );
    }
  }

  static String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return LocaleKeys.monday.trnsltd;
      case 2:
        return LocaleKeys.tuesday.trnsltd;
      case 3:
        return LocaleKeys.wednesday.trnsltd;
      case 4:
        return LocaleKeys.thursday.trnsltd;
      case 5:
        return LocaleKeys.friday.trnsltd;
      case 6:
        return LocaleKeys.saturday.trnsltd;
      case 7:
        return LocaleKeys.sunday.trnsltd;
      default:
        return '';
    }
  }

  static String _getMonthName(int month) {
    switch (month) {
      case 1:
        return LocaleKeys.january.trnsltd;
      case 2:
        return LocaleKeys.february.trnsltd;
      case 3:
        return LocaleKeys.march.trnsltd;
      case 4:
        return LocaleKeys.april.trnsltd;
      case 5:
        return LocaleKeys.may.trnsltd;
      case 6:
        return LocaleKeys.june.trnsltd;
      case 7:
        return LocaleKeys.july.trnsltd;
      case 8:
        return LocaleKeys.august.trnsltd;
      case 9:
        return LocaleKeys.september.trnsltd;
      case 10:
        return LocaleKeys.october.trnsltd;
      case 11:
        return LocaleKeys.november.trnsltd;
      case 12:
        return LocaleKeys.december.trnsltd;
      default:
        return month.toString();
    }
  }

  static String formatWaitTime(int totalSeconds, BuildContext context) {
    final hours = totalSeconds ~/ 60;
    final minutes = totalSeconds % 60;

    final hoursText = hours > 0
        ? plural(
            'wait_time.hour',
            hours,
            namedArgs: {'count': hours.toString()},
          )
        : '';

    final minuteText = minutes > 0
        ? plural(
            'wait_time.minute',
            minutes,
            namedArgs: {
              'count': minutes.toString(),
            },
          )
        : '';

    // الجمع بين النصوص
    String timeText;
    if (hoursText.isNotEmpty && minuteText.isNotEmpty) {
      timeText = '$hoursText و $minuteText'; //inArabic
      if (context.locale.languageCode != 'ar') {
        timeText = '$hoursText and $minuteText'; //inEnglish
      }
    } else {
      timeText = hoursText.isNotEmpty ? hoursText : minuteText;
    }

    return '${tr('wait_time.remaining_time')} $timeText';
  }
}
