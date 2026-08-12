import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/model/booking_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingStatusModel', () {
    test('parses shift_full from JSON', () {
      final status = BookingStatusModel.fromJson({
        'is_open': false,
        'shift': 'morning',
        'time_left': null,
        'is_booking_enabled': true,
        'stop_reason': null,
        'shift_closed': null,
        'shift_full': 'morning',
      });

      expect(status.isOpen, isFalse);
      expect(status.shift, BookingShift.morning);
      expect(status.shiftFull, BookingShift.morning);
    });

    test('shift_full null when capacity available', () {
      final status = BookingStatusModel.fromJson({
        'is_open': true,
        'shift': 'evening',
        'time_left': 45,
        'is_booking_enabled': true,
        'stop_reason': null,
        'shift_closed': null,
        'shift_full': null,
      });

      expect(status.isOpen, isTrue);
      expect(status.shiftFull, isNull);
    });
  });
}
