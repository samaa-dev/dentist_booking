import 'package:flutter/material.dart';

class RowInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget input;

  const RowInput({
    super.key,
    required this.label,
    required this.icon,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 260,
            child: Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.labelLarge!.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),
          Expanded(child: input),
        ],
      ),
    );
  }
}
