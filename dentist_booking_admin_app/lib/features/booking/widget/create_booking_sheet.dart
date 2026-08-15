import 'package:dentist_booking_admin_app/core/enum/enum.dart';
import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/model/booking_model.dart';
import 'package:dentist_booking_admin_app/core/model/profile_model.dart';
import 'package:dentist_booking_admin_app/core/util/info_snackbar.dart';
import 'package:dentist_booking_admin_app/core/widgets/custom_text_form_field.dart';
import 'package:dentist_booking_admin_app/core/widgets/dialog_title_header.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../blocs/booking/booking_cubit.dart';
import 'select_patient_sheet.dart';

class CreateBookingSheet extends StatefulWidget {
  const CreateBookingSheet({super.key, this.booking});

  final BookingModel? booking;

  static void show(BuildContext context, {BookingModel? booking}) {
    final cubit = context.read<BookingCubit>();
    SnackbarMes.showCustomBottomSheet(
      context: context,
      isExpanded: true,
      child: BlocProvider.value(
        value: cubit,
        child: CreateBookingSheet(booking: booking),
      ),
    );
  }

  @override
  State<CreateBookingSheet> createState() => _CreateBookingSheetState();
}

class _CreateBookingSheetState extends State<CreateBookingSheet> {
  late PatientType _patientType;
  late BookingShift _shift;
  late BookingStatus _status;
  DateTime? _selectedDateTime;
  ProfileModel? _selectedPatient;

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _cancelReasonCtrl;

  bool get _isEdit => widget.booking != null;

  @override
  void initState() {
    super.initState();
    final b = widget.booking;

    _patientType = b?.patientType ?? PatientType.guest;
    _shift = b?.shift ?? BookingShift.morning;
    _status = b?.bookingStatus ?? BookingStatus.confirmed;
    _selectedDateTime = b?.bookingDate ?? DateTime.now();

    if (b?.patientId != null) {
      _selectedPatient = ProfileModel(
        userId: b!.patientId!,
        meta: {
          'raw_user_meta_data': {
            'full_name': b.patientName,
            'phone': b.patientPhone ?? '',
            'address': b.patientAddress ?? '',
          },
        },
        role: '',
        status: '',
        createdAt: null,
        updatedAt: null,
        lastSeen: null,
      );
    }

    _fullNameCtrl = TextEditingController(text: b?.patientName ?? '');
    _addressCtrl = TextEditingController(text: b?.patientAddress ?? '');
    _phoneCtrl = TextEditingController(text: b?.patientPhone ?? '');
    _cancelReasonCtrl = TextEditingController(text: b?.cancelReason ?? '');
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _cancelReasonCtrl.dispose();
    super.dispose();
  }

