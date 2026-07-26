import 'package:flutter/material.dart';

import '../../../core/enum/enum.dart';

class BookingDateScopeSelector extends StatelessWidget {
  final BookingDateScope selectedScope;
  final Function(BookingDateScope? scope) onScopeChanged;

  const BookingDateScopeSelector({
    super.key,
    required this.selectedScope,
    required this.onScopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scopes = BookingDateScope.values
        .where((s) => s != BookingDateScope.other)
        .toList();

    return SizedBox(
      height: 40,

      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: scopes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          final scope = scopes[index];

          return _DateScopeChip(
            label: scope.name,
            selected: selectedScope == scope,
            onTap: () => onScopeChanged(scope),
          );
        },
      ),
    );
  }
}

class _DateScopeChip extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onTap;

  const _DateScopeChip({
    required this.selected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? colorScheme.primary
              : colorScheme.surfaceVariant.withOpacity(0.20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
