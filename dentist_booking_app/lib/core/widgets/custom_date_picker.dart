import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../util/calendar_date.dart';

class CustomDatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final String hint;
  final String? errorText;

  const CustomDatePickerField({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    required this.hint,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime(now.year - 18),
              firstDate: DateTime(1900),
              lastDate: DateTime(now.year + 5),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: errorText != null
                    ? colorScheme.error
                    : colorScheme.surface,
                width: 1.4,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedCalendar04,
                  size: 22,
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Row(
                    children: [
                      Text(
                        hint,
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onPrimaryContainer.withOpacity(
                            0.6,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      if (selectedDate != null)
                        Text(
                          CalendarDate.getFormatSingleDate(selectedDate!),
                          // "${selectedDate!.day.toString().padLeft(2, '0')}/"
                          // "${selectedDate!.month.toString().padLeft(2, '0')}/"
                          // "${selectedDate!.year}",
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),

                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              errorText!,
              style: textTheme.bodySmall!.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
