import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../../../core/services/session_service.dart';
import '../model/clinic_statistics.dart';
import '../repo/statistics_repo.dart';

enum StatisticsPeriod { today, last7Days, last30Days, thisMonth, lastMonth, custom }

class StatisticsState {
  const StatisticsState({
    required this.period,
    required this.from,
    required this.to,
    this.data,
    this.loading = false,
    this.failed = false,
  });

  final StatisticsPeriod period;
  final DateTime from;
  final DateTime to;
  final ClinicStatistics? data;
  final bool loading;
  final bool failed;

  StatisticsState copyWith({
    StatisticsPeriod? period,
    DateTime? from,
    DateTime? to,
    ClinicStatistics? data,
    bool? loading,
    bool? failed,
  }) {
    return StatisticsState(
      period: period ?? this.period,
      from: from ?? this.from,
      to: to ?? this.to,
      data: data ?? this.data,
      loading: loading ?? this.loading,
      failed: failed ?? this.failed,
    );
  }
}

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit({required StatisticsRepo statisticsRepo})
    : _repo = statisticsRepo,
      super(_initial());

  final StatisticsRepo _repo;
  int _requestId = 0;

  static StatisticsState _initial() {
    final (from, to) = rangeFor(StatisticsPeriod.last30Days);
    return StatisticsState(period: StatisticsPeriod.last30Days, from: from, to: to);
  }

  static (DateTime, DateTime) rangeFor(StatisticsPeriod period, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    return switch (period) {
      StatisticsPeriod.today => (today, today),
      StatisticsPeriod.last7Days => (today.subtract(const Duration(days: 6)), today),
      StatisticsPeriod.last30Days => (today.subtract(const Duration(days: 29)), today),
      StatisticsPeriod.thisMonth => (DateTime(today.year, today.month), today),
      StatisticsPeriod.lastMonth => (
        DateTime(today.year, today.month - 1),
        DateTime(today.year, today.month, 0),
      ),
      StatisticsPeriod.custom => (today, today),
    };
  }

  Future<void> selectPeriod(StatisticsPeriod period) async {
    final (from, to) = rangeFor(period);
    emit(state.copyWith(period: period, from: from, to: to));
    await load();
  }

  Future<void> selectCustomRange(DateTime from, DateTime to) async {
    emit(state.copyWith(period: StatisticsPeriod.custom, from: from, to: to));
    await load();
  }

  Future<void> load() async {
    final requestId = ++_requestId;
    emit(state.copyWith(loading: true, failed: false));
    try {
      final data = await _repo.getStatistics(from: state.from, to: state.to);
      // Ignore responses for a period the user already changed.
      if (isClosed || requestId != _requestId) return;
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      if (isClosed || requestId != _requestId) return;
      emit(state.copyWith(loading: false, failed: true));
    }
  }
}
