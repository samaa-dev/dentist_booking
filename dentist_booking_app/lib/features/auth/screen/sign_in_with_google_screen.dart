import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../widget/sign_in_with_google_form.dart';

class SignInWithGoogleScreen extends StatelessWidget {
  const SignInWithGoogleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color topContentColor = isDark ? Colors.white : colorScheme.primary;
    final Color subtitleColor = isDark ? Colors.white.withOpacity(0.7) : colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        colorScheme.primary,
                        colorScheme.primaryContainer.withOpacity(0.8),
                        colorScheme.surface,
                      ]
                    : [
                        colorScheme.surface,
                        colorScheme.surface,
                      ],
              ),
            ),
          ),

          _buildBackgroundCircles(isDark, colorScheme),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const Spacer(flex: 2),

                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 900),
                  tween: Tween(begin: 0, end: 1),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * -30),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      _buildLogo(context, topContentColor),
                      const SizedBox(height: 24),

                      Text(
                        LocaleKeys.dr_kheireddine_clinic.trnsltd,
                        style: textTheme.titleLarge!.copyWith(
                          color: topContentColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        LocaleKeys.dental_specialist.trnsltd,
                        style: textTheme.titleSmall!.copyWith(
                          color: topContentColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      _buildDivider(topContentColor),
                      const SizedBox(height: 35),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          LocaleKeys.login_title.trnsltd,
                          style: textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: topContentColor,
                            letterSpacing: -1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          LocaleKeys.login_subtitle.trnsltd,
                          style: textTheme.bodyLarge!.copyWith(
                            color: subtitleColor,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),
                const SignInWithGoogleForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircles(bool isDark, ColorScheme colorScheme) {
    final circleColor = isDark ? Colors.white.withOpacity(0.05) : colorScheme.primary.withOpacity(0.03);
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: CircleAvatar(radius: 120, backgroundColor: circleColor),
        ),
        Positioned(
          top: 150,
          left: -30,
          child: CircleAvatar(radius: 60, backgroundColor: circleColor),
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context, Color color) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Image.asset(
        "assets/images/logo.png",
        width: 60,
        height: 60,
        color: colorScheme.primary,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 3,
      width: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.01), color, color.withOpacity(0.01)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
