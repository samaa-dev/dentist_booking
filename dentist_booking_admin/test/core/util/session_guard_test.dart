import 'package:dentist_booking_admin/core/util/session_expired_exception.dart';
import 'package:dentist_booking_admin/core/util/session_guard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postgrest/postgrest.dart';

void main() {
  group('SessionGuard', () {
    test('detects PostgrestException PGRST303', () {
      const error = PostgrestException(
        message: 'JWT expired',
        code: 'PGRST303',
        details: 'Unauthorized',
      );

      expect(SessionGuard.isAuthError(error), isTrue);
      expect(SessionGuard.asSessionExpired(error), isA<SessionExpiredException>());
    });

    test('detects wrapped JWT expired message', () {
      final error = Exception(
        'Failed to create booking: PostgrestException(message: JWT expired, code: PGRST303)',
      );

      expect(SessionGuard.isAuthError(error), isTrue);
    });

    test('ignores unrelated errors', () {
      expect(SessionGuard.isAuthError(Exception('network timeout')), isFalse);
      expect(SessionGuard.asSessionExpired(Exception('network timeout')), isNull);
    });
  });
}
