import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/widgets/custom_filled_button.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../generated/locale_keys.g.dart';

class GuestRestrictionView extends StatelessWidget {
  final String message;
  final IconData icon;

  const GuestRestrictionView({
    super.key,
    required this.message,
    this.icon = HugeIcons.strokeRoundedAbacus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnnotatedRegion(
      value: context.reversedSystemUiOverlayStylebrightness,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(icon, size: 45, color: colorScheme.onPrimary),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      Text(
                        LocaleKeys.login_required_title.trnsltd,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 48),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: CustomFilledButton(
                          text: LocaleKeys.login_with_google.trnsltd,
                          icon: const Icon(HugeIcons.strokeRoundedGoogle, size: 20),
                          textColor: colorScheme.onPrimary,
                          onPressed: () => context.read<AuthCubit>().signOut(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
