import 'package:flutter/material.dart';

class SectionTitleHeading extends StatelessWidget {
  const SectionTitleHeading({
    super.key,
    required this.title,
    this.description,
    this.showActionButton = false,
    this.actionCallback,
  });

  final bool showActionButton;
  final String title;
  final String? description;
  final VoidCallback? actionCallback;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: textTheme.bodySmall!.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.65),
                      fontSize: 12.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ],
            ),
          ),
          if (showActionButton)
            GestureDetector(
              onTap: actionCallback,
              child: Text(
                "عرض الكل",
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SupSectionHeading extends StatelessWidget {
  const SupSectionHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall!.copyWith(
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
