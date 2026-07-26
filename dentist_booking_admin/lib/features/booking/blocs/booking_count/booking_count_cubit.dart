import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enum/enum.dart';
import '../../repo/booking_repo.dart';

part 'booking_count_cubit.freezed.dart';
part 'booking_count_state.dart';

class BookingCountCubit extends Cubit<BookingCountState> {
  final BookingRepo _bookingRepo;

  StreamSubscription<Map<BookingStatus, int>>? _countsSub;

  BookingCountCubit({
    required BookingRepo bookingRepo,
    required SupabaseClient client,
  }) : _bookingRepo = bookingRepo,
       super(BookingCountState.initial()) {
    listenCounts();
  }

  void listenCounts() {
    _countsSub?.cancel();

    _countsSub = _bookingRepo.getBookingStatusCountsStream().listen((counts) {
      emit(BookingCountState.statusCounts(counts));
    });
  }

  @override
  Future<void> close() {
    _countsSub?.cancel();
    return super.close();
  }
}
