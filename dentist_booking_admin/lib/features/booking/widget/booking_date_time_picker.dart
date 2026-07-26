import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BookingDateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;

  const BookingDateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final now = DateTime.now();

        // ⏳ 1) اختيار التاريخ
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDateTime ?? now,
          firstDate: now.subtract(const Duration(days: 1)),
          lastDate: now.add(const Duration(days: 365)),
        );

        if (pickedDate == null) return;

        // ⏰ 2) اختيار الوقت
        final pickedTime = await showTimePicker(
          // ignore: use_build_context_synchronously
          context: context,
          initialTime: selectedDateTime != null
              ? TimeOfDay.fromDateTime(selectedDateTime!)
              : TimeOfDay.now(),
        );

        if (pickedTime == null) return;

        // 🧩 3) دمج التاريخ + الوقت في DateTime
        final fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        onDateTimeChanged(fullDateTime);
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              HugeIcons.strokeRoundedCalendar04,
              size: 18,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            const Spacer(),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4),
                Text(
                  "${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${selectedDateTime!.year}-${selectedDateTime!.month.toString().padLeft(2, '0')}-${selectedDateTime!.day.toString().padLeft(2, '0')}",

                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),

            const Spacer(),
            Icon(
              HugeIcons.strokeRoundedArrowDown01,
              size: 18,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
