// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )
    status,
    required TResult Function(String message) error,
    required TResult Function(String message, int? waitSeconds) sessionCooldown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult? Function(String message)? error,
    TResult? Function(String message, int? waitSeconds)? sessionCooldown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult Function(String message)? error,
    TResult Function(String message, int? waitSeconds)? sessionCooldown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Status value) status,
    required TResult Function(Error value) error,
    required TResult Function(SessionCooldown value) sessionCooldown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Status value)? status,
    TResult? Function(Error value)? error,
    TResult? Function(SessionCooldown value)? sessionCooldown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Status value)? status,
    TResult Function(Error value)? error,
    TResult Function(SessionCooldown value)? sessionCooldown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )
    status,
    required TResult Function(String message) error,
    required TResult Function(String message, int? waitSeconds) sessionCooldown,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult? Function(String message)? error,
    TResult? Function(String message, int? waitSeconds)? sessionCooldown,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult Function(String message)? error,
    TResult Function(String message, int? waitSeconds)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Status value) status,
    required TResult Function(Error value) error,
    required TResult Function(SessionCooldown value) sessionCooldown,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Status value)? status,
    TResult? Function(Error value)? error,
    TResult? Function(SessionCooldown value)? sessionCooldown,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Status value)? status,
    TResult Function(Error value)? error,
    TResult Function(SessionCooldown value)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AuthState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'AuthState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )
    status,
    required TResult Function(String message) error,
    required TResult Function(String message, int? waitSeconds) sessionCooldown,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult? Function(String message)? error,
    TResult? Function(String message, int? waitSeconds)? sessionCooldown,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult Function(String message)? error,
    TResult Function(String message, int? waitSeconds)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Status value) status,
    required TResult Function(Error value) error,
    required TResult Function(SessionCooldown value) sessionCooldown,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Status value)? status,
    TResult? Function(Error value)? error,
    TResult? Function(SessionCooldown value)? sessionCooldown,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Status value)? status,
    TResult Function(Error value)? error,
    TResult Function(SessionCooldown value)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements AuthState {
  const factory Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$StatusImplCopyWith<$Res> {
  factory _$$StatusImplCopyWith(
    _$StatusImpl value,
    $Res Function(_$StatusImpl) then,
  ) = __$$StatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthStatus status, AccountStatus? userStatus, UserRole? userRole});
}

/// @nodoc
class __$$StatusImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$StatusImpl>
    implements _$$StatusImplCopyWith<$Res> {
  __$$StatusImplCopyWithImpl(
    _$StatusImpl _value,
    $Res Function(_$StatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? userStatus = freezed,
    Object? userRole = freezed,
  }) {
    return _then(
      _$StatusImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AuthStatus,
        userStatus: freezed == userStatus
            ? _value.userStatus
            : userStatus // ignore: cast_nullable_to_non_nullable
                  as AccountStatus?,
        userRole: freezed == userRole
            ? _value.userRole
            : userRole // ignore: cast_nullable_to_non_nullable
                  as UserRole?,
      ),
    );
  }
}

/// @nodoc

class _$StatusImpl implements Status {
  const _$StatusImpl({required this.status, this.userStatus, this.userRole});

  @override
  final AuthStatus status;
  @override
  final AccountStatus? userStatus;
  @override
  final UserRole? userRole;

  @override
  String toString() {
    return 'AuthState.status(status: $status, userStatus: $userStatus, userRole: $userRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.userStatus, userStatus) ||
                other.userStatus == userStatus) &&
            (identical(other.userRole, userRole) ||
                other.userRole == userRole));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, userStatus, userRole);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusImplCopyWith<_$StatusImpl> get copyWith =>
      __$$StatusImplCopyWithImpl<_$StatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )
    status,
    required TResult Function(String message) error,
    required TResult Function(String message, int? waitSeconds) sessionCooldown,
  }) {
    return status(this.status, userStatus, userRole);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult? Function(String message)? error,
    TResult? Function(String message, int? waitSeconds)? sessionCooldown,
  }) {
    return status?.call(this.status, userStatus, userRole);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult Function(String message)? error,
    TResult Function(String message, int? waitSeconds)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (status != null) {
      return status(this.status, userStatus, userRole);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Status value) status,
    required TResult Function(Error value) error,
    required TResult Function(SessionCooldown value) sessionCooldown,
  }) {
    return status(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Status value)? status,
    TResult? Function(Error value)? error,
    TResult? Function(SessionCooldown value)? sessionCooldown,
  }) {
    return status?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Status value)? status,
    TResult Function(Error value)? error,
    TResult Function(SessionCooldown value)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (status != null) {
      return status(this);
    }
    return orElse();
  }
}

