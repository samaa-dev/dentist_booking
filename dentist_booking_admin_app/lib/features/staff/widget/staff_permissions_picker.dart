import 'package:flutter/material.dart';

import '../../../core/access/app_permission.dart';

/// Grid of permission cards with a short explanation for each.
class StaffPermissionsPicker extends StatelessWidget {
  const StaffPermissionsPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<AppPermission> selected;
  final ValueChanged<Set<AppPermission>> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 560 ? 2 : 1;
        final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final permission in AppPermission.values)
              SizedBox(
                width: width,
                child: _PermissionTile(
                  permission: permission,
                  checked: selected.contains(permission),
                  onTap: () {
                    final next = {...selected};
                    next.contains(permission)
                        ? next.remove(permission)
                        : next.add(permission);
                    onChanged(next);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.permission,
    required this.checked,
    required this.onTap,
  });

  final AppPermission permission;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = checked ? colorScheme.primary : colorScheme.outline;

    return Material(
      color: checked
          ? colorScheme.primary.withOpacity(.08)
          : colorScheme.surfaceContainerHighest.withOpacity(.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withOpacity(checked ? .6 : .25)),
          ),
          child: Row(
            children: [
              Icon(permission.icon, color: accent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      permission.label,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      permission.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(.6),
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(value: checked, onChanged: (_) => onTap()),
            ],
          ),
        ),
      ),
    );
  }
}
