import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/extensions/os_extensions.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff/staff_cubit.dart';
import 'staff_form_dialog.dart';

class StaffHeader extends StatelessWidget {
  const StaffHeader({super.key, this.activeCount});

  final int? activeCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.staff_management.trnsltd,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activeCount == null
                  ? LocaleKeys.staff_header_subtitle.trnsltd
                  : LocaleKeys.staff_active_count.tr(
                      namedArgs: {'count': '$activeCount'},
                    ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(.6),
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          tooltip: LocaleKeys.refresh.trnsltd,
          onPressed: () => context.read<StaffCubit>().load(),
          icon: Icon(HugeIcons.strokeRoundedRefresh, color: colorScheme.primary),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(HugeIcons.strokeRoundedUserAdd01, size: 20),
          label: Text(LocaleKeys.add_staff.trnsltd),
          onPressed: () => StaffFormDialog.show(context),
        ),
      ],
    );
  }
}
