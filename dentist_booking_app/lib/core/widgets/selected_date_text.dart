import 'package:flutter/material.dart';

class SelectedDateText extends StatelessWidget {
  const SelectedDateText({
    super.key,
    required this.date,
    required this.prefix,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
  });

  final String? date;
  final String? prefix;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: date,
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
