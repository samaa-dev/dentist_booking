import 'package:dentist_booking_admin_app/core/blocs/theme/theme_cubit.dart';
import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLanguageToggle(context),
                    const SizedBox(width: 8),
                    _buildThemeToggle(context),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Text(
                      LocaleKeys.login_welcome.trnsltd,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocaleKeys.login_subtitle.trnsltd,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SignInForm(),
                    _buildSignInButton(context),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.login_footer.trnsltd,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const FooterView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context) {
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

  Widget _buildThemeToggle(BuildContext context) {
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
          error: (_) => true,
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
