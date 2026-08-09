import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/model/booking_model.dart';
import 'package:dentist_booking_admin_app/core/util/info_snackbar.dart';
import 'package:dentist_booking_admin_app/core/widgets/custom_text_form_field.dart';
import 'package:dentist_booking_admin_app/core/widgets/dialog_title_header.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/enum/enum.dart';

class QueueChangeStatusSheet extends StatefulWidget {
  const QueueChangeStatusSheet({
    super.key,
    required this.booking,
    required this.onConfirm,
  });

  final BookingModel booking;
  final void Function(BookingModel updateStatus) onConfirm;

  static void show(
    BuildContext context, {
    required BookingModel booking,
    required void Function(BookingModel updateStatus) onConfirm,
  }) {
    SnackbarMes.showCustomBottomSheet(
      context: context,
      isExpanded: true,
      child: QueueChangeStatusSheet(
        booking: booking,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<QueueChangeStatusSheet> createState() => _QueueChangeStatusSheetState();
}

class _QueueChangeStatusSheetState extends State<QueueChangeStatusSheet> {
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
  void dispose() {
    cancelReasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    final bottomPad = 16 + bottomInset + (bottomSafe > 12 ? bottomSafe : 12);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitleHeader(
              title: LocaleKeys.change_status_patient_form_title.trnsltd,
              subtitle: LocaleKeys.change_status_patient_form_subtitle.tr(
                namedArgs: {
                  'name': widget.booking.patientName ?? '-',
                },
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BookingStatus.values.map((status) {
                        return _StatusChip(
                          status: status,
                          selected: _status == status,
                          onTap: () => _onStatusChanged(status),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: isCancelled
                          ? Container(
                              key: const ValueKey('cancel_reason'),
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withOpacity(0.5),
                                border: Border.all(
                                  color: colorScheme.onSurface.withOpacity(0.3),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: CustomTextFormField(
                                controller: cancelReasonCtrl,
                                maxLines: 2,
                                hintText: LocaleKeys.booking_cancel_reason.trnsltd,
                                prefixIcon: const Icon(
                                  HugeIcons.strokeRoundedMessageCancel02,
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('no_reason')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onConfirm,
                child: Text(LocaleKeys.save_button.trnsltd),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onStatusChanged(BookingStatus status) {
    setState(() {
      _status = status;
      isCancelled = status == BookingStatus.cancelledByPatient ||
          status == BookingStatus.cancelledByStaff;
    });
  }

  void _onConfirm() {
    if (isCancelled && cancelReasonCtrl.text.trim().isEmpty) {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.required_field.trnsltd,
      );
      return;
    }

    widget.onConfirm(
      widget.booking.copyWith(
        bookingStatus: _status!,
        cancelledAt: isCancelled ? DateTime.now() : null,
        cancelledBy: isCancelled ? 'SESSION_USER_ID' : null,
        cancelReason: isCancelled ? cancelReasonCtrl.text.trim() : null,
        updatedAt: DateTime.now(),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.cancelledByPatient:
      case BookingStatus.cancelledByStaff:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.noShow:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? statusColor
              : colorScheme.surfaceContainerHighest.withOpacity(0.3),
          border: Border.all(
            color: selected
                ? statusColor
                : colorScheme.outline.withOpacity(0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          status.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
