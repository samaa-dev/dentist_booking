import 'package:flutter/material.dart';

class DialogTitleHeader extends StatelessWidget {
  const DialogTitleHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          children: [
            Spacer(),

            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Spacer(),

            Divider(
              thickness: 0.6,
              height: 1,
              color: colorScheme.primary.withOpacity(0.2),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
