// ignore_for_file: file_names

import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/model/booking_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/enum/enum.dart';
import '../../../core/util/calendar_date.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_chip.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/booking/booking_cubit.dart';
import 'cancel_booking_sheet.dart';

class BookingItem extends StatelessWidget {
  const BookingItem({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bookingDate = timeago.format(
      booking.bookingDate,
      locale: context.locale.languageCode,
    );

    final completedDate = booking.completedAt != null
        ? CalendarDate.getFormatSingleDate(booking.completedAt!)
        : null;

    final cancelledDate = booking.cancelledAt != null
        ? CalendarDate.getFormatSingleDate(booking.cancelledAt!)
        : null;

    return InkWell(
      onLongPress: () => _onLongPress(context, booking.bookingStatus!),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: colorScheme.primaryContainer.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#${booking.queueNumber?.padLeft(4, '0')}",
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  "$bookingDate  |  ${booking.ticketCode ?? ''}",
                  style: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                CustomChip(
                  text: booking.bookingStatus!.name,
                  bgColor: booking.bookingStatus!.tobgColorsBooking(),
                  txtColor: booking.bookingStatus!.totxtColorsBooking(),
                ),
                const SizedBox(width: 8),
                CustomChip(
                  text: booking.shift.name,
                  bgColor: booking.shift.tobgColorsShiftBooking(),
                  txtColor: booking.shift.totxtColorsShiftBooking(),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (booking.bookingStatus == BookingStatus.cancelledByPatient ||
                booking.bookingStatus == BookingStatus.cancelledByStaff)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.error.withOpacity(0.35),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedCancelCircle,
                          size: 18,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          booking.bookingStatus ==
                                  BookingStatus.cancelledByStaff
                              ? LocaleKeys.booking_cancelled_by_staff.trnsltd
                              : LocaleKeys.booking_cancelled_by_patient.trnsltd,
                          style: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),

                    if (booking.cancelReason != null &&
                        booking.cancelReason!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, right: 24),
                        child: Text(
                          booking.cancelReason!,
                          style: textTheme.bodySmall!.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),

                    if (cancelledDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 24),
                        child: Text(
                          "${LocaleKeys.booking_cancelled_date.trnsltd} $cancelledDate",
                          style: textTheme.labelSmall!.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.55),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            /// 🔹 Completed (New Design)
            if (booking.bookingStatus == BookingStatus.completed &&
                booking.completedAt != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.35),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedCheckmarkCircle02,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          LocaleKeys.booking_completed_success.trnsltd,
                          style: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),

                    if (completedDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, right: 24),
                        child: Text(
                          "${LocaleKeys.booking_completed_date.trnsltd} $completedDate",
                          style: textTheme.labelSmall!.copyWith(
                            color: colorScheme.outline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  _onLongPress(BuildContext context, BookingStatus status) {
    final textTheme = Theme.of(context).textTheme;

    final bool canCancel =
        status == BookingStatus.pending || status == BookingStatus.confirmed;

    if (canCancel) {
      SnackbarMes.showCustomBottomSheet(
        context: context,
        child: SizedBox(
          height: context.mediaQuery.height * 0.1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  leading: const Icon(HugeIcons.strokeRoundedCancelCircle),
                  title: Text(
                    LocaleKeys.booking_cancel_action.trnsltd,

                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showCancelBookingReasonSheet(
                      context,
                      bookingId: booking.id!,
                      onSuccess: () =>
                          context.read<BookingCubit>().loadBookings(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.booking_cannot_cancel.trnsltd,
      );
    }
  }

}
