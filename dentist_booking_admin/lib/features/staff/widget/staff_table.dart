import 'package:data_table_2/data_table_2.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/staff_model.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_badg.dart';
import '../../../core/widgets/custom_icon_tabel_cell.dart';
import '../blocs/staff/staff_cubit.dart';
import 'staff_change_password_form_dialog.dart'
    show StaffChangePasswordFormDialog;
import 'staff_form_dialog.dart';

class StaffTable extends StatelessWidget {
  final List<StaffModel> staffList;

  const StaffTable({super.key, required this.staffList});

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
              label: Center(child: Text(LocaleKeys.staff_full_name.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.staff_email.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.staff_phone.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.staff_position.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.staff_shift_type.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.staff_status.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.staff_created_at.trnsltd)),
            ),
            DataColumn(
              label: Center(child: Text(LocaleKeys.staff_updated_at.trnsltd)),
            ),
            const DataColumn(label: Center(child: Text(""))),
          ],

          rows: List.generate(staffList.length, (i) {
            final staff = staffList[i];

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
                _cell(staff.fullName),
                _cell(staff.email),
                _cell(staff.phone ?? "-"),

                /// Position Badge
                DataCell(
                  CustomBadg(
                    label: staff.position.name,
                    bgcolor: colorScheme.primary.withOpacity(.15),
                    textColor: colorScheme.primary,
                  ),
                ),

                /// Shift Badge
                DataCell(
                  CustomBadg(
                    label: staff.shiftType.name,
                    bgcolor: colorScheme.secondary.withOpacity(.15),
                    textColor: colorScheme.secondary,
                  ),
                ),

                /// Status Badge
                DataCell(
                  _statusBadge(
                    staff.status,
                  ),
                ),

                _cell(
                  DateFormat('yyyy-MM-dd HH:mm').format(staff.createdAt),
                ),
                _cell(
                  DateFormat('yyyy-MM-dd HH:mm').format(staff.updatedAt),
                ),

                /// Edit / Delete buttons
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
                                  value: context.read<StaffCubit>(),
                                  child: StaffFormDialog(
                                    staff: staff,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 3),
                          CustomIconTabelCell(
                            icon: HugeIcons.strokeRoundedDelete01,
                            color: colorScheme.error,
                            onTap: () => _onDeletedStaff(context, staff),
                          ),
                          SizedBox(width: 3),
                          CustomIconTabelCell(
                            icon: HugeIcons.strokeRoundedLock,
                            color: colorScheme.secondary,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<StaffCubit>(),
                                  child: StaffChangePasswordFormDialog(
                                    staff: staff,
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

  _onDeletedStaff(BuildContext context, StaffModel staff) {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.staff_delete_title.trnsltd,
      content: LocaleKeys.staff_delete_confirm.trnsltd,
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.delete_button.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        context.read<StaffCubit>().deleteStaff(staff.id);
        Navigator.of(context).pop();
      },
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

  Widget _statusBadge(AccountStatus status) {
    late Color bgcolor;
    late Color txtcolor;

    switch (status) {
      case AccountStatus.active:
        bgcolor = Colors.green.withOpacity(.18);
        txtcolor = Colors.green;
        break;
      case AccountStatus.vacation:
        bgcolor = Colors.blue.withOpacity(.18);
        txtcolor = Colors.blue;
        break;
      case AccountStatus.suspended:
        bgcolor = Colors.orange.withOpacity(.18);
        txtcolor = Colors.orange;
        break;

      case AccountStatus.inactive:
        bgcolor = Colors.grey.withOpacity(.18);
        txtcolor = Colors.grey;
        break;

      case AccountStatus.appMaintenance:
        bgcolor = Colors.yellow.withOpacity(.18);
        txtcolor = Colors.yellow;
        break;

      case AccountStatus.paused:
        bgcolor = Colors.purple.withOpacity(.18);
        txtcolor = Colors.purple;
        break;

      case AccountStatus.banned:
        bgcolor = Colors.red.withOpacity(.18);
        txtcolor = Colors.red;
        break;

      case AccountStatus.resigned:
      case AccountStatus.terminated:
        bgcolor = Colors.red.withOpacity(.18);
        txtcolor = Colors.red;
        break;
    }

    return Center(
      child: CustomBadg(
        label: status.name,
        bgcolor: bgcolor,
        textColor: txtcolor,
      ),
    );
  }
}
