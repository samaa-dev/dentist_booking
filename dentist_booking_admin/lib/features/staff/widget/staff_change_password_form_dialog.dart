// ignore: file_names
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/staff/blocs/staff/staff_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/model/staff_model.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../../../generated/locale_keys.g.dart';

class StaffChangePasswordFormDialog extends StatefulWidget {
  const StaffChangePasswordFormDialog({super.key, required this.staff});

  final StaffModel staff;

  @override
  State<StaffChangePasswordFormDialog> createState() =>
      _StaffChangePasswordFormDialogState();
}

class _StaffChangePasswordFormDialogState
    extends State<StaffChangePasswordFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _passwordController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DialogTitleHeader(
                title: LocaleKeys.change_password.trnsltd,
                subtitle: LocaleKeys.subtitle_change_password.tr(
                  namedArgs: {
                    "name": widget.staff.fullName,
                  },
                ),
              ),

              CustomTextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedSquareLock01,
                  color: colorScheme.onSurface,
                ),
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: () => _togglePasswordVisibility(),
                  icon: Icon(
                    _isPasswordVisible
                        ? HugeIcons.strokeRoundedView
                        : HugeIcons.strokeRoundedViewOff,
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.password_required.trnsltd;
                  }
                },
              ),

              const SizedBox(height: 30),

              FooterDialog(
                title: LocaleKeys.save_button.trnsltd,
                onConfirm: () => _onConfirm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  _onConfirm() {
    if (!_formKey.currentState!.validate() &&
        _passwordController.text.isEmpty) {
      return;
    }

    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.staff_change_password_title.trnsltd,
      content: LocaleKeys.staff_change_password_confirm.tr(
        namedArgs: {
          "name": widget.staff.fullName,
        },
      ),
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.change_password.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        context.read<StaffCubit>().changePassword(
          fullName: widget.staff.fullName,
          staffId: widget.staff.userId,
          newPassword: _passwordController.text,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }
}
