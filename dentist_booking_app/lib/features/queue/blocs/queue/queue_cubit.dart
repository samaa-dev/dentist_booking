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
  static const _activeQueuePollInterval = Duration(seconds: 20);

  final QueueRepo _queueRepo;

  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSub;
  StreamSubscription<List<Map<String, dynamic>>>? _queueStateSub;
  Timer? _refreshDebounceTimer;
  Timer? _pollTimer;
  bool _loadInFlight = false;

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

  /// Call when the app returns to foreground so queue numbers catch up
  /// even if a realtime event was missed while backgrounded.
  void onAppResumed() {
    if (isClosed) return;
    debugPrint('Active booking: app resumed → refreshing queue');
    loadActiveBookingQueue();
  }

  void _syncPollTimer({required bool hasActiveQueues}) {
    if (!hasActiveQueues) {
      _pollTimer?.cancel();
      _pollTimer = null;
      return;
    }
    if (_pollTimer != null) return;
    _pollTimer = Timer.periodic(_activeQueuePollInterval, (_) {
      if (isClosed) return;
      debugPrint('Active booking: poll tick → refreshing queue');
      loadActiveBookingQueue();
    });
  }

  @override
  Future<void> close() {
    _bookingsSub?.cancel();
    _queueStateSub?.cancel();
    _refreshDebounceTimer?.cancel();
    _pollTimer?.cancel();
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
    if (_loadInFlight || isClosed) return;
    _loadInFlight = true;
    try {
      final queues = await _queueRepo.getAllActiveBookingQueues();
      if (isClosed) return;
      emit(QueueState.activeQueueLoaded(queues));
      _syncPollTimer(hasActiveQueues: queues.isNotEmpty);
    } catch (e) {
      if (isClosed) return;
      emit(QueueState.activeQueueLoaded([]));
      _syncPollTimer(hasActiveQueues: false);
    } finally {
      _loadInFlight = false;
    }
  }
}
