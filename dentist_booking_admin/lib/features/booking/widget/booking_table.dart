import 'package:data_table_2/data_table_2.dart';
import 'package:dentist_booking_admin/core/app_setup.dart';
import 'package:dentist_booking_admin/core/enum/enum.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/blocs/booking/booking_cubit.dart';
import 'package:dentist_booking_admin/features/booking/service/ticket_print_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../core/model/booking_model.dart';
import '../../../core/widgets/custom_badg.dart';
import '../../../core/widgets/custom_icon_tabel_cell.dart';
import '../../../generated/locale_keys.g.dart';
import '../../queue/widget/queue_change_status_form_dialog.dart';
import 'booking_form_dialog.dart';
import 'printer_selection_dialog.dart';

class BookingTable extends StatefulWidget {
  const BookingTable({
    super.key,
    required this.bookings,
  });

  final List<BookingModel> bookings;

  @override
  State<BookingTable> createState() => _BookingTableState();
}

class _BookingTableState extends State<BookingTable> {
  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthCubit>().state;
    // final userRole = authState is Status ? authState.userRole : null;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      shadowColor: colorScheme.primary.withOpacity(.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable2(
          columnSpacing: 14,
          horizontalMargin: 12,
          minWidth: 900,

          headingRowHeight: 52,
          dataRowHeight: 58,

          headingRowColor: MaterialStateProperty.all(
            colorScheme.primary.withOpacity(.07),
          ),

          headingTextStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),

          dataTextStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(.85),
          ),

          border: TableBorder(
            horizontalInside: BorderSide(
              color: colorScheme.outline.withOpacity(.12),
            ),
          ),

          columns: [
            DataColumn2(
              label: _titleCell(
                LocaleKeys.booking_queue_number.trnsltd,
              ),

              size: ColumnSize.M,
            ),
            DataColumn2(
              label: _titleCell(
                LocaleKeys.booking_ticket_number.trnsltd,
              ),
              size: ColumnSize.M,
            ),

            DataColumn(
              label: _titleCell(
                LocaleKeys.booking_full_name.trnsltd,
              ),
            ),
            DataColumn(
              label: _titleCell(
                LocaleKeys.booking_address.trnsltd,
              ),
            ),

            DataColumn(
              label: _titleCell(
                LocaleKeys.booking_phone.trnsltd,
              ),
            ),

            DataColumn2(
              label: _titleCell(
                LocaleKeys.booking_type.trnsltd,
              ),
              size: ColumnSize.M,
            ),

            DataColumn2(
              label: _titleCell(
                LocaleKeys.booking_shift.trnsltd,
              ),
              size: ColumnSize.M,
            ),

            DataColumn2(
              label: _titleCell(
                LocaleKeys.booking_status.trnsltd,
              ),
              size: ColumnSize.M,
            ),

            DataColumn2(
              label: _titleCell(
                LocaleKeys.booking_booking_at.trnsltd,
              ),
            ),

            // DataColumn2(
            //   label: _titleCell(
            //     LocaleKeys.booking_created_at.trnsltd,
            //   ),
            // ),

            // DataColumn2(
            //   label: _titleCell(
            //     LocaleKeys.booking_updated_at.trnsltd,
            //   ),
            // ),
            // DataColumn(
            //   label: _titleCell(
            //     LocaleKeys.booking_completed_at.trnsltd,
            //   ),
            // ),
            DataColumn(
              label: _titleCell(
                LocaleKeys.booking_cancelled_at.trnsltd,
              ),
            ),

            DataColumn(
              label: _titleCell(
                LocaleKeys.booking_cancel_reason.trnsltd,
              ),
            ),

            const DataColumn(
              label: Center(child: Text("")),
            ),
          ],

          rows: List.generate(widget.bookings.length, (i) {
            final booking = widget.bookings[i];

            return DataRow(
              selected: true,
              color: MaterialStateProperty.resolveWith<Color?>(
                (states) {
                  if (states.contains(MaterialState.hovered)) {
                    return colorScheme.primary.withOpacity(.06);
                  }
                  return i % 2 == 0
                      ? colorScheme.primary.withOpacity(.02)
                      : Colors.transparent;
                },
              ),
              cells: [
                _cell(
                  booking.queueNumber.toString(),
                  overflow: TextOverflow.visible,
                ),
                _cell(
                  booking.ticketCode.toString(),
                  overflow: TextOverflow.visible,
                ),

                _cell(
                  booking.patientName ?? "-",
                  overflow: TextOverflow.visible,
                ),
                _cell(
                  booking.patientAddress ?? "-",
                  overflow: TextOverflow.visible,
                ),
                _cell(
                  booking.patientPhone ?? "_",
                ),
                DataCell(
                  CustomBadg(
                    label: booking.patientType.name,
                    bgcolor: booking.patientType.tobgColorsPatient(),
                    textColor: booking.patientType.totxtColorsPatient(),
                  ),
                ),
                DataCell(
                  CustomBadg(
                    label: booking.shift.name,
                    bgcolor: booking.shift.tobgColorsShiftBooking(),
                    textColor: booking.shift.totxtColorsShiftBooking(),
                  ),
                ),
                DataCell(
                  CustomBadg(
                    label: booking.bookingStatus.name,
                    bgcolor: booking.bookingStatus.tobgColorsBooking(),
                    textColor: booking.bookingStatus.totxtColorsBooking(),
                  ),
                ),
                _cell(
                  DateFormat('HH:mm yyyy-MM-dd').format(
                    booking.bookingDate,
                  ),
                  overflow: TextOverflow.visible,
                ),

                // _cell(
                //   DateFormat('HH:mm yyyy-MM-dd').format(
                //     booking.createdAt,
                //   ),
                //   overflow: TextOverflow.visible,
                // ),
                // _cell(
                //   DateFormat('HH:mm yyyy-MM-dd').format(booking.updatedAt!),
                //   overflow: TextOverflow.visible,
                // ),
                // _cell(
                //   booking.completedAt != null
                //       ? DateFormat(
                //           'HH:mm yyyy-MM-dd',
                //         ).format(booking.completedAt!)
                //       : "-",
                //   overflow: TextOverflow.visible,
                // ),
                _cell(
                  booking.cancelledAt != null
                      ? DateFormat(
                          'HH:mm yyyy-MM-dd',
                        ).format(booking.cancelledAt!)
                      : "-",
                  overflow: TextOverflow.visible,
                ),
                _cell(booking.cancelReason ?? "-"),
                DataCell(
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomIconTabelCell(
                            icon: HugeIcons.strokeRoundedCustomize,
                            color: colorScheme.primary,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<BookingCubit>(),
                                  child: QueueChangeStatusFormDialog(
                                    booking: booking,
                                    onConfirm: (updateStatus) {
                                      context
                                          .read<BookingCubit>()
                                          .updateBooking(updateStatus);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 3),

                          CustomIconTabelCell(
                            icon: HugeIcons.strokeRoundedEdit03,
                            color: colorScheme.primary,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<BookingCubit>(),
                                  child: BookingFormDialog(
                                    booking: booking,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 3),
                          CustomIconTabelCell(
                            icon: Icons.print,
                            color: colorScheme.primary,
                            onTap: () => _printTicket(context, booking),
                          ),

                          // SizedBox(width: 3),
                          // if (user²Role == UserRole.admin)
                          //   CustomIconTabelCell(
                          //     icon: Icons.delete,
                          //     color: colorScheme.error,
                          //     onTap: () => _onDeletedBooking(context, booking),
                          //   )
                          // else
                          //   SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  DataCell _cell(
    String text, {
    TextOverflow? overflow,
  }) {
    return DataCell(
      Center(
        child: Text(
          text,
          style: TextStyle().copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          overflow: overflow ?? TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }

  _titleCell(String text) {
    return Center(
      child: Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<void> _printTicket(BuildContext context, BookingModel booking) async {
    final messenger = ScaffoldMessenger.of(context);
    final printService = getIt<TicketPrintService>();
    final printers = printService.listPrinters();
    if (printers.isNotEmpty && context.mounted) {
      final selected = await showPrinterSelectionDialog(context, printers: printers);
      if (!context.mounted) return;
      if (selected != null) {
        try {
          messenger.showSnackBar(
            SnackBar(content: Text(LocaleKeys.printing_progress.trnsltd)),
          );
          await printService.printTicketToPrinter(booking, selected);
          if (context.mounted) {
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(content: Text(LocaleKeys.print_success.trnsltd)),
            );
          }
        } catch (e, stack) {
          debugPrint('[booking_table] printTicketToPrinter failed: $e');
          debugPrint('[booking_table] stack: $stack');
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
    try {
      await printService.printTicket(booking);
    } catch (e, stack) {
      debugPrint('[booking_table] _printTicket failed: $e');
      debugPrint('[booking_table] stack: $stack');
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(LocaleKeys.print_failed.trnsltd)),
        );
      }
    }
  }

  // _onDeletedBooking(BuildContext context, BookingModel booking) {
  //   SnackbarMes.showCustomDialog(
  //     context,
  //     title: LocaleKeys.booking_delete_title.trnsltd,
  //     content: LocaleKeys.booking_delete_confirm.trnsltd,
  //     buttonCancelText: LocaleKeys.cancel_button.trnsltd,
  //     buttonConfirmText: LocaleKeys.delete_button.trnsltd,
  //     onCancel: () => Navigator.of(context).pop(),
  //     onConfirm: () {
  //       context.read<BookingCubit>().deleteBooking(booking.id);
  //       Navigator.of(context).pop();
  //     },
  //   );
  // }
}
