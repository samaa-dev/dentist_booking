import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../generated/locale_keys.g.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: context.read<AuthCubit>().formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      child: Column(
        children: [
          const SizedBox(height: 32),
          CustomTextFormField(
            hintText: LocaleKeys.login_email.trnsltd,
            fillColor: colorScheme.onPrimary,
            controller: context.read<AuthCubit>().emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            hintText: LocaleKeys.login_password.trnsltd,
            fillColor: colorScheme.onPrimary,
            controller: context.read<AuthCubit>().passwordController,
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(HugeIcons.strokeRoundedSquareLock01),
            obscureText: !_isPasswordVisible,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => _togglePasswordVisibility(),
                icon: Icon(
                  _isPasswordVisible
                      ? HugeIcons.strokeRoundedView
                      : HugeIcons.strokeRoundedViewOff,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
}
