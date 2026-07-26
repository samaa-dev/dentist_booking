import 'package:dentist_booking_app/core/blocs/theme/theme_cubit.dart';
import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/app_version_text.dart';
import '../../../core/widgets/header_background.dart';
import '../../../generated/locale_keys.g.dart';
import '../../auth/blocs/auth/auth_cubit.dart';
import '../../auth/screen/complete_profile_screen.dart';
import '../widget/change_lang.dart';
import '../widget/setting_item.dart';
import '../widget/user_info_profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // التحقق هل المستخدم ضيف؟
        final bool isGuest = state is Status && state.typeLogin == TypeLogin.guest;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: context.reversedSystemUiOverlayStylebrightness,
          child: Scaffold(
            body: Stack(
              children: [
                const HeaderBackground(),
                isGuest ? _buildGuestWelcomeCard(context) : const UserInfoProfileCard(),

                Positioned.fill(
                  top: 230,
                  child: CustomScrollView(
                    slivers: [
                      isGuest ? const SliverToBoxAdapter(child: SizedBox(height: 25)) : const SliverToBoxAdapter(),
                      _buildThemeModel(context),

                      if (!isGuest)
                        SliverToBoxAdapter(
                          child: SettingItem(
                            title: LocaleKeys.edit_profile.trnsltd,
                            icon: HugeIcons.strokeRoundedPen01,
                            onTap: () => _onEditProfileTap(context, state),
                          ),
                        ),

                      SliverToBoxAdapter(
                        child: SettingItem(
                          title: LocaleKeys.language_button.trnsltd,
                          icon: HugeIcons.strokeRoundedGlobe,
                          onTap: () => onLanguageTap(context),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: SettingItem(
                          isLogOut: true,
                          backgroundColor: isGuest ? colorScheme.secondary : colorScheme.primary,
                          // تغيير النص بناءً على الحالة
                          title: isGuest
                              ? LocaleKeys
                                    .login_with_google
                                    .trnsltd // نص "تسجيل الدخول" للضيف
                              : LocaleKeys.logout_button.trnsltd,
                          icon: isGuest ? HugeIcons.strokeRoundedLogin03 : HugeIcons.strokeRoundedLogout01,
                          trailing: const SizedBox.shrink(),
                          onTap: () => isGuest ? _onLoginRedirect(context) : _onLogoutPressed(context),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 25)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: context.mediaQuery.width,
                    alignment: Alignment.center,
                    child: AppVersionText(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuestWelcomeCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                HugeIcons.strokeRoundedUserStatus,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.continue_as_guest.trnsltd,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                LocaleKeys.guest_mode_message.trnsltd,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEditProfileTap(BuildContext context, AuthState state) {
    if (state is! Status || state.typeLogin == TypeLogin.guest) return;
    final meta = state.data;
    if (meta == null || meta is! Map<String, dynamic>) return;
    final raw = meta['raw_user_meta_data'];
    if (raw is! Map<String, dynamic>) return;
    final authCubit = context.read<AuthCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: authCubit,
          child: CompleteProfileScreen(profile: raw),
        ),
      ),
    );
  }

  void _onLoginRedirect(BuildContext context) {
    context.read<AuthCubit>().signOut();
  }

  void _onLogoutPressed(BuildContext context) {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.logout_message.trnsltd,
      content: LocaleKeys.logout_confirm_message.trnsltd,
      buttonCancelText: LocaleKeys.logout_cancel.trnsltd,
      buttonConfirmText: LocaleKeys.logout_confirm.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        Navigator.of(context).pop();
        context.read<AuthCubit>().signOut();
      },
    );
  }

  _buildThemeModel(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDark = state.mode == AppMode.dark;
          final seedColor = state.theme.seedColor;

          return SettingItem(
            icon: isDark ? HugeIcons.strokeRoundedMoon02 : HugeIcons.strokeRoundedSun03,
            title: isDark ? LocaleKeys.settings_theme_dark.trnsltd : LocaleKeys.settings_theme_light.trnsltd,
            subtitle: isDark ? LocaleKeys.settings_switch_to_light.trnsltd : LocaleKeys.settings_switch_to_dark.trnsltd,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onThemeTap(context),
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: seedColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: isDark,
                  onChanged: (value) => context.read<ThemeCubit>().toggleMode(),
                ),
              ],
            ),
            onTap: () => context.read<ThemeCubit>().toggleMode(),
            onLongPress: () => onThemeTap(context),
          );
        },
      ),
    );
  }
}
