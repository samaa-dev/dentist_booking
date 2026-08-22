import 'dart:async';

import 'package:dentist_booking_admin/core/services/session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postgrest/postgrest.dart';

void main() {
  group('SessionService', () {
    late SessionService sessionService;

    setUp(() {
      sessionService = SessionService();
    });

    tearDown(() {
      sessionService.dispose();
    });

    test('handleIfExpired emits onExpired for JWT errors', () async {
      const error = PostgrestException(
        message: 'JWT expired',
        code: 'PGRST303',
        details: 'Unauthorized',
      );

      final events = <void>[];
      sessionService.onExpired.listen((_) => events.add(null));

      expect(sessionService.handleIfExpired(error), isTrue);

      await Future<void>.delayed(Duration.zero);
      expect(events, hasLength(1));
    });

    test('handleIfExpired returns false for unrelated errors', () {
      expect(
        sessionService.handleIfExpired(Exception('network timeout')),
        isFalse,
      );
    });
  });
}