abstract class Status implements AuthState {
  const factory Status({
    required final AuthStatus status,
    final AccountStatus? userStatus,
    final UserRole? userRole,
  }) = _$StatusImpl;

  AuthStatus get status;
  AccountStatus? get userStatus;
  UserRole? get userRole;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusImplCopyWith<_$StatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )
    status,
    required TResult Function(String message) error,
    required TResult Function(String message, int? waitSeconds) sessionCooldown,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult? Function(String message)? error,
    TResult? Function(String message, int? waitSeconds)? sessionCooldown,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult Function(String message)? error,
    TResult Function(String message, int? waitSeconds)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Status value) status,
    required TResult Function(Error value) error,
    required TResult Function(SessionCooldown value) sessionCooldown,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Status value)? status,
    TResult? Function(Error value)? error,
    TResult? Function(SessionCooldown value)? sessionCooldown,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Status value)? status,
    TResult Function(Error value)? error,
    TResult Function(SessionCooldown value)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements AuthState {
  const factory Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SessionCooldownImplCopyWith<$Res> {
  factory _$$SessionCooldownImplCopyWith(
    _$SessionCooldownImpl value,
    $Res Function(_$SessionCooldownImpl) then,
  ) = __$$SessionCooldownImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, int? waitSeconds});
}

/// @nodoc
class __$$SessionCooldownImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$SessionCooldownImpl>
    implements _$$SessionCooldownImplCopyWith<$Res> {
  __$$SessionCooldownImplCopyWithImpl(
    _$SessionCooldownImpl _value,
    $Res Function(_$SessionCooldownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? waitSeconds = freezed}) {
    return _then(
      _$SessionCooldownImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        waitSeconds: freezed == waitSeconds
            ? _value.waitSeconds
            : waitSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$SessionCooldownImpl implements SessionCooldown {
  const _$SessionCooldownImpl({required this.message, this.waitSeconds});

  @override
  final String message;
  @override
  final int? waitSeconds;

  @override
  String toString() {
    return 'AuthState.sessionCooldown(message: $message, waitSeconds: $waitSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionCooldownImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.waitSeconds, waitSeconds) ||
                other.waitSeconds == waitSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, waitSeconds);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionCooldownImplCopyWith<_$SessionCooldownImpl> get copyWith =>
      __$$SessionCooldownImplCopyWithImpl<_$SessionCooldownImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )
    status,
    required TResult Function(String message) error,
    required TResult Function(String message, int? waitSeconds) sessionCooldown,
  }) {
    return sessionCooldown(message, waitSeconds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult? Function(String message)? error,
    TResult? Function(String message, int? waitSeconds)? sessionCooldown,
  }) {
    return sessionCooldown?.call(message, waitSeconds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      AuthStatus status,
      AccountStatus? userStatus,
      UserRole? userRole,
    )?
    status,
    TResult Function(String message)? error,
    TResult Function(String message, int? waitSeconds)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (sessionCooldown != null) {
      return sessionCooldown(message, waitSeconds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Status value) status,
    required TResult Function(Error value) error,
    required TResult Function(SessionCooldown value) sessionCooldown,
  }) {
    return sessionCooldown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Status value)? status,
    TResult? Function(Error value)? error,
    TResult? Function(SessionCooldown value)? sessionCooldown,
  }) {
    return sessionCooldown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Status value)? status,
    TResult Function(Error value)? error,
    TResult Function(SessionCooldown value)? sessionCooldown,
    required TResult orElse(),
  }) {
    if (sessionCooldown != null) {
      return sessionCooldown(this);
    }
    return orElse();
  }
}

abstract class SessionCooldown implements AuthState {
  const factory SessionCooldown({
    required final String message,
    final int? waitSeconds,
  }) = _$SessionCooldownImpl;

  String get message;
  int? get waitSeconds;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionCooldownImplCopyWith<_$SessionCooldownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
