import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/model/booking_model.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/booking_repo.dart';

part 'booking_cubit.freezed.dart';
part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo _bookingRepo;
  // ignore: unused_field
  final SupabaseClient _client;

  BookingCubit({
    required BookingRepo bookingRepo,
    required SupabaseClient client,
  }) : _bookingRepo = bookingRepo,
       _client = client,
       super(BookingState.initial());

  BookingStatus? status;
  DateTime? startDate;
  DateTime? endDate;
  String? searchQuery;

  TextEditingController searchController = TextEditingController();

  Future<void> loadBookings() async {
    emit(const BookingState.loading());

    try {
      final bookingList = await _bookingRepo.getBookings(
        startDate: startDate,
        endDate: endDate,
        searchQuery: searchQuery,
      );

      debugPrint('Booking list: $bookingList');

      emit(BookingState.loaded(bookingList));
    } catch (e) {
      debugPrint('Error loading bookings: $e');
      emit(BookingState.error(LocaleKeys.error_loading_bookings.trnsltd));
    }
  }

  void updateFilters({
    BookingStatus? newStatus,
    DateTime? start,
    DateTime? end,
    String? query,
  }) {
    status = newStatus ?? status;
    startDate = start ?? startDate;
    endDate = end ?? endDate;
    searchQuery = query ?? searchQuery;

    loadBookings();
  }

  void resetFilters() {
    status = status;
    startDate = DateTime.now();
    endDate = DateTime.now();
    searchQuery = null;

    loadBookings();
  }

  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    emit(const BookingState.loadingbooking());

    try {
      await _bookingRepo.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );

      final bookingList = await _bookingRepo.getBookings(
        startDate: startDate,
        endDate: endDate,
        searchQuery: searchQuery,
      );
      emit(
        BookingState.successCancelBooking(LocaleKeys.booking_cancel_success.trnsltd),
      );
      emit(BookingState.loaded(bookingList));
    } catch (e) {
      debugPrint("Cancel booking failed: $e");
      final message = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : LocaleKeys.CANCEL_FAILED.trnsltd;
      emit(BookingState.errorCancelBooking(message));
    }
  }
}
