import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/widgets/footer_view.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../blocs/auth/auth_cubit.dart';

class RoleDeniedScreen extends StatelessWidget {
  const RoleDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
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
                      Icon(
                        HugeIcons.strokeRoundedSecurityBlock,
                        size: 72,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        LocaleKeys.AccountBanned.trnsltd,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        LocaleKeys.AccountBannedDescription.trnsltd,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary.withOpacity(0.85),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.onPrimary,
                          ),
                          onPressed: () =>
                              context.read<AuthCubit>().signOut(),
                          icon: Icon(
                            HugeIcons.strokeRoundedLogout01,
                            color: colorScheme.primary,
                          ),
                          label: Text(
                            LocaleKeys.logout_button.trnsltd,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
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
}
