import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/model/profile_model.dart';
import 'package:dentist_booking_admin/core/routes/app_route.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/enum.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../blocs/cubit/patient_cubit.dart';

class PatientFormDialog extends StatefulWidget {
  const PatientFormDialog({
    super.key,
    required this.patient,
  });

  final ProfileModel patient;

  @override
  State<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends State<PatientFormDialog> {
  String? _status;

  @override
  void initState() {
    super.initState();
    final s = widget.patient;

    _status = s.status ?? "active";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitleHeader(
              title: LocaleKeys.edit_patient_form_title.trnsltd,
              subtitle: LocaleKeys.edit_patient_form_subtitle.tr(
                namedArgs: {
                  'name':
                      widget.patient.meta['raw_user_meta_data']['full_name'] ??
                      "-",
                },
              ),
            ),

            CustomDropdown<String>(
              value: _status,
              enableSearch: false,
              hintText: LocaleKeys.patient_status.trnsltd,
              items: _getPatientStatus(AccountStatus.values),
              onChanged: (v) => setState(() => _status = v),
            ),

            const SizedBox(height: 30),

            FooterDialog(
              title: LocaleKeys.save_button.trnsltd,
              onConfirm: () => _onConfirm(),
            ),
          ],
        ),
      ),
    );
  }

  _getPatientStatus(List<AccountStatus> status) {
    return status.map((status) {
      return DropdownMenuItem(
        value: status.code,
        child: Text(status.name),
      );
    }).toList();
  }

  _onConfirm() {
    context.read<PatientCubit>().updatePatient(
      widget.patient.copyWith(
        status: _status,
      ),
    );
    context.pop();
  }
}
