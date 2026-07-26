import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(50),

        iconSize: 20,
        side: BorderSide(
          color: colorScheme.primary,
          width: 1,
        ),
      ),
      label: Text(
        text,
        style: textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
      icon: icon,

      onPressed: onPressed,
    );
  }
}
