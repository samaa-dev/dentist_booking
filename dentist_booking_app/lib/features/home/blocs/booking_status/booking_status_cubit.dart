import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/model/booking_status_model.dart';
import '../../repo/booking_status_repo.dart';

part 'booking_status_cubit.freezed.dart';
part 'booking_status_state.dart';

class BookingStatusCubit extends Cubit<BookingStatusState> {
  final BookingStatusRepo _bookingStatusRepo;
  // ignore: unused_field
  final SupabaseClient _client;

  BookingStatusCubit({
    required BookingStatusRepo bookingStatusRepo,
    required SupabaseClient client,
  }) : _bookingStatusRepo = bookingStatusRepo,
       _client = client,
       super(const BookingStatusState.loading());

  Future<void> loadStatus() async {
    emit(const BookingStatusState.loading());

    try {
      final status = await _bookingStatusRepo.getBookingStatus();
      emit(BookingStatusState.loaded(status));
    } catch (e) {
      debugPrint('Error loading booking status: $e');
      emit(
        BookingStatusState.error(
          message: LocaleKeys.restore_booking_status_failed.trnsltd,
        ),
      );
    }
  }
}
