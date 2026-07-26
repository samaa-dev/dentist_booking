import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../generated/locale_keys.g.dart';
import '../blocs/auth/auth_cubit.dart';
import 'sign_in_button.dart';

class SignInWithGoogleForm extends StatelessWidget {
  const SignInWithGoogleForm({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: colorScheme.onSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          _buildSignInButton(context),
          const SizedBox(height: 12),
          _buildDivider(context),
          const SizedBox(height: 12),
          _buildGuestButton(context),
          const SizedBox(height: 20),
          _buildSecurityNote(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isLoading = state is Loading;

        return SignInButton(
          isLoading: isLoading,
          onPressed: isLoading ? null : () => context.read<AuthCubit>().signInGoogle(),
          text: LocaleKeys.login_with_google.trnsltd,
          icon: HugeIcons.strokeRoundedGoogle,
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withOpacity(0.5),
          disabledForegroundColor: colorScheme.onPrimary.withOpacity(0.5),
        );
      },
    );
  }

  Widget _buildGuestButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton.icon(
      onPressed: () => context.read<AuthCubit>().signInGuest(),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        side: BorderSide(
          color: colorScheme.onSecondary.withOpacity(0.2),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        foregroundColor: colorScheme.onSecondary,
        disabledForegroundColor: colorScheme.onSecondary.withOpacity(0.3),
      ),
      icon: const Icon(HugeIcons.strokeRoundedUserStatus, size: 20),
      label: Text(
        LocaleKeys.continue_as_guest.trnsltd,
        style: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSecondary,
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.onSecondary.withOpacity(0.1),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            LocaleKeys.or_label.trnsltd,
            style: TextStyle(
              color: colorScheme.onSecondary.withOpacity(0.4),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.onSecondary.withOpacity(0.1),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNote(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.onSecondary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            HugeIcons.strokeRoundedShield02,
            size: 14,
            color: colorScheme.onSecondary.withOpacity(0.4),
          ),
          const SizedBox(width: 8),
          Text(
            LocaleKeys.login_secure_google.trnsltd,
            style: TextStyle(
              color: colorScheme.onSecondary.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
