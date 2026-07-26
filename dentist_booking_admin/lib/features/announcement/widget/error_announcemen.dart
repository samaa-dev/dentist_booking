import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ErrorAnnouncemen extends StatelessWidget {
  const ErrorAnnouncemen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            HugeIcons.strokeRoundedWifiError01,
            size: 80,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(.7),
            ),
          ),
        ],
      ),
    );
  }
}
