import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/enum/enum.dart';
import '../../../core/util/calendar_date.dart';
import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/appbar/custom_app_bar.dart';
import '../../../core/widgets/appbar/title_app_bar.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../../../core/widgets/selected_date_text.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/booking/booking_cubit.dart';
import '../widgets/booking_status_list_view.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late BookingCubit _bookingCubit;

  DateTime? rangeStart;
  DateTime? rangeEnd;

  @override
  void initState() {
    super.initState();
    _bookingCubit = context.read<BookingCubit>();

    final today = DateTime.now();
    rangeStart = today;
    rangeEnd = today;

    _bookingCubit.updateFilters(
      newStatus: BookingStatus.pending,
      start: rangeStart,
      end: rangeEnd,
      query: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loadingbooking: () => true,
          errorCancelBooking: (_) => true,
          successCancelBooking: (_) => true,
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
          successCancelBooking: (message) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            SnackbarMes.showToastMsg(context, message: message);
          },
          errorCancelBooking: (message) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            SnackbarMes.showToastMsg(context, message: message);
          },
        );
      },
      child: Scaffold(
        appBar: CustomAppBar.search(
          titleAppBar: TitleAppBar(
            icon: HugeIcons.strokeRoundedAppointment02,
            text: LocaleKeys.navigation_bar_booking.trnsltd,
          ),
          searchController: _bookingCubit.searchController,
          hintText: LocaleKeys.search_bar_booking_hint_text.trnsltd,
          onSearch: (query) => _bookingCubit.updateFilters(query: query),
          action: [
            IconButton.filledTonal(
              icon: Icon(
                HugeIcons.strokeRoundedCalendar01,
                color: colorScheme.primary,
              ),
              onPressed: _selectDateRange,
            ),
          ],
          subTitle: _buildSubTitle(context),
        ),

        body: Column(
          children: [
            Expanded(
              child: BookingStatusListView(),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDateRange() {
    CalendarDate.selectDateRange(
      context: context,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      onChangedDateRange: _onChangedDateRange,
      onReset: _resetFilters,
    );
  }

  String _getFormattedDateRange() {
    return CalendarDate.getFormattedDateRange(
      context: context,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
  }

  void _onChangedDateRange(from, to) {
    DateTime? start = from;
    DateTime? end = to;

    if (start != null && end == null) end = start;

    setState(() {
      rangeStart = start;
      rangeEnd = end;
    });

    _bookingCubit.updateFilters(
      start: rangeStart,
      end: rangeEnd,
    );
  }

  void _resetFilters() {
    setState(() {
      rangeStart = DateTime.now();
      rangeEnd = DateTime.now();
    });
    _bookingCubit.resetFilters();
  }

  Widget _buildSubTitle(BuildContext context) {
    return GestureDetector(
      onTap: _selectDateRange,
      child: SelectedDateText(
        prefix: "${LocaleKeys.choose_date_range.trnsltd} : ",
        date: _getFormattedDateRange(),
      ),
    );
  }
}
