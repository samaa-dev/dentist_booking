import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EmptyAnnouncemen extends StatelessWidget {
  const EmptyAnnouncemen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            HugeIcons.strokeRoundedAdvertisiment,
            size: 80,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.announcement_no_data.trnsltd,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(.7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
