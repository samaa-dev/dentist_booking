import 'package:flutter/material.dart';

class SmallTimeButton extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const SmallTimeButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _formatTime(String input) {
    final parts = input.split(":");
    if (parts.length >= 2) {
      return "${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}";
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final displayValue = _formatTime(value);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(value.split(":")[0]),
            minute: int.parse(value.split(":")[1]),
          ),
        );

        if (time != null) {
          onChanged(
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
          );
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.outline.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 20,
              color: colors.primary,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                displayValue,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ),

            const SizedBox(width: 10),

            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22,
              color: colors.onSurface.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
