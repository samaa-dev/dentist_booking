import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.text,
    required this.bgColor,
    required this.txtColor,
  });

  final String text;
  final Color bgColor;
  final Color txtColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: textTheme.labelMedium?.copyWith(
          color: txtColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
