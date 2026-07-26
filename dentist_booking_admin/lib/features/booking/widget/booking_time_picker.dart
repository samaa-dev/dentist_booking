import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BookingTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  // final ValueChanged<TimeOfDay> onChanged;

  const BookingTimePicker({
    super.key,
    required this.selectedTime,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        // final picked = await showTimePicker(
        //   context: context,
        //   initialTime: selectedTime ?? TimeOfDay.now(),
        // );

        // if (picked != null) onChanged(picked);
      },
      child: Container(
        height: 48,
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
              Icons.access_time_filled,
              size: 18,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            const Spacer(),

            // النص الذي يعرض الوقت
            Text(
              selectedTime == null
                  ? "--:--"
                  : "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
              style: textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),
            Icon(
              HugeIcons.strokeRoundedArrowDown01,
              size: 18,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
