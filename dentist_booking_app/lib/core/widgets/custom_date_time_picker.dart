import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../util/calendar_date.dart';

class CustomDateTimePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> onChanged;
  final String hint;

  const CustomDateTimePickerField({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    required this.selectedTime,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () async {
        CalendarDate.selectDate(
          context: context,
          selectStart: selectedDate,
          onChangedDateRange: (pickedDate) async {
            if (pickedDate == null) return;

            /*final pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (pickedTime == null) return;

            /// دمج التاريخ + الوقت النهائي
            final updatedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            */
            onChanged(pickedDate);
          },
        );
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.primary.withOpacity(.5)),
        ),
        child: Row(
          children: [
            Icon(
              size: 22,
              HugeIcons.strokeRoundedCalendar04,
              color: colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Text(
                    hint,
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    selectedDate == null ? hint : CalendarDate.getFormatSingleDate(selectedDate!),
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: selectedDate == null ? colorScheme.onSurface.withOpacity(.40) : colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(width: 20),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
