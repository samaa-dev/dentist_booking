import 'dart:async';

import 'package:dentist_booking_admin/core/enum/enum.dart';
import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/app_setup.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/model/booking_model.dart';
import '../../../../core/model/profile_model.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/booking_repo.dart';

part 'booking_cubit.freezed.dart';
part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo _bookingRepo;
  final SupabaseClient _client;

  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSub;

  BookingCubit({
    required BookingRepo bookingRepo,
    required SupabaseClient client,
  }) : _bookingRepo = bookingRepo,
       _client = client,
       super(BookingState.initial()) {
    listenbookings();
  }

  void listenbookings() {
    _bookingsSub?.cancel();

    _bookingsSub = _bookingRepo.getBookingsStream().listen((_) async {
      debugPrint("🔄 Booking changed → refreshing full data...");

      emit(const BookingState.loading());
      final bookingList = await _bookingRepo.getBookingsWithFilters(
        endDate: DateTime.now(),
        startDate: DateTime.now(),
        searchQuery: "",
        shift: null,
        status: null,
      );

      emit(BookingState.loaded(bookingList));
    });
  }

  Future<void> getAllBookings() async {
    emit(const BookingState.loading());
    try {
      final bookingList = await _bookingRepo.getAllBookings();

      emit(BookingState.loaded(bookingList));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error loading patients: $e');
      emit(BookingState.error(LocaleKeys.error_loading_bookings.trnsltd));
    }
  }

  Future<void> getBookingsWithFilters({
    BookingStatus? status,
    BookingShift? shift,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    emit(const BookingState.loading());
    try {
      final bookingList = await _bookingRepo.getBookingsWithFilters(
        status: status,
        shift: shift,
        startDate: startDate,
        endDate: endDate,
        searchQuery: searchQuery,
      );

      emit(BookingState.loaded(bookingList));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error loading bookings: $e');
      emit(BookingState.error(LocaleKeys.error_loading_bookings.trnsltd));
    }
  }

  Future<void> getAllPatients() async {
    emit(const BookingState.loadingPatients());
    try {
      final patientList = await _bookingRepo.getAllPatients();

      emit(BookingState.loadedPatients(patientList));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error loading patients: $e');
      emit(
        BookingState.errorPatients(
          LocaleKeys.error_loading_patients.trnsltd,
        ),
      );
    }
  }

  Future<void> updateBooking(BookingModel booking) async {
    emit(BookingState.loadingbooking());

    try {
      final updatedBooking = booking.copyWith(
        cancelledBy: booking.cancelledBy == "SESSION_USER_ID"
            ? _client.auth.currentUser?.id
            : null,
        bookingCreatedBy: _client.auth.currentUser?.id,
      );

      final created = await _bookingRepo.updateBooking(updatedBooking);

      debugPrint("Updated booking: $created");

      final list = await _bookingRepo.getAllBookings();

      emit(BookingState.successUpdateBooking(created));
      emit(BookingState.loaded(list));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint("Update booking error: $e");
      emit(
        BookingState.errorUpdateBooking(
          e.toString().replaceFirst(
            "Exception: Failed to update booking: Exception: ",
            "",
          ),
        ),
      );
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    debugPrint("BookingCubit createBooking: $booking");
    emit(BookingState.loadingbooking());

    try {
      final updatedBooking = booking.copyWith(
        cancelledBy: booking.cancelledBy == "SESSION_USER_ID"
            ? _client.auth.currentUser?.id
            : null,
        bookingCreatedBy: _client.auth.currentUser?.id,
      );

      debugPrint("updatedBooking booking: $updatedBooking");

      // 🔥 1) إنشاء الحجز
      final created = await _bookingRepo.createBooking(updatedBooking);

      debugPrint("Created booking: $created");

      // 🔥 2) جلب كل الحجوزات بعد الإضافة
      final list = await _bookingRepo.getAllBookings();

      // 🔥 3) إيجاد الحجز الذي تم إنشاؤه من خلال الـ ID
      final createdFromList = list.firstWhere(
        (b) => b.id == created.id,
        orElse: () => created, // fallback
      );

      // 🔥 4) عمل نسخة copyWith لو أردت تعديل شيء
      final finalCreated = created.copyWith(
        queueNumber: createdFromList.queueNumber,
        peopleBefore: createdFromList.peopleBefore,
      );

      debugPrint("finalCreated booking: $finalCreated");

      // 🔥 5) إرسال الحدث بنجاح
      emit(BookingState.successAddBooking(finalCreated));

      // 🔥 6) إعادة تحميل القائمة
      emit(BookingState.loaded(list));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint("Create booking error: $e");
      emit(
        BookingState.errorAddBooking(
          e.toString().replaceFirst(
            "Exception: Failed to create booking: Exception: ",
            "",
          ),
        ),
      );
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    emit(BookingState.loadingbooking());
    try {
      await _bookingRepo.deleteBooking(bookingId);

      final list = await _bookingRepo.getAllBookings();

      emit(BookingState.successDeleteBooking(null));
      emit(BookingState.loaded(list));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error deleting booking: $e');
      emit(
        BookingState.errorDeleteBooking(
          LocaleKeys.booking_error_delete.trnsltd,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _bookingsSub?.cancel();
    return super.close();
  }
}
