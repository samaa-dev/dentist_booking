import 'package:dentist_booking_admin/core/app_setup.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/blocs/booking/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../../../generated/locale_keys.g.dart';
import '../widget/booking_content.dart' show BookingContent;
import '../widget/booking_ticket_dialog.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookingCubit>(
          create: (context) => getIt<BookingCubit>(),
        ),
        // BlocProvider<BookingCountCubit>(
        //   create: (context) => getIt<BookingCountCubit>(),
        // ),
      ],
      child: BlocConsumer<BookingCubit, BookingState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            orElse: () => false,
            error: (_) => true,
            errorAddBooking: (_) => true,
            errorUpdateBooking: (_) => true,
            errorDeleteBooking: (_) => true,
            successAddBooking: (_) => true,
            successUpdateBooking: (_) => true,
            successDeleteBooking: (_) => true,
            loadingbooking: () => true,
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loadingbooking: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => LoadingDialog(),
              );
            },
            successAddBooking: (booking) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              if (Navigator.canPop(context)) Navigator.pop(context);

              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.booking_success_create.trnsltd,
              );

              showDialog(
                context: context,
                builder: (_) => BookingTicketDialog(
                  booking: booking,
                ),
              );
            },
            successUpdateBooking: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              if (Navigator.canPop(context)) Navigator.pop(context);

              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.booking_success_update.trnsltd,
              );
            },
            successDeleteBooking: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);

              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.booking_success_delete.trnsltd,
              );
            },
            errorAddBooking: (message) {
              // if (Navigator.canPop(context)) Navigator.pop(context);
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },

            errorUpdateBooking: (message) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },
          );
        },
        builder: (context, state) {
          return BookingContent();
        },
      ),
    );
  }
}
