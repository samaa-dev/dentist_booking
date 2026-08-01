import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/model/queue_stats_model.dart';
import 'package:dentist_booking_app/core/util/queue_turn_display.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
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

    test('evening ticket with current 0 is waiting not current', () {
      // Regression: stale evening pointer fixed in SQL to current=0;
      // patient #2 must not be treated as "your turn".
      final kind = QueueTurnDisplay.resolve(
        stats: _stats(current: 0, before: 2),
        patientQueueNumber: '2',
      );
      expect(kind, isNot(QueueTurnKind.current));
      expect(kind, QueueTurnKind.waiting);
    });

    test('evening ticket #1 with current 0 is notStartedNext', () {
      final kind = QueueTurnDisplay.resolve(
        stats: _stats(current: 0, before: 1),
        patientQueueNumber: '1',
      );
      expect(kind, QueueTurnKind.notStartedNext);
    });
  });

  group('QueueTurnDisplay.currentQueueValue', () {
    test('uses shift-specific not-started key for evening', () {
      final value = QueueTurnDisplay.currentQueueValue(
        _stats(current: 0, before: 2),
        shift: BookingShift.evening,
      );
      // Without EasyLocalization, .tr() returns the key string.
      expect(value, LocaleKeys.queue_not_started_evening);
    });

    test('uses shift-specific not-started key for morning', () {
      final value = QueueTurnDisplay.currentQueueValue(
        _stats(current: 0, before: 1),
        shift: BookingShift.morning,
      );
      expect(value, LocaleKeys.queue_not_started_morning);
    });

    test('falls back to generic not-started when shift is null', () {
      final value = QueueTurnDisplay.currentQueueValue(
        _stats(current: 0, before: 1),
      );
      expect(value, LocaleKeys.queue_not_started);
    });

    test('returns numeric current when queue has started', () {
      final value = QueueTurnDisplay.currentQueueValue(
        _stats(current: 2, before: 0),
        shift: BookingShift.evening,
      );
      expect(value, '2');
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
