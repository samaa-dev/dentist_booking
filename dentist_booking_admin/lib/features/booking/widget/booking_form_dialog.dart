import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/model/booking_model.dart';
import 'package:dentist_booking_admin/features/booking/blocs/booking/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/profile_model.dart';
import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../../../generated/locale_keys.g.dart';
import 'booking_left_column.dart';
import 'booking_right_column.dart';

class BookingFormDialog extends StatefulWidget {
  final BookingModel? booking;

  const BookingFormDialog({super.key, this.booking});

  @override
  State<BookingFormDialog> createState() => _BookingFormDialogState();
}

class _BookingFormDialogState extends State<BookingFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // State
  String? _patientType;
  String? _shift;
  String? _status;
  DateTime? _selectedDateTime;
  ProfileModel? selectedPatient;
  bool _isEditing = false;

  // Controllers
  late TextEditingController fullNameCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController cancelReasonCtrl;

  @override
  void initState() {
    super.initState();
    final b = widget.booking;

    _patientType = b?.patientType.name ?? LocaleKeys.type_guest.trnsltd;
    _shift = b?.shift.name ?? LocaleKeys.shift_morning.trnsltd;
    _status = b?.bookingStatus.name ?? LocaleKeys.status_confirmed.trnsltd;
    _selectedDateTime = b?.bookingDate ?? DateTime.now();
    selectedPatient = b?.patientId != null
        ? ProfileModel(
            userId: b!.patientId!,
            meta: {
              "raw_user_meta_data": {
                "full_name": b.patientName,
                "phone": (b.patientPhone == null || b.patientPhone!.isEmpty)
                    ? ''
                    : b.patientPhone,
                "address":
                    (b.patientAddress == null || b.patientAddress!.isEmpty)
                    ? ''
                    : b.patientAddress,
              },
            },
            role: '',
            status: '',
            createdAt: null,
            updatedAt: null,
            lastSeen: null,
          )
        : null;

    _isEditing = b?.patientId != null ? false : true;

    fullNameCtrl = TextEditingController(text: b?.patientName ?? "");
    addressCtrl = TextEditingController(text: b?.patientAddress ?? "");
    phoneCtrl = TextEditingController(text: b?.patientPhone ?? "");
    cancelReasonCtrl = TextEditingController(text: b?.cancelReason ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleHeader(
                title: widget.booking == null
                    ? LocaleKeys.booking_add.trnsltd
                    : LocaleKeys.booking_edit.trnsltd,
                subtitle: LocaleKeys.booking_form_subtitle.trnsltd,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT COLUMN
                  Flexible(
                    child: BookingLeftColumn(
                      selectedDateTime: _selectedDateTime,

                      patientType: _patientType,
                      shift: _shift,
                      status: _status,
                      onDateChangedTime: (d) {
                        setState(
                          () {
                            debugPrint("Date changed: $d");
                            _selectedDateTime = d;
                          },
                        );
                      },
                      onTypeChanged: (v) => setState(() => _patientType = v),
                      onShiftChanged: (v) => setState(() => _shift = v),
                      onStatusChanged: (v) => setState(() => _status = v),
                      // onTimeChanged: (t) => setState(),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// RIGHT COLUMN
                  Flexible(
                    flex: 2,
                    child: BookingRightColumn(
                      isGuest: _patientType == LocaleKeys.type_guest.trnsltd,
                      status: _status,
                      fullNameCtrl: fullNameCtrl,
                      addressCtrl: addressCtrl,
                      phoneCtrl: phoneCtrl,
                      cancelReasonCtrl: cancelReasonCtrl,
                      onSelectPatient: (patient) => _onSelectPatient(patient),
                      onResetPatient: () => _onResetPatient(),
                      selectedPatient: selectedPatient,
                      isEditable: _isEditing,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              FooterDialog(
                title: widget.booking == null
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

  // TimeOfDay _parseTimeOfDay(String time) {
  //   final parts = time.split(':');
  //   return TimeOfDay(
  //     hour: int.parse(parts[0]),
  //     minute: int.parse(parts[1]),
  //   );
  // }

  _onResetPatient() {
    setState(() {
      selectedPatient = null;
      fullNameCtrl.clear();
      phoneCtrl.clear();
      addressCtrl.clear();
    });
  }

  _onSelectPatient(ProfileModel patient) {
    setState(() {
      selectedPatient = patient;

      final meta = patient.meta["raw_user_meta_data"] ?? {};
      fullNameCtrl.text = meta["full_name"] ?? meta["name"] ?? "";
      phoneCtrl.text = meta["phone"] ?? "";
      addressCtrl.text = meta["address"] ?? "";
    });
  }

  void _onConfirm(BuildContext context) {
    final bookingCubit = context.read<BookingCubit>();
    final isGuest = _patientType == LocaleKeys.type_guest.trnsltd;
    final shiftEnum = _shift.toBookingShiftEnum(); // ENUM
    final statusEnum = _status.toBookingStatusEnum(); // ENUM

    debugPrint("isGuest: $isGuest, shift: $shiftEnum, status: $statusEnum");

    final now = DateTime.now();

    if (_selectedDateTime == null) {
      _showError(context, LocaleKeys.error_select_date.trnsltd);
      return;
    }

    if (isGuest) {
      if (fullNameCtrl.text.trim().isEmpty) {
        _showError(context, LocaleKeys.error_guest_fullname_required.trnsltd);
        return;
      }
      // if (phoneCtrl.text.trim().isEmpty) {
      //   _showError(context, LocaleKeys.error_guest_phone_required.trnsltd);
      //   return;
      // }
      // if (addressCtrl.text.trim().isEmpty) {
      //   _showError(context, LocaleKeys.error_guest_address_required.trnsltd);
      //   return;
      // }
    } else {
      if (selectedPatient == null) {
        _showError(context, LocaleKeys.error_registered_select_patient.trnsltd);
        return;
      }
    }

    final bool isCancelled =
        statusEnum == BookingStatus.cancelledByPatient ||
        statusEnum == BookingStatus.cancelledByStaff;

    if (isCancelled && cancelReasonCtrl.text.trim().isEmpty) {
      _showError(context, LocaleKeys.error_cancel_reason_required.trnsltd);
      return;
    }

    final bookingDate = DateTime(
      _selectedDateTime!.year,
      _selectedDateTime!.month,
      _selectedDateTime!.day,
      _selectedDateTime!.hour,
      _selectedDateTime!.minute,
      0,
      0,
      0,
    );

    debugPrint("Booking date: $bookingDate");

    // // final bookingTime =
    // //     "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00";

    final model = BookingModel(
      id: widget.booking?.id ?? "",
      bookingDate: bookingDate,

      patientId: isGuest ? null : selectedPatient?.userId,
      patientType: isGuest ? PatientType.guest : PatientType.registered,

      patientName: fullNameCtrl.text.trim(),
      patientPhone: phoneCtrl.text.trim(),
      patientAddress: addressCtrl.text.trim(),

      shift: shiftEnum,
      bookingStatus: statusEnum,

      createdAt: widget.booking?.createdAt ?? now,
      updatedAt: now,

      cancelledAt: isCancelled ? now : null,
      cancelReason: isCancelled ? cancelReasonCtrl.text.trim() : null,
      cancelledBy: isCancelled ? "SESSION_USER_ID" : null,

      completedAt: statusEnum == BookingStatus.completed ? now : null,
    );

    if (widget.booking == null) {
      bookingCubit.createBooking(model);
    } else {
      bookingCubit.updateBooking(model);
    }
  }

  void _showError(BuildContext context, String message) {
    SnackbarMes.showToastMsg(context, message: message);
  }
}
