import 'package:dentist_booking_admin_app/core/blocs/theme/theme_cubit.dart';
import 'package:dentist_booking_admin_app/core/enum/enum.dart';
import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/widgets/choose_theme_dialog.dart';
import 'package:dentist_booking_admin_app/core/widgets/header_background.dart';
import 'package:dentist_booking_admin_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../../core/util/util.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          const HeaderBackground(height: 140),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedUserCircle,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.Profile.trnsltd,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.15),
                          ),
                        ),
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final role = state.maybeWhen(
                              status: (_, __, role) => role,
                              orElse: () => null,
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.email ?? '—',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _roleLabel(role),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ProfileTile(
                        icon: HugeIcons.strokeRoundedEarth,
                        title: context.locale.languageCode == 'ar'
                            ? 'اللغة'
                            : 'Language',
                        subtitle: context.locale.languageCode == 'ar'
                            ? 'العربية'
                            : 'English',
                        onTap: () {
                          if (context.locale.languageCode == 'ar') {
                            context.setLocale(const Locale('en'));
                          } else {
                            context.setLocale(const Locale('ar', 'DZ'));
                          }
                        },
                      ),
                      _ProfileTile(
                        icon: HugeIcons.strokeRoundedMoon02,
                        title: context.locale.languageCode == 'ar'
                            ? 'المظهر'
                            : 'Theme',
                        subtitle: context.watch<ThemeCubit>().state.mode ==
                                AppMode.dark
                            ? 'Dark'
                            : 'Light',
                        onTap: () =>
                            context.read<ThemeCubit>().toggleMode(),
                      ),
                      _ProfileTile(
                        icon: HugeIcons.strokeRoundedColors,
                        title: LocaleKeys.booking_theme_title.trnsltd,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const ChooseThemesDialog(),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          SnackbarMes.showCustomDialog(
                            context,
                            title: LocaleKeys.SignOutTitle.trnsltd,
                            content: LocaleKeys.SignOutDescription.trnsltd,
                            buttonCancelText: LocaleKeys.CancelButton.trnsltd,
                            buttonConfirmText: LocaleKeys.logout_button.trnsltd,
                            onCancel: () => Navigator.pop(context),
                            onConfirm: () {
                              Navigator.pop(context);
                              context.read<AuthCubit>().signOut();
                            },
                          );
                        },
                        icon: const Icon(HugeIcons.strokeRoundedLogout01),
                        label: Text(LocaleKeys.logout_button.trnsltd),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _roleLabel(UserRole? role) {
  return switch (role) {
    UserRole.admin => LocaleKeys.admin.trnsltd,
    UserRole.doctor => LocaleKeys.doctor.trnsltd,
    UserRole.staff => LocaleKeys.staff.trnsltd,
    _ => LocaleKeys.patient.trnsltd,
  };
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
