import 'package:dentist_booking_app/core/model/queue_stats_model.dart';
import 'package:dentist_booking_app/core/util/queue_turn_display.dart';
import 'package:flutter_test/flutter_test.dart';

QueueStatsModel _stats({
  required int current,
  required int before,
}) {
  return QueueStatsModel(
    isPaused: false,
    currentQueueNumber: current,
    patientsBeforeYou: before,
    lastUpdated: DateTime(2026),
    totalInQueue: 10,
    estimatedWaitTime: 0,
  );
}

void main() {
  group('QueueTurnDisplay.resolve', () {
    test('current turn when queue equals current', () {
      final kind = QueueTurnDisplay.resolve(
        stats: _stats(current: 2, before: 0),
        patientQueueNumber: '2',
      );
      expect(kind, QueueTurnKind.current);
    });

    test('next turn when one patient before', () {
      final kind = QueueTurnDisplay.resolve(
        stats: _stats(current: 2, before: 1),
        patientQueueNumber: '3',
      );
      expect(kind, QueueTurnKind.next);
    });

    test('waiting when multiple patients before', () {
      final kind = QueueTurnDisplay.resolve(
        stats: _stats(current: 2, before: 2),
        patientQueueNumber: '4',
      );
      expect(kind, QueueTurnKind.waiting);
    });

    test('passed when queue number is below current', () {
      final kind = QueueTurnDisplay.resolve(
        stats: _stats(current: 2, before: 0),
        patientQueueNumber: '1',
      );
      expect(kind, QueueTurnKind.passed);
    });

    test('not started next for first in line before queue starts', () {
      final kind = QueueTurnDisplay.resolve(
        stats: _stats(current: 0, before: 1),
        patientQueueNumber: '1',
      );
      expect(kind, QueueTurnKind.notStartedNext);
    });
  });

  group('QueueTurnDisplay.isHighlightTurn', () {
    test('highlights current and next', () {
      expect(QueueTurnDisplay.isHighlightTurn(QueueTurnKind.current), isTrue);
      expect(QueueTurnDisplay.isHighlightTurn(QueueTurnKind.next), isTrue);
      expect(QueueTurnDisplay.isHighlightTurn(QueueTurnKind.waiting), isFalse);
    });
  });
}
