import 'package:dentist_booking_app/core/util/booking_ahead_confirm.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingAheadConfirm', () {
    test('zero or negative means first in line', () {
      expect(BookingAheadConfirm.isFirstInLine(0), isTrue);
      expect(BookingAheadConfirm.isFirstInLine(-1), isTrue);
      expect(BookingAheadConfirm.isFirstInLine(1), isFalse);
      expect(BookingAheadConfirm.isFirstInLine(7), isFalse);
    });

    test('messageKey switches at zero', () {
      expect(
        BookingAheadConfirm.messageKey(0),
        LocaleKeys.booking_ahead_first_message,
      );
      expect(
        BookingAheadConfirm.messageKey(7),
        LocaleKeys.booking_ahead_confirm_message,
      );
    });
  });
}
