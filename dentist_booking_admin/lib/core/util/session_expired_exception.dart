class SessionExpiredException implements Exception {
  SessionExpiredException({this.cause});

  final Object? cause;

  @override
  String toString() => 'SessionExpiredException(cause: $cause)';
}
