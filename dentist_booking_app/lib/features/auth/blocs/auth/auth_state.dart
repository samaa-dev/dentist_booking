part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loading() = Loading;

  const factory AuthState.status({
    required AuthStatus status,
    AccountStatus? userStatus,
    UserRole? userRole,
    TypeLogin? typeLogin,
    dynamic data,
  }) = Status;

  const factory AuthState.error({
    required String message,
  }) = Error;

  const factory AuthState.sessionCooldown({
    required String message,
    int? waitSeconds,
  }) = SessionCooldown;
}
