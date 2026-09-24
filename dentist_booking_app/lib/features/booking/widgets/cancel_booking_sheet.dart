import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/util/info_snackbar.dart';
import 'package:dentist_booking_app/features/booking/repo/booking_repo.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/app_setup.dart';

/// Stable cancel reason stored in DB (language-independent).
const kPatientCancelReason = 'patient_cancelled';

/// Confirms booking cancellation, then calls [BookingRepo.cancelBooking]
/// with [kPatientCancelReason]. Invokes [onSuccess] on success.
void showCancelBookingConfirmDialog(
  BuildContext context, {
  required String bookingId,
  required VoidCallback onSuccess,
}) {
  SnackbarMes.showCustomDialog(
    context,
    title: LocaleKeys.booking_cancel_confirm_title.trnsltd,
    content: LocaleKeys.booking_cancel_confirm_message.trnsltd,
    buttonCancelText: LocaleKeys.booking_cancel_go_back.trnsltd,
    buttonConfirmText: LocaleKeys.booking_cancel_confirm_btn.trnsltd,
    onCancel: () => Navigator.of(context).pop(),
    onConfirm: () async {
      Navigator.of(context).pop();

      SnackbarMes.showLoadingDialog(context);

      try {
        await getIt<BookingRepo>().cancelBooking(
          bookingId: bookingId,
          reason: kPatientCancelReason,
        );

        if (context.mounted) {
          Navigator.of(context).pop(); // close loading
          SnackbarMes.showToastMsg(
            context,
            message: LocaleKeys.booking_cancel_success.trnsltd,
          );
        }
        onSuccess();
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // close loading
          SnackbarMes.showToastMsg(
            context,
            message: e is Exception
                ? e.toString().replaceFirst('Exception: ', '')
                : LocaleKeys.booking_cannot_cancel.trnsltd,
          );
        }
      }
    },
  );
}
