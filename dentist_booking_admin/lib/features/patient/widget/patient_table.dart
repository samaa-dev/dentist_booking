import 'package:data_table_2/data_table_2.dart';
import 'package:dentist_booking_admin/core/enum/enum.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/patient/widget/patient_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../core/model/profile_model.dart';
import '../../../core/widgets/custom_badg.dart';
import '../../../core/widgets/custom_icon_tabel_cell.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/cubit/patient_cubit.dart';

class PatientTable extends StatelessWidget {
  const PatientTable({
    super.key,
    required this.patientList,
  });

  final List<ProfileModel> patientList;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      shadowColor: colorScheme.primary.withOpacity(.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable2(
          columnSpacing: 14,
          horizontalMargin: 12,
          minWidth: 900,

          headingRowHeight: 52,
          dataRowHeight: 58,

          headingRowColor: MaterialStateProperty.all(
            colorScheme.primary.withOpacity(.07),
          ),

          headingTextStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),

          dataTextStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(.85),
          ),

          border: TableBorder(
            horizontalInside: BorderSide(
              color: colorScheme.outline.withOpacity(.12),
            ),
          ),

          columns: [
            DataColumn(
              label: Center(child: Text(LocaleKeys.patient_full_name.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.patient_email.trnsltd)),
            ),

            DataColumn(
              label: Center(child: Text(LocaleKeys.patient_role.trnsltd)),
            ),

            DataColumn(
              label: Center(child: Text(LocaleKeys.patient_status.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.patient_created_at.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.patient_updated_at.trnsltd)),
            ),

            DataColumn(
              label: Center(
                child: Text(LocaleKeys.patient_last_seen_at.trnsltd),
              ),
            ),

            const DataColumn(label: Center(child: Text(""))),
          ],

          rows: List.generate(patientList.length, (i) {
            final patient = patientList[i];

            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                (states) {
                  if (states.contains(MaterialState.hovered)) {
                    return colorScheme.primary.withOpacity(.06);
                  }
                  return i % 2 == 0
                      ? colorScheme.primary.withOpacity(.02)
                      : Colors.transparent;
                },
              ),
              cells: [
                _cell(patient.meta['raw_user_meta_data']['full_name'] ?? "-"),
                _cell(patient.meta['raw_user_meta_data']['email'] ?? "-"),

                DataCell(
                  CustomBadg(
                    label: patient.role.toUserStringRole(),
                    bgcolor: colorScheme.primary.withOpacity(.15),
                    textColor: colorScheme.primary,
                  ),
                ),

                DataCell(
                  CustomBadg(
                    label: patient.status.toAccountStringStatus(),
                    bgcolor: patient.status.tobgColorsStatus(),
                    textColor: patient.status.totxtColorsStatus(),
                  ),
                ),

                _cell(
                  DateFormat('yyyy-MM-dd HH:mm').format(patient.createdAt!),
                ),
                _cell(
                  DateFormat('yyyy-MM-dd HH:mm').format((patient.updatedAt!)),
                ),

                _cell(
                  DateFormat('yyyy-MM-dd HH:mm').format(patient.lastSeen!),
                ),

                DataCell(
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomIconTabelCell(
                            icon: HugeIcons.strokeRoundedEdit03,
                            color: colorScheme.primary,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<PatientCubit>(),
                                  child: PatientFormDialog(
                                    patient: patient,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  DataCell _cell(String text) {
    return DataCell(
      Center(
        child: Text(
          text,
          style: TextStyle().copyWith(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
