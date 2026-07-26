import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.textColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        iconSize: 26,
        // disabledBackgroundColor: colorScheme.secondary,
        // disabledForegroundColor: colorScheme.onSecondary,
        disabledIconColor: colorScheme.outline,
      ),
      label: Text(
        text,
        style: textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor ?? colorScheme.primary,
        ),
      ),
      icon: icon,

      onPressed: onPressed,
    );
  }
}
