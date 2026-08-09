import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/model/booking_model.dart';
import 'package:dentist_booking_admin_app/core/widgets/dialog_title_header.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class BookingTicketSheet extends StatelessWidget {
  const BookingTicketSheet({super.key, required this.booking});

  final BookingModel booking;

  static void show(BuildContext context, {required BookingModel booking}) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => BookingTicketSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialogTitleHeader(
            title: LocaleKeys.booking_ticket_title.trnsltd,
            subtitle: LocaleKeys.booking_ticket_subtitle.trnsltd,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                width: 2,
                color: colorScheme.primary.withOpacity(0.7),
              ),
              color: colorScheme.primary.withOpacity(0.08),
            ),
            child: Column(
              children: [
                Text(
                  LocaleKeys.booking_queue_number.trnsltd,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  booking.queueNumber?.padLeft(4, '0') ?? '----',
                  style: textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  LocaleKeys.booking_ticket_queue_number.trnsltd,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  booking.ticketCode ?? '—',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _TicketInfoRow(
            icon: HugeIcons.strokeRoundedSun03,
            title: LocaleKeys.booking_ticket_Shift.trnsltd,
            value: booking.shift.name,
          ),
          _TicketInfoRow(
            icon: HugeIcons.strokeRoundedCalendar01,
            title: LocaleKeys.booking_ticket_date.trnsltd,
            value:
                '${booking.bookingDate.day}-${booking.bookingDate.month}-${booking.bookingDate.year}',
          ),
          if (booking.patientName != null &&
              booking.patientName!.trim().isNotEmpty)
            _TicketInfoRow(
              icon: HugeIcons.strokeRoundedUser,
              title: LocaleKeys.booking_full_name.trnsltd,
              value: booking.patientName!,
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleKeys.cancel_button.trnsltd),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketInfoRow extends StatelessWidget {
  const _TicketInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            '$title :',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
