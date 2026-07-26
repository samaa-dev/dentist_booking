import 'dart:async';

import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/tracking_model.dart';
import '../../repo/queue_repo.dart';

part 'queue_cubit.freezed.dart';
part 'queue_state.dart';

class QueueCubit extends Cubit<QueueState> {
  static const _activeQueueRefreshDebounce = Duration(milliseconds: 400);

  final QueueRepo _queueRepo;

  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSub;
  StreamSubscription<List<Map<String, dynamic>>>? _queueStateSub;
  Timer? _refreshDebounceTimer;

  QueueCubit({
    required QueueRepo queueRepo,
  }) : _queueRepo = queueRepo,
       super(const QueueState.initial()) {
    listenForRealtimeChanges();
  }

  void listenForRealtimeChanges() {
    _bookingsSub?.cancel();
    _bookingsSub = _queueRepo.watchBookings().listen(
      (_) {
        debugPrint('Active booking: bookings changed → scheduling refresh');
        _scheduleActiveQueueRefresh();
      },
      onError: (e) => debugPrint('Active booking stream error: $e'),
    );

    _queueStateSub?.cancel();
    _queueStateSub = _queueRepo.watchQueueState().listen(
      (_) {
        debugPrint('Active booking: queue_state changed → scheduling refresh');
        _scheduleActiveQueueRefresh();
      },
      onError: (e) => debugPrint('queue_state stream error: $e'),
    );
  }

  void _scheduleActiveQueueRefresh() {
    _refreshDebounceTimer?.cancel();
    _refreshDebounceTimer = Timer(_activeQueueRefreshDebounce, () {
      if (isClosed) return;
      loadActiveBookingQueue();
    });
  }

  @override
  Future<void> close() {
    _bookingsSub?.cancel();
    _queueStateSub?.cancel();
    _refreshDebounceTimer?.cancel();
    return super.close();
  }

  Future<void> getQueue({required String ticketCode}) async {
    emit(const QueueState.loading());

    try {
      final queue = await _queueRepo.getBookingQueue(
        ticketCode: ticketCode,
      );
      emit(QueueState.loaded(queue));
    } catch (e) {
      emit(QueueState.error(LocaleKeys.queue_load_error_message.trnsltd));
    }
  }

  Future<void> loadActiveBookingQueue() async {
    try {
      final queues = await _queueRepo.getAllActiveBookingQueues();
      emit(QueueState.activeQueueLoaded(queues));
    } catch (e) {
      emit(QueueState.activeQueueLoaded([]));
    }
  }
}
