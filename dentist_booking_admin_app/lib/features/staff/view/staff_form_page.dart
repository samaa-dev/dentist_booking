import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/access/app_permission.dart';
import '../../../core/enum/enum.dart';
import '../../../core/extensions/os_extensions.dart';
import '../../../core/model/staff_member.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff_cubit.dart';
import '../widget/staff_permissions_picker.dart';

/// Full-screen create / edit form for a staff account.
class StaffFormPage extends StatefulWidget {
  const StaffFormPage({super.key, this.member});

  final StaffMember? member;

  static Future<void> open(BuildContext context, {StaffMember? member}) {
    final cubit = context.read<StaffCubit>();
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: StaffFormPage(member: member),
        ),
      ),
    );
  }

  @override
  State<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _password;
  late StaffPosition _position;
  late Set<AppPermission> _permissions;
  bool _obscure = true;
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
    _permissions = m == null
        ? {AppPermission.bookings, AppPermission.queue}
        : {...m.permissions};
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
    final muted = colorScheme.onSurface.withOpacity(.6);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? LocaleKeys.edit_staff.trnsltd : LocaleKeys.add_staff.trnsltd,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _title(context, HugeIcons.strokeRoundedUserAccount, LocaleKeys.staff_section_account.trnsltd),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: _fullName,
              keyboardType: TextInputType.name,
              hintText: LocaleKeys.staff_full_name.trnsltd,
              prefixIcon: const Icon(HugeIcons.strokeRoundedUser),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? LocaleKeys.required_field.trnsltd
                  : null,
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              hintText: LocaleKeys.staff_email.trnsltd,
              prefixIcon: const Icon(HugeIcons.strokeRoundedMail01),
              readOnly: _isEdit,
              validator: _isEdit
                  ? null
                  : (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return LocaleKeys.required_field.trnsltd;
                      return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
                          ? null
                          : LocaleKeys.staff_err_invalid_email.trnsltd;
                    },
            ),
            if (!_isEdit) ...[
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscure,
                hintText: LocaleKeys.staff_password.trnsltd,
                prefixIcon: const Icon(HugeIcons.strokeRoundedLock),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? HugeIcons.strokeRoundedViewOff : HugeIcons.strokeRoundedView,
                  ),
                ),
                validator: (v) => (v ?? '').length < 6
                    ? LocaleKeys.staff_err_password_short.trnsltd
                    : null,
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys.staff_password_hint.trnsltd,
                style: textTheme.bodySmall?.copyWith(color: muted),
              ),
            ],
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              hintText: LocaleKeys.staff_phone.trnsltd,
              prefixIcon: const Icon(HugeIcons.strokeRoundedSmartPhone01),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<StaffPosition>(
              initialValue: _position,
              decoration: InputDecoration(
                labelText: LocaleKeys.staff_position.trnsltd,
                prefixIcon: const Icon(HugeIcons.strokeRoundedBriefcase01),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [
                for (final p in StaffPosition.values)
                  DropdownMenuItem(value: p, child: Text(p.label)),
              ],
              onChanged: (v) => setState(() => _position = v ?? _position),
            ),
            const SizedBox(height: 22),
            _title(context, HugeIcons.strokeRoundedShield01, LocaleKeys.staff_section_permissions.trnsltd),
            const SizedBox(height: 4),
            Text(
              LocaleKeys.staff_permissions_hint.trnsltd,
              style: textTheme.bodySmall?.copyWith(color: muted),
            ),
            const SizedBox(height: 10),
            StaffPermissionsPicker(
              selected: _permissions,
              onChanged: (v) => setState(() => _permissions = v),
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_error!, style: TextStyle(color: colorScheme.error)),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
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
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
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
      message: _isEdit ? LocaleKeys.staff_saved.trnsltd : LocaleKeys.staff_created.trnsltd,
    );
  }
}
