import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/widgets/custom_filled_button.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/util/util.dart';
import '../../../core/widgets/appbar/app_bar.dart';
import '../../../core/widgets/custom_date_picker.dart';
import '../../../core/widgets/custom_outlined_button.dart';
import '../../../core/widgets/custom_text_form_field.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({
    super.key,
    this.profile,
  });

  final Map<String, dynamic>? profile;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  DateTime _selectedDate = DateTime.now();
  bool _hasBirthError = true;

  final _formKey = GlobalKey<FormState>();

  bool get _isEditMode => widget.profile != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.profile?['full_name'] ?? "",
    );

    _phoneController = TextEditingController(
      text: widget.profile?['phone'] ?? "",
    );
    _addressController = TextEditingController(
      text: widget.profile?['address'] ?? "",
    );

    final birthDateStr = widget.profile?['birth_date'];
    if (birthDateStr is String) {
      final parsed = DateTime.tryParse(birthDateStr);
      if (parsed != null) {
        _selectedDate = parsed;
        _hasBirthError = _computeBirthError(parsed);
      }
    }
  }

  bool _computeBirthError(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    final hasBirthdayPassedThisYear =
        (now.month > birthDate.month) || (now.month == birthDate.month && now.day >= birthDate.day);
    final realAge = hasBirthdayPassedThisYear ? age : age - 1;
    return realAge < 18;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: TitleAppBar(
          icon: HugeIcons.strokeRoundedUserCircle,
          text: _isEditMode ? LocaleKeys.edit_profile.trnsltd : LocaleKeys.complete_profile.trnsltd,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    CustomTextFormField(
                      hintText: LocaleKeys.full_name.trnsltd,
                      controller: _fullNameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(HugeIcons.strokeRoundedPen01),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.full_name_error.trnsltd;
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    CustomTextFormField(
                      hintText: LocaleKeys.phone.trnsltd,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(HugeIcons.strokeRoundedSmartPhone01),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.phone_error.trnsltd;
                        }
                      },
                    ),
                    SizedBox(height: 12),

                    CustomDatePickerField(
                      selectedDate: _selectedDate,
                      hint: LocaleKeys.brith_date.trnsltd,
                      errorText: _hasBirthError ? LocaleKeys.brith_date_error.trnsltd : null,
                      onChanged: (date) {
                        setState(() => _selectedDate = date);
                        _checkBirthDate();
                      },
                    ),
                    SizedBox(height: 12),

                    CustomTextFormField(
                      hintText: LocaleKeys.address.trnsltd,
                      controller: _addressController,
                      keyboardType: TextInputType.text,
                      maxLines: 2,
                      prefixIcon: Icon(HugeIcons.strokeRoundedGps01),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.address_error.trnsltd;
                        }
                      },
                    ),

                    SizedBox(height: 24),
                    CustomFilledButton(
                      icon: Icon(HugeIcons.strokeRoundedCheckmarkCircle01),
                      text: LocaleKeys.complete_profile_button.trnsltd,
                      textColor: colorScheme.onPrimary,
                      onPressed: () => _onSaveProfilePressed(context),
                    ),
                    if (!_isEditMode) ...[
                      SizedBox(height: 12),
                      CustomOutlinedButton(
                        icon: Icon(HugeIcons.strokeRoundedLogout01),
                        text: LocaleKeys.logout_button.trnsltd,
                        onPressed: () => _onLogoutPressed(context),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void _checkBirthDate() {
    setState(() => _hasBirthError = _computeBirthError(_selectedDate));
  }

  void _onSaveProfilePressed(BuildContext context) async {
    if (!_formKey.currentState!.validate() || _hasBirthError) return;

    final profile = {
      'full_name': _fullNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'birth_date': _selectedDate.toIso8601String(),
    };

    SnackbarMes.showLoadingDialog(context);

    final ok = await context.read<AuthCubit>().updateProfile(profile);

    if (context.mounted) Navigator.of(context).pop(); // close loading dialog
    if (_isEditMode && context.mounted) Navigator.of(context).pop(); // return to profile screen

    if (ok && context.mounted) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.update_profile_success.trnsltd,
      );
    }

    if (!ok && context.mounted) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.update_profile_failed.trnsltd,
      );
    }
  }
}
