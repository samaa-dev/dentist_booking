import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/enum/enum.dart';
import '../../../../../core/widgets/footer_view.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../blocs/auth/auth_cubit.dart';

class AccountStatusScreen extends StatelessWidget {
  final AccountStatus status;

  const AccountStatusScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: colorScheme.primary.withOpacity(0.3),
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _getStatusColor(context).withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _getStatusColor(context).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _getStatusIcon(),
                            size: 56,
                            color: _getStatusColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        _getStatusTitle(),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getStatusDescription(),
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getStatusColor(context),
                          ),
                          onPressed: () =>
                              context.read<AuthCubit>().signOut(),
                          icon: Icon(
                            HugeIcons.strokeRoundedLogout01,
                            color: colorScheme.onPrimaryContainer,
                          ),
                          label: Text(
                            LocaleKeys.logout_button.trnsltd,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const FooterView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    return switch (status) {
      AccountStatus.inactive => Icons.pending_actions_rounded,
      AccountStatus.suspended => Icons.do_not_disturb_on_rounded,
      AccountStatus.banned => Icons.block_rounded,
      AccountStatus.paused => Icons.pause_circle_filled_rounded,
      AccountStatus.appMaintenance => Icons.construction_rounded,
      _ => Icons.error_outline_rounded,
    };
  }

  Color _getStatusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      AccountStatus.inactive => colorScheme.secondaryContainer,
      AccountStatus.suspended => colorScheme.tertiaryContainer,
      AccountStatus.banned => colorScheme.errorContainer,
      AccountStatus.paused => colorScheme.secondaryContainer,
      AccountStatus.appMaintenance => colorScheme.secondaryContainer,
      _ => colorScheme.onSurface,
    };
  }

  String _getStatusTitle() {
    return switch (status) {
      AccountStatus.inactive => LocaleKeys.AccountInactive.trnsltd,
      AccountStatus.suspended => LocaleKeys.AccountSuspended.trnsltd,
      AccountStatus.banned => LocaleKeys.AccountBanned.trnsltd,
      AccountStatus.paused => LocaleKeys.AccountPaused.trnsltd,
      AccountStatus.appMaintenance => LocaleKeys.AccountAppMaintenance.trnsltd,
      _ => 'Account Status',
    };
  }

  String _getStatusDescription() {
    return switch (status) {
      AccountStatus.inactive => LocaleKeys.AccountInactiveDescription.trnsltd,
      AccountStatus.suspended => LocaleKeys.AccountSuspendedDescription.trnsltd,
      AccountStatus.banned => LocaleKeys.AccountBannedDescription.trnsltd,
      AccountStatus.paused => LocaleKeys.AccountPausedDescription.trnsltd,
      AccountStatus.appMaintenance =>
        LocaleKeys.AccountAppMaintenanceDescription.trnsltd,
      _ => 'There is an issue with your account status.',
    };
  }
}
