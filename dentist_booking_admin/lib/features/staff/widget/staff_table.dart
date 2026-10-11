import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/access/app_permission.dart';
import '../../../core/enum/enum.dart';
import '../../../core/extensions/os_extensions.dart';
import '../../../core/model/staff_member.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_badg.dart';
import '../../../core/widgets/custom_icon_tabel_cell.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff/staff_cubit.dart';
import 'staff_form_dialog.dart';
import 'staff_password_dialog.dart';

class StaffTable extends StatelessWidget {
  const StaffTable({super.key, required this.members});

  final List<StaffMember> members;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      shadowColor: colorScheme.primary.withOpacity(.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable2(
          columnSpacing: 14,
          horizontalMargin: 16,
          minWidth: 1000,
          headingRowHeight: 52,
          dataRowHeight: 72,
          headingRowColor: WidgetStateProperty.all(
            colorScheme.primary.withOpacity(.07),
          ),
          headingTextStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
          border: TableBorder(
            horizontalInside: BorderSide(
              color: colorScheme.outline.withOpacity(.12),
            ),
          ),
          columns: [
            DataColumn2(
              label: Text(LocaleKeys.staff_member.trnsltd),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(LocaleKeys.staff_phone.trnsltd),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(LocaleKeys.staff_position.trnsltd),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(LocaleKeys.staff_section_permissions.trnsltd),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(LocaleKeys.staff_last_seen.trnsltd),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(LocaleKeys.staff_status.trnsltd),
              fixedWidth: 120,
            ),
            const DataColumn2(label: SizedBox.shrink(), fixedWidth: 130),
          ],
          rows: [
            for (final member in members) _row(context, member),
          ],
        ),
      ),
    );
  }

  DataRow _row(BuildContext context, StaffMember member) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = colorScheme.onSurface.withOpacity(.6);
    final locale = Localizations.localeOf(context).languageCode;

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.hovered)
            ? colorScheme.primary.withOpacity(.06)
            : null,
      ),
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: (member.isActive
                        ? colorScheme.primary
                        : colorScheme.outline)
                    .withOpacity(.15),
                child: Text(
                  member.fullName.isEmpty ? '?' : member.fullName.characters.first,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: member.isActive ? colorScheme.primary : muted,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      member.email,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(
          (member.phone?.isNotEmpty ?? false) ? member.phone! : '-',
        )),
        DataCell(
          CustomBadg(
            label: member.position.label,
            bgcolor: colorScheme.secondary.withOpacity(.12),
            textColor: colorScheme.secondary,
          ),
        ),
        DataCell(_PermissionsSummary(permissions: member.permissions)),
        DataCell(Text(
          member.lastSeen == null
              ? '-'
              : timeago.format(member.lastSeen!, locale: locale),
          style: textTheme.bodySmall?.copyWith(color: muted),
        )),
        DataCell(
          Row(
            children: [
              Switch(
                value: member.isActive,
                onChanged: (v) => _toggleActive(context, member, v),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  member.isActive
                      ? LocaleKeys.staff_active.trnsltd
                      : LocaleKeys.staff_inactive.trnsltd,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: member.isActive ? Colors.green : muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: LocaleKeys.edit_staff.trnsltd,
                child: CustomIconTabelCell(
                  icon: HugeIcons.strokeRoundedEdit03,
                  color: colorScheme.primary,
                  onTap: () => StaffFormDialog.show(context, member: member),
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: LocaleKeys.staff_change_password.trnsltd,
                child: CustomIconTabelCell(
                  icon: HugeIcons.strokeRoundedLock,
                  color: colorScheme.secondary,
                  onTap: () => StaffPasswordDialog.show(context, member),
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: LocaleKeys.staff_delete_title.trnsltd,
                child: CustomIconTabelCell(
                  icon: HugeIcons.strokeRoundedDelete01,
                  color: colorScheme.error,
                  onTap: () => _confirmDelete(context, member),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _toggleActive(
    BuildContext context,
    StaffMember member,
    bool active,
  ) async {
    final error = await context.read<StaffCubit>().setActive(
      member.id,
      active: active,
    );
    if (error != null && context.mounted) {
      SnackbarMes.showToastMsg(context, message: error);
    }
  }

  void _confirmDelete(BuildContext context, StaffMember member) {
    final cubit = context.read<StaffCubit>();
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.staff_delete_title.trnsltd,
      content: LocaleKeys.staff_delete_confirm_detail.trnsltd,
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.delete_button.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () async {
        Navigator.of(context).pop();
        final error = await cubit.delete(member.id);
        if (error != null && context.mounted) {
          SnackbarMes.showToastMsg(context, message: error);
        }
      },
    );
  }
}

class _PermissionsSummary extends StatelessWidget {
  const _PermissionsSummary({required this.permissions});

  final Set<AppPermission> permissions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (permissions.isEmpty) {
      return Text(
        LocaleKeys.staff_no_permissions.trnsltd,
        style: TextStyle(color: colorScheme.error, fontSize: 12),
      );
    }
    final ordered = AppPermission.values.where(permissions.contains);
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final p in ordered)
          Tooltip(
            message: p.label,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(p.icon, size: 16, color: colorScheme.primary),
            ),
          ),
      ],
    );
  }
}
