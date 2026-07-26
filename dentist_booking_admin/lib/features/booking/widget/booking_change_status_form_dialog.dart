import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/model/booking_model.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/enum.dart';
import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../blocs/booking/booking_cubit.dart' show BookingCubit;
import 'booking_cancel_reason_field.dart';

class BookingChangeStatusFormDialog extends StatefulWidget {
  const BookingChangeStatusFormDialog({
    super.key,
    required this.booking,
    // required this.onConfirm,
  });

  final BookingModel booking;
  // final Function(BookingModel updateStatus) onConfirm;

  @override
  State<BookingChangeStatusFormDialog> createState() =>
      _BookingChangeStatusFormDialogState();
}

class _BookingChangeStatusFormDialogState
    extends State<BookingChangeStatusFormDialog> {
  BookingStatus? _status;
  late TextEditingController cancelReasonCtrl;

  bool isCancelled = false;

  @override
  void initState() {
    final s = widget.booking;

    _status = s.bookingStatus;
    cancelReasonCtrl = TextEditingController(text: s.cancelReason);

    if (_status == BookingStatus.cancelledByPatient ||
        _status == BookingStatus.cancelledByStaff) {
      isCancelled = true;
    }

    super.initState();
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
              title: LocaleKeys.change_status_patient_form_title.trnsltd,
              subtitle: LocaleKeys.change_status_patient_form_subtitle.tr(
                namedArgs: {
                  'name': widget.booking.patientName ?? "-",
                },
              ),
            ),

            SizedBox(height: 20),

            CustomDropdown<BookingStatus>(
              value: _status,
              enableSearch: false,

              hintText: LocaleKeys.patient_status.trnsltd,
              items: _getBookingStatus(BookingStatus.values),
              onChanged: (v) => _onChange(v),
            ),

            const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isCancelled
                  ? BookingCancelReasonField(
                      controller: cancelReasonCtrl,
                    )
                  : SizedBox.shrink(),
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

  _onChange(BookingStatus? value) {
    setState(() {
      _status = value;
      isCancelled =
          value == BookingStatus.cancelledByPatient ||
          value == BookingStatus.cancelledByStaff;
    });
  }

  _getBookingStatus(List<BookingStatus> status) {
    return status.map((status) {
      return DropdownMenuItem(
        value: status,
        child: Text(status.name),
      );
    }).toList();
  }

  _onConfirm() {
    if (isCancelled && cancelReasonCtrl.text.trim().isEmpty) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.required_field.trnsltd,
      );
      return;
    }

    // widget.onConfirm(
    //   widget.booking.copyWith(
    //     bookingStatus: _status!,

    //     cancelledAt: isCancelled ? DateTime.now() : null,
    //     cancelledBy: isCancelled ? "SESSION_USER_ID" : null,
    //     cancelReason: isCancelled ? cancelReasonCtrl.text.trim() : null,
    //     updatedAt: DateTime.now(),
    //   ),
    // );

    context.read<BookingCubit>().updateBooking(
      widget.booking.copyWith(
        bookingStatus: _status!,
        cancelledBy: isCancelled ? "SESSION_USER_ID" : null,
        cancelReason: isCancelled ? cancelReasonCtrl.text.trim() : null,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
