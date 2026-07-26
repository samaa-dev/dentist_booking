import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../generated/locale_keys.g.dart';

class EmptyBooking extends StatelessWidget {
  const EmptyBooking({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            HugeIcons.strokeRoundedAddToList,
            size: 70,
            color: colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.booking_no_data.trnsltd,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
