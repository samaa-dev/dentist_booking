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
    final parts = input.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displayValue = _formatTime(value);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final parts = value.split(':');
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 8,
            minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
          ),
        );

        if (time != null) {
          onChanged(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          );
        }
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.outline.withOpacity(0.35),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 18,
              color: colors.primary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                displayValue,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
