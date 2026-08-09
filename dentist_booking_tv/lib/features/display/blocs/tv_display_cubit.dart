import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/ads_model.dart';
import '../../../core/model/queue_status_model.dart';
import '../../../core/services/queue_announcement_service.dart';
import '../repo/ads_repo.dart';
import '../repo/queue_repo.dart';
import 'tv_display_state.dart';

class TvDisplayCubit extends Cubit<TvDisplayState> {
  TvDisplayCubit({
    required QueueRepo queueRepo,
    required AdsRepo adsRepo,
    required QueueAnnouncementService announcementService,
  })  : _queueRepo = queueRepo,
        _adsRepo = adsRepo,
        _announcementService = announcementService,
        super(const TvDisplayInitial());

  final QueueRepo _queueRepo;
  final AdsRepo _adsRepo;
  final QueueAnnouncementService _announcementService;

  StreamSubscription<List<Map<String, dynamic>>>? _bookingsSub;
  StreamSubscription<List<Map<String, dynamic>>>? _queueStateSub;
  Timer? _refreshDebounceTimer;
  Timer? _bookingsFallbackPollTimer;
  Timer? _adsPollTimer;

  /// Last known current_queue_number from a previous successful load (used to detect "new number called").
  int? _lastCurrentQueueNumber;

  /// Prevent overlapping queue_status RPCs from wiping an in-flight call overlay.
  bool _refreshInFlight = false;
  bool _refreshQueued = false;

  static const Duration _refreshDebounce = Duration(milliseconds: 400);

  /// Slow poll when anon RLS blocks bookings realtime (waiting list / confirmed bookings).
  static const Duration _bookingsFallbackPollInterval = Duration(seconds: 60);

  /// Ads change infrequently; refresh separately from queue realtime.
  static const Duration _adsPollInterval = Duration(minutes: 5);

  void start() {
    _listenRealtime();
    _startBookingsFallbackPoll();
    _startAdsPoll();
    _loadInitial();
  }

  void stop() {
    _bookingsSub?.cancel();
    _bookingsSub = null;
    _queueStateSub?.cancel();
    _queueStateSub = null;
    _refreshDebounceTimer?.cancel();
    _refreshDebounceTimer = null;
    _bookingsFallbackPollTimer?.cancel();
    _bookingsFallbackPollTimer = null;
    _adsPollTimer?.cancel();
    _adsPollTimer = null;
    _announcementService.stop();
  }

  void _listenRealtime() {
    _bookingsSub?.cancel();
    _bookingsSub = _queueRepo.watchBookings().listen(
      (_) {
        debugPrint('TV: bookings changed → scheduling queue refresh');
        _scheduleRefresh();
      },
      onError: (e) => debugPrint('TV bookings stream error: $e'),
    );

    _queueStateSub?.cancel();
    _queueStateSub = _queueRepo.watchQueueState().listen(
      (_) {
        debugPrint('TV: queue_state changed → scheduling queue refresh');
        _scheduleRefresh();
      },
      onError: (e) => debugPrint('TV queue_state stream error: $e'),
    );
  }

  void _startBookingsFallbackPoll() {
    _bookingsFallbackPollTimer?.cancel();
    _bookingsFallbackPollTimer = Timer.periodic(
      _bookingsFallbackPollInterval,
      (_) {
        if (isClosed) return;
        debugPrint('TV: bookings fallback poll → queue refresh');
        _scheduleRefresh();
      },
    );
  }

  void _startAdsPoll() {
    _adsPollTimer?.cancel();
    _adsPollTimer = Timer.periodic(_adsPollInterval, (_) {
      if (isClosed) return;
      _refreshAds();
    });
  }

  void _scheduleRefresh() {
    _refreshDebounceTimer?.cancel();
    _refreshDebounceTimer = Timer(_refreshDebounce, () {
      if (isClosed) return;
      _refreshQueue();
    });
  }

  /// Called by the UI after the "called number" overlay has been shown for 5 seconds and dismissed.
  /// Re-emits the same loaded state with [justCalledNumber] set to null so the overlay does not show again.
  void clearJustCalled() {
    final s = state;
    if (s is TvDisplayLoaded) {
      emit(s.copyWithClearJustCalled());
    }
  }

  Future<void> _loadInitial() async {
    emit(const TvDisplayLoading());
    try {
      final results = await Future.wait([
        _queueRepo.statusQueue(),
        _adsRepo.getAppAds(),
      ]);
      final queueStatus = results[0] as QueueStatusModel;
      final ads = results[1] as List<AdsModel>;
      _emitLoaded(queueStatus: queueStatus, ads: ads);
    } catch (e) {
      emit(TvDisplayError(e.toString()));
    }
  }

  Future<void> _refreshQueue() async {
    final isFirstLoad = state is TvDisplayInitial || state is TvDisplayError;
    if (isFirstLoad) {
      await _loadInitial();
      return;
    }

    if (_refreshInFlight) {
      _refreshQueued = true;
      return;
    }

    _refreshInFlight = true;
    try {
      do {
        _refreshQueued = false;
        try {
          final queueStatus = await _queueRepo.statusQueue();
          if (isClosed) return;
          final current = state;
          final ads = current is TvDisplayLoaded ? current.ads : <AdsModel>[];
          _emitLoaded(queueStatus: queueStatus, ads: ads);
        } catch (e) {
          debugPrint('TV queue refresh error: $e');
        }
      } while (_refreshQueued && !isClosed);
    } finally {
      _refreshInFlight = false;
    }
  }

  Future<void> _refreshAds() async {
    final current = state;
    if (current is! TvDisplayLoaded) return;
    try {
      final ads = await _adsRepo.getAppAds();
      emit(current.copyWith(ads: ads));
    } catch (e) {
      debugPrint('TV ads refresh error: $e');
    }
  }

  void _emitLoaded({
    required QueueStatusModel queueStatus,
    required List<AdsModel> ads,
  }) {
    final current = state;
    final previousJustCalled =
        current is TvDisplayLoaded ? current.justCalledNumber : null;

    // Keep an in-progress call sticky until clearJustCalled() — unless inactive.
    int? justCalledNumber = previousJustCalled;

    if (queueStatus.hasActiveCurrentTurn) {
      final newCurrent = queueStatus.currentQueueNumber ?? 0;
      final prev = _lastCurrentQueueNumber;

      if (newCurrent > 0 && prev != null && newCurrent > prev) {
        justCalledNumber = newCurrent;
      }

      _lastCurrentQueueNumber = newCurrent;
    } else {
      _lastCurrentQueueNumber = null;
      justCalledNumber = null;
    }

    final doctorDisplayName =
        current is TvDisplayLoaded ? current.doctorDisplayName : null;

    emit(TvDisplayLoaded(
      queueStatus: queueStatus,
      ads: ads,
      justCalledNumber: justCalledNumber,
      doctorDisplayName: doctorDisplayName,
    ));
  }

  @override
  Future<void> close() {
    stop();
    return super.close();
  }
}
