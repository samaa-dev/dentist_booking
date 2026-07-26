import 'dart:async';

import 'package:dentist_booking_admin_app/core/enum/enum.dart';
import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/booking_model.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/booking_repo.dart';

part 'booking_cubit.freezed.dart';
part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo _bookingRepo;

  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSub;
  Timer? _searchDebounce;

  BookingStatus? _status;
  BookingShift? _shift;
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';
  BookingDateScope _dateScope = BookingDateScope.today;

  BookingCubit({required BookingRepo bookingRepo})
      : _bookingRepo = bookingRepo,
        super(const BookingState.initial()) {
    _applyDateScope(BookingDateScope.today);
    listenBookings();
  }

  BookingDateScope get dateScope => _dateScope;
  BookingStatus? get selectedStatus => _status;
  BookingShift? get selectedShift => _shift;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get searchQuery => _searchQuery;

  void listenBookings() {
    _bookingsSub?.cancel();
    _bookingsSub = _bookingRepo.getBookingsStream().listen((_) {
      debugPrint('Booking changed → refreshing...');
      reload();
    });
  }

  void _applyDateScope(BookingDateScope scope) {
    _dateScope = scope;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (scope) {
      case BookingDateScope.today:
        _startDate = today;
        _endDate = today;
      case BookingDateScope.yesterday:
        final y = today.subtract(const Duration(days: 1));
        _startDate = y;
        _endDate = y;
      case BookingDateScope.last3Days:
        _startDate = today.subtract(const Duration(days: 2));
        _endDate = today;
      case BookingDateScope.last7Days:
        _startDate = today.subtract(const Duration(days: 6));
        _endDate = today;
      case BookingDateScope.other:
        break;
    }
  }

  Future<void> reload() => getBookingsWithFilters();

  Future<void> getBookingsWithFilters() async {
    emit(const BookingState.loading());
    try {
      final bookingList = await _bookingRepo.getBookingsWithFilters(
        status: _status,
        shift: _shift,
        startDate: _startDate,
        endDate: _endDate,
        searchQuery: _searchQuery,
      );
      emit(BookingState.loaded(bookingList));
    } catch (e) {
      debugPrint('Error loading bookings: $e');
      emit(BookingState.error(LocaleKeys.error_loading_bookings.trnsltd));
    }
  }

  void setDateScope(BookingDateScope scope) {
    _applyDateScope(scope);
    getBookingsWithFilters();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    _dateScope = BookingDateScope.other;
    _startDate = DateTime(start.year, start.month, start.day);
    _endDate = DateTime(end.year, end.month, end.day);
    getBookingsWithFilters();
  }

  void setStatus(BookingStatus? status) {
    _status = status;
    getBookingsWithFilters();
  }

  void setShift(BookingShift? shift) {
    _shift = shift;
    getBookingsWithFilters();
  }

  void setSearchQuery(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      getBookingsWithFilters();
    });
  }

  void resetFilters() {
    _status = null;
    _shift = null;
    _searchQuery = '';
    _applyDateScope(BookingDateScope.today);
    getBookingsWithFilters();
  }

  @override
  Future<void> close() {
    _bookingsSub?.cancel();
    _searchDebounce?.cancel();
    return super.close();
  }
}
