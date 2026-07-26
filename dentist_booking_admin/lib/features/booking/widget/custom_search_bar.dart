import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          Icon(
            HugeIcons.strokeRoundedSearch01,
            size: 20,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              style: textTheme.bodyMedium!.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.4),
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
