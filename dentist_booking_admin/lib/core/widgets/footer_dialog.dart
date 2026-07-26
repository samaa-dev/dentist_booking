import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

class FooterDialog extends StatelessWidget {
  const FooterDialog({
    super.key,
    required this.title,
    required this.onConfirm,
  });

  final String title;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 50),

              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => onConfirm(),
            child: Text(
              title,
              style: TextStyle().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(100, 50),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              LocaleKeys.cancel_button.trnsltd,
              style: TextStyle().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
