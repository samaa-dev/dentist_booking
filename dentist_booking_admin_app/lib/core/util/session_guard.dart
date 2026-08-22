// ignore_for_file: depend_on_referenced_packages

import 'package:gotrue/gotrue.dart';
import 'package:postgrest/postgrest.dart';

import 'session_expired_exception.dart';

class SessionGuard {
  SessionGuard._();

  static bool isAuthError(Object error) {
    if (error is SessionExpiredException) return true;

    if (error is PostgrestException) {
      final message = error.message.toLowerCase();
      return error.code == 'PGRST303' ||
          message.contains('jwt expired') ||
          message.contains('invalid jwt');
    }

    if (error is AuthException) return true;

    final msg = error.toString().toLowerCase();
    return msg.contains('pgrst303') || msg.contains('jwt expired');
  }

  /// Returns [SessionExpiredException] when [error] is auth-related, else null.
  static SessionExpiredException? asSessionExpired(Object error) {
    if (error is SessionExpiredException) return error;
    if (isAuthError(error)) return SessionExpiredException(cause: error);
    return null;
  }
}
