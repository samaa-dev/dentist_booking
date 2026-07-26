import 'package:dentist_booking_admin/core/app_setup.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/service/ticket_print_service.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/model/booking_model.dart';
import '../../../core/widgets/dialog_title_header.dart';
import 'printer_selection_dialog.dart';

class BookingTicketDialog extends StatelessWidget {
  final BookingModel booking;

  const BookingTicketDialog({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitleHeader(
              title: LocaleKeys.booking_ticket_title.trnsltd,
              subtitle: LocaleKeys.booking_ticket_subtitle.trnsltd,
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  width: 2,
                  color: colorScheme.primary.withOpacity(.7),
                ),
                color: colorScheme.primary.withOpacity(.08),
              ),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.booking_queue_number.trnsltd,
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 5),

                  Text(
                    booking.queueNumber.toString(),
                    style: textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    LocaleKeys.booking_ticket_queue_number.trnsltd,
                    style: textTheme.bodySmall!.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // const SizedBox(height: 4),
                  Text(
                    booking.ticketCode ?? '00',
                    style: textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),

                  // const SizedBox(height: 10),
                  // Text(
                  //   "${LocaleKeys.booking_people_before_Number.trnsltd} : ${booking.peopleBefore?.twoDigits()}",
                  //   style: textTheme.bodySmall!.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //     color: colorScheme.primary.withOpacity(.7),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            Divider(thickness: 0.6, height: 10),

            const SizedBox(height: 20),

            _info(
              context,
              title: "${LocaleKeys.booking_ticket_Shift.trnsltd} :",
              value: booking.shift.name,
            ),
            _info(
              context,
              title: "${LocaleKeys.booking_ticket_date.trnsltd} :",
              value:
                  "${booking.bookingDate.day}-${booking.bookingDate.month}-${booking.bookingDate.year}",
            ),

            const SizedBox(height: 30),
            _buildTicketActions(context),
          ],
        ),
      ),
    );
  }

  Widget _info(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _onPrint(context),
            icon: const Icon(Icons.print, size: 20),
            label: Text(
              LocaleKeys.print_button.trnsltd,
              style: TextStyle().copyWith(fontWeight: FontWeight.bold),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 50),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context, null),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 50),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              LocaleKeys.cancel_button.trnsltd,
              style: TextStyle().copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onPrint(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final printService = getIt<TicketPrintService>();
    final printers = printService.listPrinters();
    if (printers.isNotEmpty && context.mounted) {
      final selected = await showPrinterSelectionDialog(context, printers: printers);
      if (!context.mounted) return;
      if (selected != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(LocaleKeys.printing_progress.trnsltd)),
        );
        try {
          await printService.printTicketToPrinter(booking, selected);
          if (context.mounted) {
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(content: Text(LocaleKeys.print_success.trnsltd)),
            );
          }
        } catch (e, stack) {
          debugPrint('[booking_ticket_dialog] printTicketToPrinter failed: $e');
          debugPrint('[booking_ticket_dialog] stack: $stack');
          if (context.mounted) {
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(content: Text(LocaleKeys.print_failed.trnsltd)),
            );
          }
        }
        return;
      }
    }
    messenger.showSnackBar(
      SnackBar(content: Text(LocaleKeys.printing_progress.trnsltd)),
    );
    try {
      await printService.printTicket(booking);
    } catch (e, stack) {
      debugPrint('[booking_ticket_dialog] _onPrint failed: $e');
      debugPrint('[booking_ticket_dialog] stack: $stack');
      if (context.mounted) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(content: Text(LocaleKeys.print_failed.trnsltd)),
        );
      }
    }
  }
}
