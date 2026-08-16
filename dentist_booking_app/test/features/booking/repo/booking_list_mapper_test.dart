import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/model/booking_model.dart';
import 'package:dentist_booking_app/features/booking/repo/booking_list_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingListMapper', () {
    test('maps confirmed same-day booking like TIC-1685 into BookingModel', () {
      final rows = [
        {
          'id': '9c6093c6-960f-4453-8623-f2977f9360ae',
          'booking_date': '2026-08-16T18:13:00',
          'patient_id': '4e4a498a-5ed9-46a1-a9e3-62516034c172',
          'patient_type': 'registered',
          'patient_name': 'Test Patient',
          'patient_phone': '',
          'patient_address': '',
          'shift': 'evening',
          'booking_status': 'confirmed',
          'booking_created_by': '4e4a498a-5ed9-46a1-a9e3-62516034c172',
          'queue_number': '0005',
          'ticket_code': 'TIC-1685',
          'people_before': 4,
          'created_at': '2026-08-16T18:13:47.481047+00:00',
          'updated_at': '2026-08-16T18:13:47.481053+00:00',
          'cancelled_at': null,
          'completed_at': null,
          'cancelled_by': null,
          'cancel_reason': null,
        },
      ];

      final bookings = BookingListMapper.mapRpcResponse(rows);

      expect(bookings, hasLength(1));
      final booking = bookings.first;
      expect(booking.id, '9c6093c6-960f-4453-8623-f2977f9360ae');
      expect(booking.patientId, '4e4a498a-5ed9-46a1-a9e3-62516034c172');
      expect(booking.ticketCode, 'TIC-1685');
      expect(booking.bookingStatus, BookingStatus.confirmed);
      expect(booking.shift, BookingShift.evening);
      expect(booking.queueNumber, '0005');
      expect(booking.peopleBefore, 4);
      expect(
        booking.bookingStatus == BookingStatus.pending ||
            booking.bookingStatus == BookingStatus.confirmed ||
            booking.bookingStatus == BookingStatus.completed ||
            booking.bookingStatus == BookingStatus.noShow,
        isTrue,
      );
      expect(booking.ticketCode?.isNotEmpty, isTrue);
    });

    test('empty list means no bookings, not a hard failure', () {
      expect(BookingListMapper.mapRpcResponse([]), isEmpty);
      expect(BookingListMapper.mapRpcResponse(null), isEmpty);
    });

    test('non-list RPC payload is a hard failure', () {
      expect(
        () => BookingListMapper.mapRpcResponse({'success': false}),
        throwsA(isA<FormatException>()),
      );
    });

    test('normalizes non-string uuid-like fields', () {
      final bookings = BookingListMapper.mapRpcResponse([
        {
          'id': '9c6093c6-960f-4453-8623-f2977f9360ae',
          'booking_date': '2026-08-16T18:13:00.000',
          'patient_id': '4e4a498a-5ed9-46a1-a9e3-62516034c172',
          'patient_type': 'registered',
          'patient_name': 'Self',
          'shift': 'morning',
          'booking_status': 'confirmed',
          'queue_number': 5,
          'ticket_code': 'TIC-1685',
        },
      ]);

      expect(bookings.single.queueNumber, '5');
      expect(bookings.single, isA<BookingModel>());
    });
  });
}
