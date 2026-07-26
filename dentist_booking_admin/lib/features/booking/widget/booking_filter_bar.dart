import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dentist_booking_admin/core/enum/enum.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/l10n/latin_digits.dart';
import 'package:dentist_booking_admin/core/widgets/custom_dropdown.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BookingFilterBar extends StatelessWidget {
  const BookingFilterBar({
    super.key,
    required this.onChangedShift,
    required this.onChangedStatus,
    required this.onChangedDateRange,
    required this.onReset,
    this.shift,
    this.status,
    this.rangeStart,
    this.rangeEnd,
  });

  final BookingShift? shift;
  final BookingStatus? status;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  final Function(BookingShift? shift) onChangedShift;
  final Function(BookingStatus? status) onChangedStatus;
  final Function(DateTime?, DateTime?) onChangedDateRange;

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 250,
              child: Material(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        width: 1,
                        color: colorScheme.onPrimaryContainer.withOpacity(
                          0.15,
                        ),
                      ),
                      //
                    ),
                    child: Row(
                      children: [
                        Icon(
                          size: 20,
                          HugeIcons.strokeRoundedCalendar04,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formattedDateRange(context),
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                        Icon(
                          HugeIcons.strokeRoundedArrowDown01,
                          color: colorScheme.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            SizedBox(
              width: 250,
              child: CustomDropdown<BookingStatus?>(
                enableSearch: false,
                fullColor: colorScheme.surface,
                hintText: LocaleKeys.status_all.trnsltd,
                value: status,
                items: _statusItems(),
                onChanged: (value) => onChangedStatus(value),
              ),
            ),

            const SizedBox(width: 8),

            SizedBox(
              width: 200,
              child: CustomDropdown<BookingShift?>(
                enableSearch: false,
                fullColor: colorScheme.surface,
                hintText: LocaleKeys.status_all.trnsltd,
                value: shift,
                items: _shiftItems(),
                onChanged: (value) => onChangedShift(value),
              ),
            ),

            const SizedBox(width: 12),
            Spacer(),

            const SizedBox(width: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(150, 40),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 30,
                ),
                side: BorderSide(
                  color: colorScheme.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              onPressed: onReset,
              icon: const Icon(
                HugeIcons.strokeRoundedCancelCircle,
                size: 18,
              ),
              label: Text(
                LocaleKeys.reset.trnsltd,
                style: TextStyle().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BookingShift?>> _shiftItems() {
    return [
      DropdownMenuItem(
        value: null,
        child: Text(
          LocaleKeys.status_all.trnsltd,
        ),
      ),
      ...BookingShift.values.map(
        (s) => DropdownMenuItem(
          value: s,
          child: Text(
            s.name,
          ),
        ),
      ),
    ];
  }

  List<DropdownMenuItem<BookingStatus?>> _statusItems() {
    return [
      DropdownMenuItem(
        value: null,
        child: Text(
          LocaleKeys.status_all.trnsltd,
        ),
      ),
      ...BookingStatus.values.map(
        (s) => DropdownMenuItem(
          value: s,
          child: Text(
            s.name,
          ),
        ),
      ),
    ];
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final today = DateTime.now();

    final initialDates = [
      if (rangeStart != null) rangeStart!,
      if (rangeEnd != null) rangeEnd!,
    ];

    final initialValue = initialDates;

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        currentDate: today,
        calendarType: CalendarDatePicker2Type.range,
        centerAlignModePicker: false,
        firstDate: DateTime(
          today.year - 1,
        ),
        lastDate: DateTime(
          today.year + 1,
        ),
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
        selectedDayHighlightColor: colorScheme.primary,
        controlsTextStyle: textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        cancelButtonTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        okButtonTextStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      dialogSize: const Size(500, 420),
      value: initialValue,
    );

    if (result != null) {
      if (result.length == 2) {
        onChangedDateRange(result[0], result[1]);
      } else if (result.length == 1) {
        final singleDate = result[0]!;
        onChangedDateRange(singleDate, singleDate);
      } else if (result.isEmpty) {
        onChangedDateRange(today, today);
      }
    }
  }

  String _formattedDateRange(BuildContext context) {
    final today = DateTime.now();

    if (rangeStart == null && rangeEnd == null) {
      return LocaleKeys.choose_date_range.trnsltd;
    }

    if (rangeStart != null && rangeEnd != null) {
      final isSingleDay =
          rangeStart!.year == rangeEnd!.year &&
          rangeStart!.month == rangeEnd!.month &&
          rangeStart!.day == rangeEnd!.day;

      if (isSingleDay) {
        final isToday =
            rangeStart!.year == today.year &&
            rangeStart!.month == today.month &&
            rangeStart!.day == today.day;

        if (isToday) {
          return LocaleKeys.today.trnsltd;
        } else {
          return _formatSingleDate(rangeStart!);
        }
      } else {
        return _formatDateRange(rangeStart!, rangeEnd!);
      }
    }

    return LocaleKeys.choose_date_range.trnsltd;
  }

  String _formatSingleDate(DateTime date) {
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

  String _formatDateRange(DateTime start, DateTime end) {
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

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return LocaleKeys.Monday.trnsltd;
      case 2:
        return LocaleKeys.Tuesday.trnsltd;
      case 3:
        return LocaleKeys.Wednesday.trnsltd;
      case 4:
        return LocaleKeys.Thursday.trnsltd;
      case 5:
        return LocaleKeys.Friday.trnsltd;
      case 6:
        return LocaleKeys.Saturday.trnsltd;
      case 7:
        return LocaleKeys.Sunday.trnsltd;
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
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
}
