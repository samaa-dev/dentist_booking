import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/widgets/custom_dropdown.dart';
import 'package:dentist_booking_admin/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/staff_model.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff/staff_cubit.dart';
import 'chosse_dropdown_profile.dart' show ChosseDropdownProfile;

class StaffFormDialog extends StatefulWidget {
  final StaffModel? staff;

  const StaffFormDialog({super.key, this.staff});

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late StaffCubit _staffCubit;

  late TextEditingController _fullName;
  late TextEditingController _email;
  late TextEditingController _phone;

  String? _position;
  String? _shift;
  String? _status;
  String? _selectedProfileUserId;

  @override
  void initState() {
    super.initState();
    final s = widget.staff;
    _staffCubit = BlocProvider.of<StaffCubit>(context);

    _fullName = TextEditingController(text: s?.fullName ?? "");
    _email = TextEditingController(text: s?.email ?? "");
    _phone = TextEditingController(text: s?.phone ?? "");

    _position = s?.position.code ?? "nurse";
    _shift = s?.shiftType.code ?? "morning";
    _status = s?.status.code ?? "active";

    _getAllProfils();
  }

  _getAllProfils() {
    if (widget.staff == null) {
      _staffCubit.getAllProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DialogTitleHeader(
                title: widget.staff == null
                    ? LocaleKeys.add_staff.trnsltd
                    : LocaleKeys.edit_staff.trnsltd,
                subtitle: LocaleKeys.staff_form_subtitle.trnsltd,
              ),

              if (widget.staff == null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ChosseDropdownProfile(
                    value: _selectedProfileUserId,
                    onChanged: (value) {
                      setState(() {
                        _selectedProfileUserId = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
              ],
              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  // ======================
                  // TEXT FIELDS → LEFT
                  // ======================
                  SizedBox(
                    width: 250,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildTextField(
                        context,
                        controller: _fullName,
                        keyboardType: TextInputType.text,
                        hintText: LocaleKeys.staff_full_name.trnsltd,
                        prefixIcon: HugeIcons.strokeRoundedUser,
                        validator: true,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 250,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildTextField(
                        context,
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        hintText: LocaleKeys.staff_email.trnsltd,
                        prefixIcon: HugeIcons.strokeRoundedMail01,
                        validator: true,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 250,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildTextField(
                        context,
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        hintText: LocaleKeys.staff_phone.trnsltd,
                        prefixIcon: HugeIcons.strokeRoundedSmartPhone01,
                        validator: false,
                      ),
                    ),
                  ),

                  // ======================
                  // DROPDOWNS → RIGHT
                  // ======================
                  SizedBox(
                    width: 250,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomDropdown<String>(
                        value: _position,
                        enableSearch: false,
                        hintText: LocaleKeys.staff_position.trnsltd,
                        items: _getStaffPosition(StaffPosition.values),
                        onChanged: (v) => setState(() => _position = v),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 250,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomDropdown<String>(
                        value: _shift,
                        enableSearch: false,
                        hintText: LocaleKeys.staff_shift_type.trnsltd,
                        items: _getShiftType(ShiftType.values),
                        onChanged: (v) => setState(() => _shift = v),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 250,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomDropdown<String>(
                        value: _status,
                        enableSearch: false,
                        hintText: LocaleKeys.staff_status.trnsltd,
                        items: _getStaffStatus(AccountStatus.values),
                        onChanged: (v) {
                          debugPrint(v);
                          setState(() => _status = v);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              FooterDialog(
                title: widget.staff == null
                    ? LocaleKeys.add_button.trnsltd
                    : LocaleKeys.save_button.trnsltd,
                onConfirm: () => _onConfirm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hintText,
    required IconData prefixIcon,
    bool validator = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 250,
      child: CustomTextFormField(
        controller: controller,
        keyboardType: keyboardType,
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: colorScheme.onSurface,
        ),
        validator: validator
            ? (v) => (v == null || v.isEmpty)
                  ? LocaleKeys.required_field.trnsltd
                  : null
            : null,
      ),
    );
  }

  _getStaffPosition(List<StaffPosition> position) {
    return position.map((position) {
      return DropdownMenuItem(
        value: position.code,
        child: Text(position.name),
      );
    }).toList();
  }

  _getShiftType(List<ShiftType> shift) {
    return shift.map((shift) {
      return DropdownMenuItem(
        value: shift.code,
        child: Text(shift.name),
      );
    }).toList();
  }

  _getStaffStatus(List<AccountStatus> status) {
    return status.map((status) {
      return DropdownMenuItem(
        value: status.code,
        child: Text(status.name),
      );
    }).toList();
  }

  void _onConfirm(BuildContext context) {
    final staffCubit = context.read<StaffCubit>();

    if (!_formKey.currentState!.validate()) return;

    // تأكد من اختيار User عند إنشاء موظف جديد
    if (widget.staff == null && _selectedProfileUserId == null) {
      // CustomToast.error(LocaleKeys.User_required.trnsltd);
      return;
    }

    final positionEnum = StaffPosition.values.firstWhere(
      (e) => e.code == _position,
    );
    final shiftEnum = ShiftType.values.firstWhere((e) => e.code == _shift);

    final statusEnum = AccountStatus.values.firstWhere(
      (e) => e.code == _status,
    );

    debugPrint(statusEnum.name);

    final userId = widget.staff == null
        ? _selectedProfileUserId!
        : widget.staff!.userId;

    final model = StaffModel(
      id: widget.staff?.id ?? "",
      userId: userId,
      fullName: _fullName.text,
      email: _email.text,
      phone: _phone.text,
      position: positionEnum,
      shiftType: shiftEnum,
      status: statusEnum,
      createdAt: widget.staff?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.staff == null
        ? staffCubit.createStaff(model)
        : staffCubit.updateStaff(model);

    Navigator.pop(context);
  }
}
