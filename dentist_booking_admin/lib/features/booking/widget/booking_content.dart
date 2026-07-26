import 'dart:async';

import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/blocs/booking/booking_cubit.dart';
import 'package:dentist_booking_admin/features/booking/widget/booking_table.dart';
import 'package:dentist_booking_admin/features/booking/widget/header_booking.dart'
    show BookingHeader;
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/booking_model.dart';
import 'booking_date_scope.dart';
import 'booking_filter_bar.dart';
import 'booking_status_selector.dart';
import 'custom_search_bar.dart';
import 'empty_booking.dart';
import 'error_booking.dart';

class BookingContent extends StatefulWidget {
  const BookingContent({super.key});

  @override
  State<BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<BookingContent>
    with SingleTickerProviderStateMixin {
  bool filterOpen = false;
  BookingStatus? selectedStatus;
  BookingShift? selectedShift;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  final _searchController = TextEditingController();
  BookingDateScope _selectedScope = BookingDateScope.today;

  late AnimationController _controller;
  Timer? _debounceTimer;

  BookingCubit get _cubit => context.read<BookingCubit>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final today = DateTime.now();
    rangeStart = today;
    rangeEnd = today;

    // WidgetsBinding.instance.addPostFrameCallback((_) => _resetFilters());
  }

  void _onDateScopeChanged(BookingDateScope scope) {
    setState(() => _selectedScope = scope);

    final now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);

    switch (scope) {
      case BookingDateScope.today:
        rangeStart = todayStart;
        rangeEnd = now;
        break;
      case BookingDateScope.yesterday:
        rangeStart = todayStart.subtract(const Duration(days: 1));
        rangeEnd = rangeStart!.add(const Duration(hours: 23, minutes: 59));
        break;
      case BookingDateScope.last3Days:
        rangeStart = now.subtract(const Duration(days: 3));
        rangeEnd = now;
        break;
      case BookingDateScope.last7Days:
        rangeStart = now.subtract(const Duration(days: 7));
        rangeEnd = now;
        break;
      case BookingDateScope.other:
        rangeStart = null;
        rangeEnd = null;
        break;
    }

    _applyFilters();
  }

  void _applyFilters() {
    _cubit.getBookingsWithFilters(
      status: selectedStatus,
      shift: selectedShift,
      startDate: rangeStart,
      endDate: rangeEnd,
      searchQuery: _searchController.text.isEmpty
          ? null
          : _searchController.text,
    );
  }

  void _resetFilters() {
    setState(() {
      selectedStatus = null;
      selectedShift = null;
      rangeStart = DateTime.now();
      rangeEnd = DateTime.now();
      _selectedScope = BookingDateScope.today;
      _searchController.clear();
    });
    _applyFilters();
  }

  void _onSearchChanged(String value) {
    _debounce(() => _applyFilters());
  }

  void _debounce(VoidCallback run) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), run);
  }

  void _toggleFilter() {
    setState(() {
      filterOpen = !filterOpen;
      filterOpen ? _controller.forward() : _controller.reverse();
    });
  }

  void _onStatusChanged(BookingStatus? status) {
    setState(() => selectedStatus = status);
    _applyFilters();
  }

  void _onShiftChanged(BookingShift? shift) {
    setState(() => selectedShift = shift);
    _applyFilters();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingHeader(),
        const SizedBox(height: 10),

        Container(
          color: colorScheme.background,
          child: Row(
            children: [
              Flexible(
                child: BookingDateScopeSelector(
                  selectedScope: _selectedScope,
                  onScopeChanged: (scope) => _onDateScopeChanged(scope!),
                ),
              ),
              SizedBox(
                height: 24,
                child: VerticalDivider(
                  thickness: 1,
                  width: 40,
                  color: colorScheme.outline.withOpacity(0.4),
                ),
              ),
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  final allCounts = state.maybeWhen(
                    loaded: (bookings) => bookings,
                    orElse: () => <BookingModel>[],
                  );

                  return BookingStatusSelector(
                    selectedStatus: selectedStatus,
                    onStatusChanged: _onStatusChanged,
                    allCountsBookings: allCounts,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: CustomSearchBar(
                controller: _searchController,
                hint: LocaleKeys.search_by_patient_name.trnsltd,
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              onPressed: _toggleFilter,
              icon: Icon(
                HugeIcons.strokeRoundedFilterMailCircle,
                color: filterOpen ? colorScheme.primary : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizeTransition(
          sizeFactor: _controller,
          axisAlignment: -1,
          child: FadeTransition(
            opacity: _controller,
            child: BookingFilterBar(
              shift: selectedShift,
              status: selectedStatus,
              rangeStart: rangeStart,
              rangeEnd: rangeEnd,
              onChangedShift: _onShiftChanged,
              onChangedStatus: _onStatusChanged,
              onChangedDateRange: _onChangedDateRange,
              onReset: _resetFilters,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: BlocBuilder<BookingCubit, BookingState>(
            buildWhen: (previous, current) {
              return current.maybeWhen(
                orElse: () => false,
                loading: () => true,
                loaded: (_) => true,
                error: (_) => true,
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                ),
                loaded: (bookings) {
                  // context
                  //     .read<BookingCountCubit>()
                  //     .updateCountsFromFilteredBookings(
                  //       bookings,
                  //       selectedStatus, // <<< أضف هذا
                  //     );

                  if (bookings.isEmpty) {
                    return const EmptyBooking();
                  }
                  return BookingTable(bookings: bookings);
                },
                error: (message) => ErrorBooking(message: message),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ],
    );
  }

  void _syncScopeWithDateRange() {
    if (rangeStart == null || rangeEnd == null) {
      setState(() => _selectedScope = BookingDateScope.today);
      return;
    }

    final now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    // اليوم
    if (isSameDay(rangeStart!, todayStart) && rangeEnd!.isAfter(todayStart)) {
      setState(() => _selectedScope = BookingDateScope.today);
      return;
    }

    // أمس
    DateTime yesterdayStart = todayStart.subtract(const Duration(days: 1));
    if (isSameDay(rangeStart!, yesterdayStart) &&
        isSameDay(rangeEnd!, yesterdayStart)) {
      setState(() => _selectedScope = BookingDateScope.yesterday);
      return;
    }

    // آخر 3 أيام
    if (rangeStart!.isAtSameMomentAs(
          todayStart.subtract(const Duration(days: 3)),
        ) &&
        rangeEnd!.isAfter(todayStart)) {
      setState(() => _selectedScope = BookingDateScope.last3Days);
      return;
    }

    // آخر 7 أيام
    if (rangeStart!.isAtSameMomentAs(
          todayStart.subtract(const Duration(days: 7)),
        ) &&
        rangeEnd!.isAfter(todayStart)) {
      setState(() => _selectedScope = BookingDateScope.last7Days);
      return;
    }

    // غير مطابق → other
    setState(() => _selectedScope = BookingDateScope.other);
  }

  void _onChangedDateRange(from, to) {
    DateTime? start = from;
    DateTime? end = to;

    if (start != null && end == null) end = start;

    setState(() {
      rangeStart = start;
      rangeEnd = end;
    });

    _syncScopeWithDateRange();
    _applyFilters();
  }
}
