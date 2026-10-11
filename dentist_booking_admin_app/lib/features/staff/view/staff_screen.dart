import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/access/app_permission.dart';
import '../../../core/app_setup.dart';
import '../../../core/enum/enum.dart';
import '../../../core/extensions/os_extensions.dart';
import '../../../core/model/staff_member.dart';
import '../../../core/util/util.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff_cubit.dart';
import '../widget/staff_password_dialog.dart';
import 'staff_form_page.dart';

/// Staff accounts (admin only), opened from the profile tab.
class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const StaffScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StaffCubit>(
      create: (_) => getIt<StaffCubit>()..load(),
      child: const _StaffView(),
    );
  }
}

class _StaffView extends StatelessWidget {
  const _StaffView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.staff_management.trnsltd)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => StaffFormPage.open(context),
        icon: const Icon(HugeIcons.strokeRoundedUserAdd01),
        label: Text(LocaleKeys.add_staff.trnsltd),
      ),
      body: BlocBuilder<StaffCubit, StaffState>(
        builder: (context, state) {
          return switch (state) {
            StaffLoading() => const Center(child: CircularProgressIndicator()),
            StaffError(:final message) => _Message(
              icon: HugeIcons.strokeRoundedWifiError01,
              text: message,
              onRetry: () => context.read<StaffCubit>().load(),
            ),
            StaffLoaded(:final members) when members.isEmpty => _Message(
              icon: HugeIcons.strokeRoundedUserAccount,
              text: LocaleKeys.staff_no_data.trnsltd,
            ),
            StaffLoaded(:final members) => RefreshIndicator(
              onRefresh: () => context.read<StaffCubit>().load(showLoading: false),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                itemCount: members.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _StaffCard(member: members[i]),
              ),
            ),
          };
        },
      ),
      backgroundColor: colorScheme.surface,
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.member});

  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = colorScheme.onSurface.withOpacity(.6);
    final locale = Localizations.localeOf(context).languageCode;
    final permissions = AppPermission.values.where(member.permissions.contains);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withOpacity(.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => StaffFormPage.open(context, member: member),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.fullName,
                          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${member.position.label} · ${member.email}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(color: muted),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: member.isActive,
                    onChanged: (v) async {
                      final error = await context.read<StaffCubit>().setActive(
                        member.id,
                        active: v,
                      );
                      if (error != null && context.mounted) {
                        SnackbarMes.showToastMsg(context, message: error);
                      }
                    },
                  ),
                  _Menu(member: member),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: permissions.isEmpty
                        ? Text(
                            LocaleKeys.staff_no_permissions.trnsltd,
                            style: TextStyle(color: colorScheme.error, fontSize: 12),
                          )
                        : Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final p in permissions)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(p.icon, size: 14, color: colorScheme.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        p.label,
                                        style: TextStyle(fontSize: 11, color: colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ),
                  if (member.lastSeen != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: Text(
                        timeago.format(member.lastSeen!, locale: locale),
                        style: textTheme.bodySmall?.copyWith(color: muted, fontSize: 11),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({required this.member});

  final StaffMember member;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            StaffFormPage.open(context, member: member);
          case 'password':
            StaffPasswordDialog.show(context, member);
          case 'delete':
            _confirmDelete(context);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: const Icon(HugeIcons.strokeRoundedEdit03),
            title: Text(LocaleKeys.edit_staff.trnsltd),
          ),
        ),
        PopupMenuItem(
          value: 'password',
          child: ListTile(
            leading: const Icon(HugeIcons.strokeRoundedLock),
            title: Text(LocaleKeys.staff_change_password.trnsltd),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(HugeIcons.strokeRoundedDelete01, color: colorScheme.error),
            title: Text(
              LocaleKeys.staff_delete_title.trnsltd,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<StaffCubit>();
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.staff_delete_title.trnsltd,
      content: LocaleKeys.staff_delete_confirm_detail.trnsltd,
      buttonCancelText: LocaleKeys.CancelButton.trnsltd,
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

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: Text(LocaleKeys.retry.trnsltd)),
            ],
          ],
        ),
      ),
    );
  }
}
