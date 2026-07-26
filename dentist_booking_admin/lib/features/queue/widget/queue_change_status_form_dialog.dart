import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/model/booking_model.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/enum/enum.dart';
import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/dialog_title_header.dart';
import '../../../core/widgets/footer_dialog.dart';
import '../../booking/widget/booking_cancel_reason_field.dart';

class QueueChangeStatusFormDialog extends StatefulWidget {
  const QueueChangeStatusFormDialog({
    super.key,
    required this.booking,
    required this.onConfirm,
  });

  final BookingModel booking;
  final Function(BookingModel updateStatus) onConfirm;

  @override
  State<QueueChangeStatusFormDialog> createState() =>
      _QueueChangeStatusFormDialogState();
}

class _QueueChangeStatusFormDialogState
    extends State<QueueChangeStatusFormDialog> {
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

            const SizedBox(height: 20),

            // استبدال CustomDropdown بـ StatusChip Wrap
            _buildStatusChips(),

            const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isCancelled
                  ? BookingCancelReasonField(
                      controller: cancelReasonCtrl,
                    )
                  : const SizedBox.shrink(),
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

  Widget _buildStatusChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: BookingStatus.values.map((status) {
        return StatusChip(
          status: status,
          selected: _status == status,
          onTap: () => _onStatusChanged(status),
        );
      }).toList(),
    );
  }

  void _onStatusChanged(BookingStatus status) {
    setState(() {
      _status = status;
      isCancelled =
          status == BookingStatus.cancelledByPatient ||
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
        cancelledBy: isCancelled ? "SESSION_USER_ID" : null,
        cancelReason: isCancelled ? cancelReasonCtrl.text.trim() : null,
        updatedAt: DateTime.now(),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final BookingStatus status;
  final bool selected;
  final VoidCallback onTap;

  const StatusChip({
    super.key,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  Color _getStatusColor(BuildContext context, BookingStatus status) {
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
    final statusColor = _getStatusColor(context, status);

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
              : colorScheme.surfaceVariant.withOpacity(0.3),
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