  bool get _isCancelled =>
      _status == BookingStatus.cancelledByPatient ||
      _status == BookingStatus.cancelledByStaff;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitleHeader(
              title: _isEdit
                  ? LocaleKeys.booking_edit.trnsltd
                  : LocaleKeys.booking_add.trnsltd,
              subtitle: LocaleKeys.booking_form_subtitle.trnsltd,
            ),
            const SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(label: LocaleKeys.booking_date.trnsltd),
                    const SizedBox(height: 8),
                    _DateTimePickerRow(
                      selectedDateTime: _selectedDateTime,
                      onChanged: (dt) => setState(() => _selectedDateTime = dt),
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(label: LocaleKeys.booking_type.trnsltd),
                    const SizedBox(height: 8),
                    SegmentedButton<PatientType>(
                      segments: [
                        ButtonSegment(
                          value: PatientType.guest,
                          label: Text(PatientType.guest.name),
                          icon: const Icon(HugeIcons.strokeRoundedUser),
                        ),
                        ButtonSegment(
                          value: PatientType.registered,
                          label: Text(PatientType.registered.name),
                          icon: const Icon(HugeIcons.strokeRoundedUserCheck01),
                        ),
                      ],
                      selected: {_patientType},
                      onSelectionChanged: (values) {
                        setState(() {
                          _patientType = values.first;
                          if (_patientType == PatientType.guest) {
                            _selectedPatient = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(label: LocaleKeys.booking_shift.trnsltd),
                    const SizedBox(height: 8),
                    SegmentedButton<BookingShift>(
                      segments: [
                        ButtonSegment(
                          value: BookingShift.morning,
                          label: Text(BookingShift.morning.name),
                          icon: const Icon(HugeIcons.strokeRoundedSun03),
                        ),
                        ButtonSegment(
                          value: BookingShift.evening,
                          label: Text(BookingShift.evening.name),
                          icon: const Icon(HugeIcons.strokeRoundedMoon02),
                        ),
                      ],
                      selected: {_shift},
                      onSelectionChanged: (values) {
                        setState(() => _shift = values.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(label: LocaleKeys.booking_status.trnsltd),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<BookingStatus>(
                      value: _status,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest
                            .withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      items: BookingStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _status = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_patientType == PatientType.guest) ...[
                      _SectionLabel(
                        label: LocaleKeys.booking_full_name.trnsltd,
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _fullNameCtrl,
                        hintText: LocaleKeys.booking_full_name.trnsltd,
                        keyboardType: TextInputType.name,
                        prefixIcon:
                            const Icon(HugeIcons.strokeRoundedUser),
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _phoneCtrl,
                        hintText: LocaleKeys.booking_phone.trnsltd,
                        keyboardType: TextInputType.phone,
                        prefixIcon:
                            const Icon(HugeIcons.strokeRoundedCall),
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        controller: _addressCtrl,
                        hintText: LocaleKeys.booking_address.trnsltd,
                        keyboardType: TextInputType.streetAddress,
                        prefixIcon: const Icon(
                          HugeIcons.strokeRoundedLocation01,
                        ),
                      ),
                    ] else ...[
                      _SectionLabel(label: LocaleKeys.booking_patient.trnsltd),
                      const SizedBox(height: 8),
                      if (_selectedPatient == null)
                        OutlinedButton.icon(
                          onPressed: _pickPatient,
                          icon: const Icon(HugeIcons.strokeRoundedUserAdd01),
                          label: Text(
                            LocaleKeys.choose_patient_name.trnsltd,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                        )
                      else
                        _SelectedPatientCard(
                          patient: _selectedPatient!,
                          onChange: _pickPatient,
                          onClear: () {
                            setState(() {
                              _selectedPatient = null;
                              _fullNameCtrl.clear();
                              _phoneCtrl.clear();
                              _addressCtrl.clear();
                            });
                          },
                        ),
                    ],
                    if (_isCancelled) ...[
                      const SizedBox(height: 16),
                      _SectionLabel(
                        label: LocaleKeys.booking_cancel_reason.trnsltd,
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _cancelReasonCtrl,
                        hintText: LocaleKeys.booking_cancel_reason.trnsltd,
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        prefixIcon: const Icon(
                          HugeIcons.strokeRoundedMessageCancel02,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      LocaleKeys.booking_form_subtitle.trnsltd,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onConfirm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  _isEdit
                      ? LocaleKeys.save_button.trnsltd
                      : LocaleKeys.add_button.trnsltd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPatient() async {
    final patient = await SelectPatientSheet.show(context);
    if (patient == null || !mounted) return;

    final meta = patient.meta['raw_user_meta_data'] as Map? ?? {};
    setState(() {
      _selectedPatient = patient;
      _fullNameCtrl.text =
          (meta['full_name'] ?? meta['name'] ?? '').toString();
      _phoneCtrl.text = (meta['phone'] ?? '').toString();
      _addressCtrl.text = (meta['address'] ?? '').toString();
    });
  }

  void _onConfirm() {
    final cubit = context.read<BookingCubit>();
    final now = DateTime.now();

    if (_selectedDateTime == null) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.error_select_date.trnsltd,
      );
      return;
    }

    if (_patientType == PatientType.guest) {
      if (_fullNameCtrl.text.trim().isEmpty) {
        SnackbarMes.showToastMsg(
          context,
          message: LocaleKeys.error_guest_fullname_required.trnsltd,
        );
        return;
      }
    } else if (_selectedPatient == null) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.error_registered_select_patient.trnsltd,
      );
      return;
    } else if (_fullNameCtrl.text.trim().isEmpty) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.error_patient_name_required.trnsltd,
      );
      return;
    }

    if (_isCancelled && _cancelReasonCtrl.text.trim().isEmpty) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.error_cancel_reason_required.trnsltd,
      );
      return;
    }

    final bookingDate = DateTime(
      _selectedDateTime!.year,
      _selectedDateTime!.month,
      _selectedDateTime!.day,
      _selectedDateTime!.hour,
      _selectedDateTime!.minute,
    );

    final model = BookingModel(
      id: widget.booking?.id ?? '',
      bookingDate: bookingDate,
      patientId:
          _patientType == PatientType.guest ? null : _selectedPatient?.userId,
      patientType: _patientType,
      patientName: _fullNameCtrl.text.trim(),
      patientPhone: _phoneCtrl.text.trim(),
      patientAddress: _addressCtrl.text.trim(),
      shift: _shift,
      bookingStatus: _status,
      createdAt: widget.booking?.createdAt ?? now,
      updatedAt: now,
      cancelledAt: _isCancelled ? now : null,
      cancelReason: _isCancelled ? _cancelReasonCtrl.text.trim() : null,
      cancelledBy: _isCancelled ? 'SESSION_USER_ID' : null,
      completedAt: _status == BookingStatus.completed ? now : null,
    );

    if (_isEdit) {
      cubit.updateBooking(model);
    } else {
      cubit.createBooking(model);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      label,
      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _DateTimePickerRow extends StatelessWidget {
  const _DateTimePickerRow({
    required this.selectedDateTime,
    required this.onChanged,
  });

  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dt = selectedDateTime ?? DateTime.now();
    final dateLabel = DateFormat('yyyy-MM-dd').format(dt);
    final timeLabel = DateFormat('HH:mm').format(dt);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickDate(context, dt),
            icon: const Icon(HugeIcons.strokeRoundedCalendar01, size: 18),
            label: Text(dateLabel, style: textTheme.bodyMedium),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickTime(context, dt),
            icon: const Icon(HugeIcons.strokeRoundedClock01, size: 18),
            label: Text(timeLabel, style: textTheme.bodyMedium),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, DateTime current) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    onChanged(
      DateTime(
        picked.year,
        picked.month,
        picked.day,
        current.hour,
        current.minute,
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, DateTime current) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked == null) return;
    onChanged(
      DateTime(
        current.year,
        current.month,
        current.day,
        picked.hour,
        picked.minute,
      ),
    );
  }
}

class _SelectedPatientCard extends StatelessWidget {
  const _SelectedPatientCard({
    required this.patient,
    required this.onChange,
    required this.onClear,
  });

  final ProfileModel patient;
  final VoidCallback onChange;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final meta = patient.meta['raw_user_meta_data'] as Map? ?? {};
    final fullName =
        (meta['full_name'] ?? meta['name'] ?? LocaleKeys.unknown_name.trnsltd)
            .toString();
    final phone =
        (meta['phone'] ?? LocaleKeys.unknown_phone.trnsltd).toString();
    final address = (meta['address'] ?? '—').toString();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.15),
                child: Icon(
                  HugeIcons.strokeRoundedUser02,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      phone,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                    Text(
                      address,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClear,
                icon: const Icon(HugeIcons.strokeRoundedCancel01),
                tooltip: LocaleKeys.cancel_button.trnsltd,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onChange,
            child: Text(LocaleKeys.change_patient.trnsltd),
          ),
        ],
      ),
    );
  }
}
