import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/extensions/os_extensions.dart';
import '../../../core/model/staff_member.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff_cubit.dart';

class StaffPasswordDialog extends StatefulWidget {
  const StaffPasswordDialog({super.key, required this.member});

  final StaffMember member;

  static Future<void> show(BuildContext context, StaffMember member) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<StaffCubit>(),
        child: StaffPasswordDialog(member: member),
      ),
    );
  }

  @override
  State<StaffPasswordDialog> createState() => _StaffPasswordDialogState();
}

class _StaffPasswordDialogState extends State<StaffPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DialogTitleHeader(
                  title: LocaleKeys.staff_change_password.trnsltd,
                  subtitle: widget.member.fullName,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscure,
                  hintText: LocaleKeys.staff_new_password.trnsltd,
                  prefixIcon: const Icon(HugeIcons.strokeRoundedLock),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? HugeIcons.strokeRoundedViewOff
                          : HugeIcons.strokeRoundedView,
                    ),
                  ),
                  validator: (v) => (v ?? '').length < 6
                      ? LocaleKeys.staff_err_password_short.trnsltd
                      : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: TextStyle(color: colorScheme.error)),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => Navigator.pop(context),
                        child: Text(LocaleKeys.cancel_button.trnsltd),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _saving ? null : _submit,
                        child: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(LocaleKeys.save_button.trnsltd),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final error = await context.read<StaffCubit>().setPassword(
      widget.member.userId,
      _password.text,
    );
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
      message: LocaleKeys.staff_success_change_password.tr(
        namedArgs: {'name': widget.member.fullName},
      ),
    );
  }
}
