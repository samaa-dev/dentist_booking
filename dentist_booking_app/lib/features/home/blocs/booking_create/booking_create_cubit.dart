import 'package:dentist_booking_app/core/model/booking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../repo/booking_create_repo.dart';
import '../../../queue/repo/queue_repo.dart';

part 'booking_create_cubit.freezed.dart';
part 'booking_create_state.dart';

class BookingCreateCubit extends Cubit<BookingCreateState> {
  final BookingCreateRepo _bookingCreateRepo;
  final QueueRepo _queueRepo;
  // ignore: unused_field
  final SupabaseClient _client;

  BookingCreateCubit({
    required BookingCreateRepo bookingCreateRepo,
    required QueueRepo queueRepo,
    required SupabaseClient client,
  }) : _bookingCreateRepo = bookingCreateRepo,
       _queueRepo = queueRepo,
       _client = client,
       super(BookingCreateState.initial());

  Future<bool> checkCanBookForSelf() async {
    try {
      return await _queueRepo.hasActiveBookingForCurrentUser();
    } catch (e) {
      debugPrint("Failed to check if can book for self: $e");
      return false;
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    emit(BookingCreateState.loading());

    try {
      final created = await _bookingCreateRepo.createBooking(booking);

      emit(
        BookingCreateState.successBookingCreate(created),
      );
    } catch (e) {
      debugPrint("Create booking error: $e");
      emit(
        BookingCreateState.errorBookingCreate(
          e.toString().replaceFirst(
            "Exception: Failed to create booking: Exception: ",
            "",
          ),
        ),
      );
    }
  }
}
