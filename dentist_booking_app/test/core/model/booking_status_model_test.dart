import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/model/booking_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingStatusModel', () {
    test('parses per-shift capacity fields from JSON', () {
      final status = BookingStatusModel.fromJson({
        'is_open': true,
        'shift': 'morning',
        'time_left': 30,
        'is_booking_enabled': true,
        'stop_reason': null,
        'shift_closed': null,
        'shift_full': null,
        'morning_full': true,
        'evening_full': false,
        'morning_available': false,
        'evening_available': true,
      });

      expect(status.isOpen, isTrue);
      expect(status.morningFull, isTrue);
      expect(status.eveningFull, isFalse);
      expect(status.morningAvailable, isFalse);
      expect(status.eveningAvailable, isTrue);
      expect(status.hasAnyBookableShift, isTrue);
      expect(status.isShiftAvailable(BookingShift.morning), isFalse);
      expect(status.isShiftAvailable(BookingShift.evening), isTrue);
      expect(status.isShiftFull(BookingShift.morning), isTrue);
      expect(status.preferredAvailableShift, BookingShift.evening);
    });

    test('morning full evening available prefers evening', () {
      const status = BookingStatusModel(
        isOpen: true,
        shift: BookingShift.morning,
        isBookingEnabled: true,
        morningFull: true,
        eveningFull: false,
        morningAvailable: false,
        eveningAvailable: true,
      );

      expect(status.hasAnyBookableShift, isTrue);
      expect(status.preferredAvailableShift, BookingShift.evening);
    });

    test('evening full morning available prefers morning', () {
      const status = BookingStatusModel(
        isOpen: true,
        shift: BookingShift.morning,
        isBookingEnabled: true,
        morningFull: false,
        eveningFull: true,
        morningAvailable: true,
        eveningAvailable: false,
      );

      expect(status.hasAnyBookableShift, isTrue);
      expect(status.isShiftAvailable(BookingShift.morning), isTrue);
      expect(status.isShiftAvailable(BookingShift.evening), isFalse);
      expect(status.preferredAvailableShift, BookingShift.morning);
    });

    test('both shifts full disables booking', () {
      const status = BookingStatusModel(
        isOpen: false,
        shift: BookingShift.morning,
        isBookingEnabled: true,
        shiftFull: BookingShift.morning,
        morningFull: true,
        eveningFull: true,
        morningAvailable: false,
        eveningAvailable: false,
      );

      expect(status.hasAnyBookableShift, isFalse);
      expect(status.preferredAvailableShift, isNull);
    });

    test('legacy payload: shift_full morning blocks booking', () {
      final status = BookingStatusModel.fromJson({
        'is_open': false,
        'shift': 'morning',
        'time_left': null,
        'is_booking_enabled': true,
        'stop_reason': null,
        'shift_closed': null,
        'shift_full': 'morning',
      });

      expect(status.hasAnyBookableShift, isFalse);
      expect(status.isShiftFull(BookingShift.morning), isTrue);
      expect(status.preferredAvailableShift, isNull);
    });

    test('legacy payload: open without capacity fields allows booking', () {
      final status = BookingStatusModel.fromJson({
        'is_open': true,
        'shift': 'evening',
        'time_left': 45,
        'is_booking_enabled': true,
        'stop_reason': null,
        'shift_closed': null,
        'shift_full': null,
      });

      expect(status.hasAnyBookableShift, isTrue);
      expect(status.preferredAvailableShift, BookingShift.evening);
    });

    test('cancelled capacity recovery: morning available again', () {
      const status = BookingStatusModel(
        isOpen: true,
        shift: BookingShift.morning,
        isBookingEnabled: true,
        morningFull: false,
        eveningFull: false,
        morningAvailable: true,
        eveningAvailable: true,
      );

      expect(status.hasAnyBookableShift, isTrue);
      expect(status.isShiftAvailable(BookingShift.morning), isTrue);
      expect(status.preferredAvailableShift, BookingShift.morning);
    });

    test(
      'after old allow_before cutoff but before morning_end: '
      'evening full does not close morning',
      () {
        // Server now keeps morning_available until morning_end.
        const status = BookingStatusModel(
          isOpen: true,
          shift: BookingShift.morning,
          isBookingEnabled: true,
          morningFull: false,
          eveningFull: true,
          morningAvailable: true,
          eveningAvailable: false,
        );

        expect(status.hasAnyBookableShift, isTrue);
        expect(status.isShiftAvailable(BookingShift.morning), isTrue);
        expect(status.isShiftAvailable(BookingShift.evening), isFalse);
        expect(status.isShiftFull(BookingShift.evening), isTrue);
        expect(status.preferredAvailableShift, BookingShift.morning);
      },
    );

    test('after morning_end morning is unavailable', () {
      const status = BookingStatusModel(
        isOpen: false,
        shift: null,
        isBookingEnabled: true,
        morningFull: false,
        eveningFull: true,
        morningAvailable: false,
        eveningAvailable: false,
      );

      expect(status.hasAnyBookableShift, isFalse);
      expect(status.isShiftAvailable(BookingShift.morning), isFalse);
      expect(status.preferredAvailableShift, isNull);
    });

    test('morning at capacity before morning_end disables morning only', () {
      const status = BookingStatusModel(
        isOpen: true,
        shift: BookingShift.morning,
        isBookingEnabled: true,
        morningFull: true,
        eveningFull: false,
        morningAvailable: false,
        eveningAvailable: true,
      );

      expect(status.hasAnyBookableShift, isTrue);
      expect(status.isShiftAvailable(BookingShift.morning), isFalse);
      expect(status.isShiftAvailable(BookingShift.evening), isTrue);
      expect(status.preferredAvailableShift, BookingShift.evening);
    });
  });
}
