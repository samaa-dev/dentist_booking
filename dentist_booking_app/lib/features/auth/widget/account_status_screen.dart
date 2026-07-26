import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/enum/enum.dart';

class AccountStatusScreen extends StatelessWidget {
  final AccountStatus status;

  const AccountStatusScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.defaultSystemUiOverlayStylebrightness,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container
                // Container(
                //   width: 150,
                //   height: 150,
                //   decoration: BoxDecoration(
                //     color: _getStatusColor(context).withOpacity(0.1),
                //     shape: BoxShape.circle,
                //     border: Border.all(
                //       color: _getStatusColor(context).withOpacity(0.3),
                //       width: 2,
                //     ),
                //   ),
                //   child: Center(
                //     child: Icon(
                //       Icons.add_ic_call_outlined,
                //       size: 70,
                //       color: _getStatusColor(context),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 32),
                // Title
                // Text(
                //   _getStatusTitle(),
                //   style: textTheme.headlineSmall?.copyWith(
                //     fontWeight: FontWeight.bold,
                //     color: _getStatusColor(context),
                //     letterSpacing: 0.5,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 16),
                // Description
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //   child: Text(
                //     _getStatusDescription(),
                //     textAlign: TextAlign.center,
                //     style: textTheme.bodyMedium?.copyWith(
                //       color: colorScheme.onSurface.withOpacity(0.8),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 32),
                // Action button
                // if (status != AccountStatus.banned &&
                //     status != AccountStatus.appMaintenance) ...[
                //   SizedBox(
                //     width: double.infinity,
                //     child: FilledButton(
                //       style: FilledButton.styleFrom(
                //         backgroundColor: _getStatusColor(context),
                //         padding: const EdgeInsets.symmetric(vertical: 16),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(32),
                //         ),
                //       ),
                //       onPressed: () => _handleAction(context),
                //       child: Text(
                //         status == AccountStatus.inactive
                //             ? LocaleKeys.ActivateAccountButton.trnsltd
                //             : LocaleKeys.ContactSupportButton.trnsltd,
                //         style: textTheme.bodyMedium?.copyWith(
                //           color: colorScheme.onPrimary,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
              // const SizedBox(height: 16),
              // SizedBox(
              //   width: 200,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       // backgroundColor: _getStatusColor(context),
              //     ),
              //     label: Text(
              //       LocaleKeys.Settings_Logout.trnsltd,
              //       style: textTheme.bodyMedium?.copyWith(
              //         color: _getStatusColor(context),
              //       ),
              //     ),
              //     icon: Icon(
              //       HugeIcons.strokeRoundedLogout01,
              //       color: _getStatusColor(context),
              //     ),
              //     onPressed: () => _onLogoutPressed(context),
              //   ),
              // ),
              // ],
            ),
          ),
        ),
      ),
    );
  }

  // _onLogoutPressed(BuildContext context) => context.read<AuthCubit>().signOut();

  // void _handleAction(BuildContext context) {
  //   // switch (status) {
  //   //   case UserStatus.inactive:
  //   //     // Navigate to activation page
  //   //     // Navigator.pushNamed(context, '/activate-account');
  //   //     SnackbarMes.goToUrl(
  //   //       context,
  //   //       url: 'https://badilk.com/contact',
  //   //     );
  //   //     break;
  //   //   case UserStatus.suspended:
  //   //   case UserStatus.banned:
  //   //     // Navigate to support contact page
  //   //     // Navigator.pushNamed(context, '/contact-support');
  //   //     SnackbarMes.goToUrl(
  //   //       context,
  //   //       url: 'https://badilk.com/contact',
  //   //     );
  //   //     break;
  //   //   default:
  //   //     // Default action or no action needed
  //   //     break;
  //   // }
  // }

  // IconData _getStatusIcon() {
  //   return switch (status) {
  //     UserStatus.inactive => Icons.pending_actions_rounded,
  //     UserStatus.suspended => Icons.do_not_disturb_on_rounded,
  //     UserStatus.banned => Icons.block_rounded,
  //     UserStatus.paused => Icons.pause_circle_filled_rounded,
  //     UserStatus.appMaintenance => Icons.construction_rounded, // 🛠️
  //     _ => Icons.error_outline_rounded,
  //   };
  // }

  // Color _getStatusColor(BuildContext context) {
  //   final colorScheme = Theme.of(context).colorScheme;

  //   return switch (status) {
  //     UserStatus.inactive => colorScheme.primary,
  //     UserStatus.suspended => colorScheme.secondary,
  //     UserStatus.banned => colorScheme.error,
  //     UserStatus.paused => colorScheme.secondary,
  //     UserStatus.appMaintenance => colorScheme.secondary, // 🔧
  //     _ => colorScheme.onSurface,
  //   };
  // }

  // String _getStatusTitle() {
  //   return switch (status) {
  //     AccountStatus.inactive => LocaleKeys.AccountStatus.trnsltd,
  //     AccountStatus.suspended => LocaleKeys.AccountStatus.trnsltd,
  //     AccountStatus.banned => LocaleKeys.AccountStatus.trnsltd,
  //     AccountStatus.paused => LocaleKeys.AccountStatus.trnsltd,
  //     AccountStatus.appMaintenance => LocaleKeys.AccountStatus.trnsltd,
  //     _ => 'Account Status',
  //   };
  // }

  // String _getStatusDescription() {
  //   return switch (status) {
  //     UserStatus.inactive => LocaleKeys.accountStatus.trnsltd,
  //     UserStatus.suspended => LocaleKeys.AccountSuspendedDescription.trnsltd,
  //     UserStatus.banned => LocaleKeys.AccountBannedDescription.trnsltd,
  //     UserStatus.paused => LocaleKeys.AccountPausedDescription.trnsltd,
  //     UserStatus.appMaintenance =>
  //       LocaleKeys.AccountAppMaintenanceDescription.trnsltd,
  //     _ => 'There is an issue with your account status.',
  //   };
  // }
}
