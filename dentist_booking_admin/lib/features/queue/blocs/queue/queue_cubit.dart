import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/app_setup.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/model/booking_model.dart';
import '../../../../core/model/queue_model.dart';
import '../../../../core/model/queue_status_model.dart';
import '../../repo/queue_repo.dart';

part 'queue_cubit.freezed.dart';
part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  static const _statusRefreshDebounce = Duration(milliseconds: 400);

  final QueueRepo _queueRepo;
  final SupabaseClient _client;

  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSub;
  Timer? _statusRefreshDebounceTimer;

  QueueCubit({
    required QueueRepo queueRepo,
    required SupabaseClient client,
  }) : _queueRepo = queueRepo,
       _client = client,
       super(QueueState.initial()) {
    listenBookings();
  }

  void listenBookings() {
    _bookingsSub?.cancel();
    _bookingsSub = _queueRepo.watchBookings().listen(
      (_) {
        debugPrint('Queue: bookings changed → scheduling status refresh');
        _scheduleStatusRefresh();
      },
      onError: (e) {
        if (getIt<SessionService>().handleIfExpired(e)) return;
        debugPrint('Queue bookings stream error: $e');
      },
    );
  }

  void _scheduleStatusRefresh() {
    _statusRefreshDebounceTimer?.cancel();
    _statusRefreshDebounceTimer = Timer(_statusRefreshDebounce, () {
      if (isClosed) return;
      final isProcessing = state.maybeWhen(
        processing: () => true,
        orElse: () => false,
      );
      if (isProcessing) return;
      loadStatus();
    });
  }

  @override
  Future<void> close() {
    _bookingsSub?.cancel();
    _statusRefreshDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> loadStatus() async {
    try {
      final status = await _queueRepo.statusQueue();
      emit(QueueState.statusLoaded(status));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      emit(
        QueueState.error(
          e.toString().replaceFirst(
            "Exception: Failed to get queue status: ",
            "",
          ),
        ),
      );
    }
  }

  Future<void> nextQueue() async {
    try {
      final resp = await _queueRepo.nextQueue();
      if (resp != null && resp['success'] == false) {
        final code = resp['code'] as String? ?? 'unknown';
        emit(QueueState.error(code));
        return;
      }
      final status = await _queueRepo.statusQueue();
      emit(QueueState.statusLoaded(status));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      emit(
        QueueState.error(
          e.toString().replaceFirst(
            "Exception: Failed to get next queue: Exception: ",
            "",
          ),
        ),
      );
    }
  }

  Future<void> togglePauseResume(String shift, bool isPaused) async {
    emit(const QueueState.processing());

    try {
      if (isPaused) {
        // حالة موقوف → نريد تشغيله
        await _queueRepo.resumeQueue(shift);
      } else {
        // حالة يعمل → نريد وقفه
        await _queueRepo.pauseQueue(shift);
      }

      // 👇 مهم جداً: نعيد جلب الحالة من RPC
      final status = await _queueRepo.statusQueue();
      emit(QueueState.statusLoaded(status));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      emit(
        QueueState.error(
          e.toString().replaceFirst(
            "Exception: ",
            "",
          ),
        ),
      );
    }
  }

  Future<void> updateBookingStatus(BookingModel booking) async {
    try {
      final updatedBooking = booking.copyWith(
        cancelledBy: booking.cancelledBy == "SESSION_USER_ID"
            ? _client.auth.currentUser?.id
            : null,
        bookingCreatedBy: _client.auth.currentUser?.id,
      );

      final created = await _queueRepo.updateBooking(updatedBooking);

      debugPrint("Booking updated: $created");

      // emit(QueueState.successUpdateBooking(created));

      // 👇 فقط هنا نستدعي nextQueue مرة وحدة
      await nextQueue();
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint("Update then next error: $e");
      emit(
        QueueState.errorUpdateBooking(
          e.toString().replaceFirst(
            "Exception: ",
            "",
          ),
        ),
      );
    }
  }

  static bool isNoMoreBookingsCode(String code) {
    return code == 'NO_MORE_BOOKINGS' ||
        code == 'NO_MORE_BOOKINGS_MORNING' ||
        code == 'NO_MORE_BOOKINGS_EVENING';
  }

  /// When queue number is 0 (not started), call this to advance to 1.
  Future<void> startQueue() async {
    emit(const QueueState.processing());
    try {
      final resp = await _queueRepo.nextQueue();
      if (resp != null && resp['success'] == false) {
        final code = resp['code'] as String? ?? 'unknown';
        if (isNoMoreBookingsCode(code)) {
          await loadStatus();
          return;
        }
        emit(QueueState.error(code));
        return;
      }
      final status = await _queueRepo.statusQueue();
      emit(QueueState.statusLoaded(status));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      emit(
        QueueState.error(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> restartQueue(String shift) async {
    emit(const QueueState.processing());
    try {
      await _queueRepo.restartQueue(shift);
      final status = await _queueRepo.statusQueue();
      emit(QueueState.statusLoaded(status));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      emit(
        QueueState.error(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }
}
