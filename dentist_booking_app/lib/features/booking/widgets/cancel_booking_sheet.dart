import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/util/info_snackbar.dart';
import 'package:dentist_booking_app/core/widgets/section_heading.dart';
import 'package:dentist_booking_app/features/booking/repo/booking_repo.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/app_setup.dart';

/// Reusable bottom sheet for selecting a cancel reason and confirming booking cancellation.
/// Calls [BookingRepo.cancelBooking] and [onSuccess] on success; shows error snackbar on failure.
void showCancelBookingReasonSheet(
  BuildContext context, {
  required String bookingId,
  required VoidCallback onSuccess,
}) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  final reasons = [
    LocaleKeys.reason_change_appointment.trnsltd,
    LocaleKeys.reason_feel_better.trnsltd,
    LocaleKeys.reason_mistake_booking.trnsltd,
    LocaleKeys.reason_other.trnsltd,
  ];

  String? selectedReason;
  final TextEditingController otherController = TextEditingController();

  SnackbarMes.showCustomBottomSheet(
    context: context,
    child: StatefulBuilder(
      builder: (context, setState) {
        final isOtherSelected = selectedReason == LocaleKeys.reason_other.trnsltd;

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitleHeading(
                    title: LocaleKeys.booking_cancel_reason_title.trnsltd,
                    description: LocaleKeys.booking_cancel_reason_description.trnsltd,
                  ),
                  const SizedBox(height: 20),
                  ...reasons.map(
                    (reason) => RadioListTile<String>(
                      title: Text(
                        reason,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() => selectedReason = value);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isOtherSelected)
                    TextField(
                      controller: otherController,
                      maxLines: 2,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.reason_enter_details.trnsltd,
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      elevation: 0,
                      foregroundColor:
                          (selectedReason == null || (isOtherSelected && otherController.text.trim().isEmpty))
                          ? colorScheme.onSurface.withOpacity(0.2)
                          : colorScheme.onPrimary,
                      backgroundColor:
                          (selectedReason == null || (isOtherSelected && otherController.text.trim().isEmpty))
                          ? colorScheme.primary.withOpacity(0.4)
                          : colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: selectedReason == null
                        ? null
                        : () async {
                            final reasonToSend = isOtherSelected ? otherController.text.trim() : selectedReason ?? "";

                            if (reasonToSend.isEmpty) return;

                            Navigator.pop(context);

                            try {
                              await getIt<BookingRepo>().cancelBooking(
                                bookingId: bookingId,
                                reason: reasonToSend,
                              );
                              onSuccess();
                              if (context.mounted) {
                                SnackbarMes.showToastMsg(
                                  context,
                                  message: LocaleKeys.booking_cancel_success.trnsltd,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                SnackbarMes.showToastMsg(
                                  context,
                                  message: e is Exception
                                      ? e.toString().replaceFirst('Exception: ', '')
                                      : LocaleKeys.booking_cannot_cancel.trnsltd,
                                );
                              }
                            }
                          },
                    child: Text(
                      LocaleKeys.booking_cancel_confirm_btn.trnsltd,
                      style: const TextStyle().copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      },
    ),
  );
}
