import 'package:dentist_booking_admin/core/blocs/theme/theme_cubit.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/widgets/footer_view.dart';
import '../../../blocs/auth/auth_cubit.dart';
import '../widgets/auth_sign_in_button.dart';
import '../widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final size = MediaQuery.of(context).size;

    /// Responsive width
    double cardWidth = size.width * 0.30;
    if (cardWidth < 450) cardWidth = 450;
    if (cardWidth > 600) cardWidth = 600;

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageToggle(context),
                const SizedBox(height: 5),
                _buildThemeToggle(context),
              ],
            ),
            SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: cardWidth,
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 28,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Logo
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            HugeIcons.strokeRoundedDentalTooth,
                            size: 70,
                            color: colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// Title
                        Text(
                          LocaleKeys.login_welcome.trnsltd,
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleKeys.login_subtitle.trnsltd,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),

                        SignInForm(),

                        // Login Button
                        _buildSignInButton(context),

                        const SizedBox(height: 16),

                        /// Footer
                        Text(
                          LocaleKeys.login_footer.trnsltd,
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimary.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FooterView(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildLanguageToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.2),
        shape: BoxShape.circle,
      ),
      child: IconButton.filledTonal(
        icon: const Icon(HugeIcons.strokeRoundedEarth),
        color: colorScheme.primary,
        onPressed: () {
          if (locale.languageCode == 'ar') {
            context.setLocale(const Locale('en'));
          } else {
            context.setLocale(const Locale('ar', 'DZ'));
          }
        },
      ),
    );
  }

  _buildThemeToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.2),
        shape: BoxShape.circle,
      ),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDark = state.mode == AppMode.dark;
          return IconButton.filledTonal(
            icon: isDark
                ? const Icon(HugeIcons.strokeRoundedMoon02)
                : const Icon(HugeIcons.strokeRoundedSun01),
            color: colorScheme.primary,
            onPressed: () => context.read<ThemeCubit>().toggleMode(),
          );
        },
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loading: () => true,
          error: (message) => true,
        );
      },

      builder: (context, state) {
        final bool isLoading = state is Loading;
        final bool isError = state is Error;

        final bool isDisabled = isLoading;

        return AuthSignInButton(
          isLoading: isLoading,
          onPressed: isDisabled
              ? null
              : () => context.read<AuthCubit>().signInWithEmailAndPassword(),
          text: LocaleKeys.login_button.trnsltd,
          icon: !isDisabled ? HugeIcons.strokeRoundedArrowLeft01 : null,
          backgroundColor: colorScheme.onPrimary,
          textColor: isLoading || isError
              ? colorScheme.onSurface
              : colorScheme.onPrimaryContainer,
          disabledTextColor: colorScheme.onSurface,
        );
      },
    );
  }
}
