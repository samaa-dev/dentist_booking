import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/access/app_permission.dart';
import '../../../core/enum/enum.dart';
import '../../../core/extensions/os_extensions.dart';
import '../../../core/model/staff_member.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff/staff_cubit.dart';
import 'staff_permissions_picker.dart';

/// Create a staff account (email + password + permissions) or edit one.
class StaffFormDialog extends StatefulWidget {
  const StaffFormDialog({super.key, this.member});

  final StaffMember? member;

  static Future<void> show(BuildContext context, {StaffMember? member}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<StaffCubit>(),
        child: StaffFormDialog(member: member),
      ),
    );
  }

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  static const _defaultPermissions = {AppPermission.bookings, AppPermission.queue};

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _password;
  late StaffPosition _position;
  late Set<AppPermission> _permissions;
  bool _obscurePassword = true;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.member != null;

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    _fullName = TextEditingController(text: m?.fullName ?? '');
    _email = TextEditingController(text: m?.email ?? '');
    _phone = TextEditingController(text: m?.phone ?? '');
    _password = TextEditingController();
    _position = m?.position ?? StaffPosition.receptionist;
    _permissions = {...?m?.permissions};
    if (m == null) _permissions = {..._defaultPermissions};
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DialogTitleHeader(
                  title: _isEdit
                      ? LocaleKeys.edit_staff.trnsltd
                      : LocaleKeys.add_staff.trnsltd,
                  subtitle: _isEdit
                      ? LocaleKeys.staff_edit_subtitle.trnsltd
                      : LocaleKeys.staff_create_subtitle.trnsltd,
                ),
                const SizedBox(height: 8),
                _SectionTitle(
                  icon: HugeIcons.strokeRoundedUserAccount,
                  text: LocaleKeys.staff_section_account.trnsltd,
                ),
                const SizedBox(height: 10),
                _row([
                  CustomTextFormField(
                    controller: _fullName,
                    keyboardType: TextInputType.name,
                    hintText: LocaleKeys.staff_full_name.trnsltd,
                    prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
                    validator: _required,
                  ),
                  CustomTextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    hintText: LocaleKeys.staff_phone.trnsltd,
                    prefixIcon: const Icon(HugeIcons.strokeRoundedSmartPhone01),
                  ),
                ]),
                const SizedBox(height: 12),
                _row([
                  CustomTextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: LocaleKeys.staff_email.trnsltd,
                    prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
                    readOnly: _isEdit,
                    validator: _isEdit ? null : _validateEmail,
                  ),
                  CustomDropdown<StaffPosition>(
                    value: _position,
                    enableSearch: false,
                    hintText: LocaleKeys.staff_position.trnsltd,
                    items: StaffPosition.values
                        .map(
                          (p) => DropdownMenuItem(value: p, child: Text(p.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _position = v ?? _position),
                  ),
                ]),
                if (!_isEdit) ...[
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: _password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscurePassword,
                    hintText: LocaleKeys.staff_password.trnsltd,
                    prefixIcon: const Icon(HugeIcons.strokeRoundedLock),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? HugeIcons.strokeRoundedViewOff
                            : HugeIcons.strokeRoundedView,
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    LocaleKeys.staff_password_hint.trnsltd,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(.6),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                _SectionTitle(
                  icon: HugeIcons.strokeRoundedShield01,
                  text: LocaleKeys.staff_section_permissions.trnsltd,
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleKeys.staff_permissions_hint.trnsltd,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(.6),
                  ),
                ),
                const SizedBox(height: 10),
                StaffPermissionsPicker(
                  selected: _permissions,
                  onChanged: (v) => setState(() => _permissions = v),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  _ErrorBanner(message: _error!),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(LocaleKeys.cancel_button.trnsltd),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _submit,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(HugeIcons.strokeRoundedTick02),
                        label: Text(
                          _isEdit
                              ? LocaleKeys.save_button.trnsltd
                              : LocaleKeys.staff_create_button.trnsltd,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 12),
        Expanded(child: children[1]),
      ],
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? LocaleKeys.required_field.trnsltd : null;

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return LocaleKeys.required_field.trnsltd;
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : LocaleKeys.staff_err_invalid_email.trnsltd;
  }

  String? _validatePassword(String? v) {
    if ((v ?? '').length < 6) return LocaleKeys.staff_err_password_short.trnsltd;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final draft = StaffDraft(
      fullName: _fullName.text.trim(),
      phone: _phone.text.trim(),
      position: _position,
      permissions: _permissions,
      email: _email.text.trim(),
      password: _password.text,
    );
    final cubit = context.read<StaffCubit>();
    final error = _isEdit
        ? await cubit.update(widget.member!.id, draft)
        : await cubit.create(draft);

    if (!mounted) return;
    if (error != null) {
      setState(() {
        _saving = false;
        _error = error;
      });
      return;
    }

    Navigator.pop(context);
    SnackbarMes.showToastMsg(
      context,
      message: _isEdit
          ? LocaleKeys.staff_saved.trnsltd
          : LocaleKeys.staff_created.trnsltd,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(HugeIcons.strokeRoundedAlert02, color: colorScheme.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
