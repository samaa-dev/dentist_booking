import '../extensions/os_extensions.dart';
import '../model/queue_stats_model.dart';
import '../../generated/locale_keys.g.dart';

enum QueueTurnKind {
  current,
  next,
  waiting,
  passed,
  notStartedNext,
}

abstract final class QueueTurnDisplay {
  static QueueTurnKind resolve({
    required QueueStatsModel stats,
    required String? patientQueueNumber,
  }) {
    final patient = int.tryParse(patientQueueNumber ?? '');
    final current = stats.currentQueueNumber;
    final before = stats.patientsBeforeYou;

    if (current == 0) {
      final adjusted = (before - 1).clamp(0, 999999);
      if (adjusted == 0) return QueueTurnKind.notStartedNext;
      return QueueTurnKind.waiting;
    }

    if (patient != null) {
      if (patient < current) return QueueTurnKind.passed;
      if (patient == current) return QueueTurnKind.current;
    }

    if (before == 1) return QueueTurnKind.next;

    return QueueTurnKind.waiting;
  }

  static bool isHighlightTurn(QueueTurnKind kind) {
    return switch (kind) {
      QueueTurnKind.current || QueueTurnKind.next || QueueTurnKind.notStartedNext =>
        true,
      _ => false,
    };
  }

  static String currentQueueValue(QueueStatsModel stats) {
    if (stats.currentQueueNumber == 0) {
      return LocaleKeys.queue_not_started.trnsltd;
    }
    return '${stats.currentQueueNumber}';
  }

  static String beforeYouValue({
    required QueueTurnKind kind,
    required QueueStatsModel stats,
  }) {
    return switch (kind) {
      QueueTurnKind.current => LocaleKeys.you_are_current_turn.trnsltd,
      QueueTurnKind.next || QueueTurnKind.notStartedNext =>
        LocaleKeys.you_are_next_in_queue.trnsltd,
      QueueTurnKind.passed => LocaleKeys.you_already_called.trnsltd,
      QueueTurnKind.waiting => _waitingCount(stats),
    };
  }

  static String beforeYouLabel({
    required QueueTurnKind kind,
    required QueueStatsModel stats,
  }) {
    return switch (kind) {
      QueueTurnKind.waiting when stats.currentQueueNumber > 0 ||
          _adjustedBeforeStart(stats) > 0 =>
        LocaleKeys.before_you.trnsltd,
      _ => '',
    };
  }

  /// Badge on ticket card in queue details (empty = no badge).
  static String? ticketBadgeText(QueueTurnKind kind) {
    return switch (kind) {
      QueueTurnKind.current => LocaleKeys.you_are_current_turn.trnsltd,
      QueueTurnKind.next || QueueTurnKind.notStartedNext =>
        LocaleKeys.you_are_next.trnsltd,
      _ => null,
    };
  }

  static int _adjustedBeforeStart(QueueStatsModel stats) {
    return (stats.patientsBeforeYou - 1).clamp(0, 999999);
  }

  static String _waitingCount(QueueStatsModel stats) {
    if (stats.currentQueueNumber == 0) {
      return '${_adjustedBeforeStart(stats)}';
    }
    return '${stats.patientsBeforeYou}';
  }
}
