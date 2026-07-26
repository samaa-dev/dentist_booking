// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QueueState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueStateCopyWith<$Res> {
  factory $QueueStateCopyWith(
    QueueState value,
    $Res Function(QueueState) then,
  ) = _$QueueStateCopyWithImpl<$Res, QueueState>;
}

/// @nodoc
class _$QueueStateCopyWithImpl<$Res, $Val extends QueueState>
    implements $QueueStateCopyWith<$Res> {
  _$QueueStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueueState
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
    extends _$QueueStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl with DiagnosticableTreeMixin implements _Initial {
  const _$InitialImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'QueueState.initial'));
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
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
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
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements QueueState {
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
    extends _$QueueStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl with DiagnosticableTreeMixin implements _Loading {
  const _$LoadingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'QueueState.loading'));
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
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
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
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements QueueState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$StatusLoadedImplCopyWith<$Res> {
  factory _$$StatusLoadedImplCopyWith(
    _$StatusLoadedImpl value,
    $Res Function(_$StatusLoadedImpl) then,
  ) = __$$StatusLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({QueueStatusModel status});

  $QueueStatusModelCopyWith<$Res> get status;
}

/// @nodoc
class __$$StatusLoadedImplCopyWithImpl<$Res>
    extends _$QueueStateCopyWithImpl<$Res, _$StatusLoadedImpl>
    implements _$$StatusLoadedImplCopyWith<$Res> {
  __$$StatusLoadedImplCopyWithImpl(
    _$StatusLoadedImpl _value,
    $Res Function(_$StatusLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _$StatusLoadedImpl(
        null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as QueueStatusModel,
      ),
    );
  }

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueueStatusModelCopyWith<$Res> get status {
    return $QueueStatusModelCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value));
    });
  }
}

/// @nodoc

class _$StatusLoadedImpl with DiagnosticableTreeMixin implements _StatusLoaded {
  const _$StatusLoadedImpl(this.status);

  @override
  final QueueStatusModel status;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.statusLoaded(status: $status)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueueState.statusLoaded'))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusLoadedImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusLoadedImplCopyWith<_$StatusLoadedImpl> get copyWith =>
      __$$StatusLoadedImplCopyWithImpl<_$StatusLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return statusLoaded(status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return statusLoaded?.call(status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (statusLoaded != null) {
      return statusLoaded(status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return statusLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return statusLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (statusLoaded != null) {
      return statusLoaded(this);
    }
    return orElse();
  }
}

abstract class _StatusLoaded implements QueueState {
  const factory _StatusLoaded(final QueueStatusModel status) =
      _$StatusLoadedImpl;

  QueueStatusModel get status;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusLoadedImplCopyWith<_$StatusLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NextLoadedImplCopyWith<$Res> {
  factory _$$NextLoadedImplCopyWith(
    _$NextLoadedImpl value,
    $Res Function(_$NextLoadedImpl) then,
  ) = __$$NextLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({QueueModel queue});

  $QueueModelCopyWith<$Res> get queue;
}

/// @nodoc
class __$$NextLoadedImplCopyWithImpl<$Res>
    extends _$QueueStateCopyWithImpl<$Res, _$NextLoadedImpl>
    implements _$$NextLoadedImplCopyWith<$Res> {
  __$$NextLoadedImplCopyWithImpl(
    _$NextLoadedImpl _value,
    $Res Function(_$NextLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? queue = null}) {
    return _then(
      _$NextLoadedImpl(
        null == queue
            ? _value.queue
            : queue // ignore: cast_nullable_to_non_nullable
                  as QueueModel,
      ),
    );
  }

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueueModelCopyWith<$Res> get queue {
    return $QueueModelCopyWith<$Res>(_value.queue, (value) {
      return _then(_value.copyWith(queue: value));
    });
  }
}

/// @nodoc

class _$NextLoadedImpl with DiagnosticableTreeMixin implements _NextLoaded {
  const _$NextLoadedImpl(this.queue);

  @override
  final QueueModel queue;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.nextLoaded(queue: $queue)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueueState.nextLoaded'))
      ..add(DiagnosticsProperty('queue', queue));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextLoadedImpl &&
            (identical(other.queue, queue) || other.queue == queue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, queue);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NextLoadedImplCopyWith<_$NextLoadedImpl> get copyWith =>
      __$$NextLoadedImplCopyWithImpl<_$NextLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return nextLoaded(queue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return nextLoaded?.call(queue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (nextLoaded != null) {
      return nextLoaded(queue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return nextLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return nextLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (nextLoaded != null) {
      return nextLoaded(this);
    }
    return orElse();
  }
}

abstract class _NextLoaded implements QueueState {
  const factory _NextLoaded(final QueueModel queue) = _$NextLoadedImpl;

  QueueModel get queue;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NextLoadedImplCopyWith<_$NextLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StoppedImplCopyWith<$Res> {
  factory _$$StoppedImplCopyWith(
    _$StoppedImpl value,
    $Res Function(_$StoppedImpl) then,
  ) = __$$StoppedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$StoppedImplCopyWithImpl<$Res>
    extends _$QueueStateCopyWithImpl<$Res, _$StoppedImpl>
    implements _$$StoppedImplCopyWith<$Res> {
  __$$StoppedImplCopyWithImpl(
    _$StoppedImpl _value,
    $Res Function(_$StoppedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$StoppedImpl(
        null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$StoppedImpl with DiagnosticableTreeMixin implements _Stopped {
  const _$StoppedImpl(this.reason);

  @override
  final String reason;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.stopped(reason: $reason)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueueState.stopped'))
      ..add(DiagnosticsProperty('reason', reason));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoppedImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoppedImplCopyWith<_$StoppedImpl> get copyWith =>
      __$$StoppedImplCopyWithImpl<_$StoppedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return stopped(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return stopped?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return stopped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return stopped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (stopped != null) {
      return stopped(this);
    }
    return orElse();
  }
}

abstract class _Stopped implements QueueState {
  const factory _Stopped(final String reason) = _$StoppedImpl;

  String get reason;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoppedImplCopyWith<_$StoppedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProcessingImplCopyWith<$Res> {
  factory _$$ProcessingImplCopyWith(
    _$ProcessingImpl value,
    $Res Function(_$ProcessingImpl) then,
  ) = __$$ProcessingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProcessingImplCopyWithImpl<$Res>
    extends _$QueueStateCopyWithImpl<$Res, _$ProcessingImpl>
    implements _$$ProcessingImplCopyWith<$Res> {
  __$$ProcessingImplCopyWithImpl(
    _$ProcessingImpl _value,
    $Res Function(_$ProcessingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProcessingImpl with DiagnosticableTreeMixin implements _Processing {
  const _$ProcessingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.processing()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'QueueState.processing'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProcessingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return processing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return processing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return processing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return processing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing(this);
    }
    return orElse();
  }
}

abstract class _Processing implements QueueState {
  const factory _Processing() = _$ProcessingImpl;
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
    extends _$QueueStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl with DiagnosticableTreeMixin implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.error(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueueState.error'))
      ..add(DiagnosticsProperty('message', message));
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

  /// Create a copy of QueueState
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
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
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
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements QueueState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorUpdateBookingImplCopyWith<$Res> {
  factory _$$ErrorUpdateBookingImplCopyWith(
    _$ErrorUpdateBookingImpl value,
    $Res Function(_$ErrorUpdateBookingImpl) then,
  ) = __$$ErrorUpdateBookingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorUpdateBookingImplCopyWithImpl<$Res>
    extends _$QueueStateCopyWithImpl<$Res, _$ErrorUpdateBookingImpl>
    implements _$$ErrorUpdateBookingImplCopyWith<$Res> {
  __$$ErrorUpdateBookingImplCopyWithImpl(
    _$ErrorUpdateBookingImpl _value,
    $Res Function(_$ErrorUpdateBookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorUpdateBookingImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorUpdateBookingImpl
    with DiagnosticableTreeMixin
    implements ErrorUpdateBooking {
  const _$ErrorUpdateBookingImpl(this.message);

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.errorUpdateBooking(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueueState.errorUpdateBooking'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorUpdateBookingImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorUpdateBookingImplCopyWith<_$ErrorUpdateBookingImpl> get copyWith =>
      __$$ErrorUpdateBookingImplCopyWithImpl<_$ErrorUpdateBookingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return errorUpdateBooking(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return errorUpdateBooking?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (errorUpdateBooking != null) {
      return errorUpdateBooking(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return errorUpdateBooking(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return errorUpdateBooking?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (errorUpdateBooking != null) {
      return errorUpdateBooking(this);
    }
    return orElse();
  }
}

abstract class ErrorUpdateBooking implements QueueState {
  const factory ErrorUpdateBooking(final String message) =
      _$ErrorUpdateBookingImpl;

  String get message;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorUpdateBookingImplCopyWith<_$ErrorUpdateBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessUpdateBookingImplCopyWith<$Res> {
  factory _$$SuccessUpdateBookingImplCopyWith(
    _$SuccessUpdateBookingImpl value,
    $Res Function(_$SuccessUpdateBookingImpl) then,
  ) = __$$SuccessUpdateBookingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BookingModel booking});

  $BookingModelCopyWith<$Res> get booking;
}

/// @nodoc
class __$$SuccessUpdateBookingImplCopyWithImpl<$Res>
    extends _$QueueStateCopyWithImpl<$Res, _$SuccessUpdateBookingImpl>
    implements _$$SuccessUpdateBookingImplCopyWith<$Res> {
  __$$SuccessUpdateBookingImplCopyWithImpl(
    _$SuccessUpdateBookingImpl _value,
    $Res Function(_$SuccessUpdateBookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? booking = null}) {
    return _then(
      _$SuccessUpdateBookingImpl(
        null == booking
            ? _value.booking
            : booking // ignore: cast_nullable_to_non_nullable
                  as BookingModel,
      ),
    );
  }

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingModelCopyWith<$Res> get booking {
    return $BookingModelCopyWith<$Res>(_value.booking, (value) {
      return _then(_value.copyWith(booking: value));
    });
  }
}

/// @nodoc

class _$SuccessUpdateBookingImpl
    with DiagnosticableTreeMixin
    implements SuccessUpdateBooking {
  const _$SuccessUpdateBookingImpl(this.booking);

  @override
  final BookingModel booking;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QueueState.successUpdateBooking(booking: $booking)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QueueState.successUpdateBooking'))
      ..add(DiagnosticsProperty('booking', booking));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessUpdateBookingImpl &&
            (identical(other.booking, booking) || other.booking == booking));
  }

  @override
  int get hashCode => Object.hash(runtimeType, booking);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessUpdateBookingImplCopyWith<_$SuccessUpdateBookingImpl>
  get copyWith =>
      __$$SuccessUpdateBookingImplCopyWithImpl<_$SuccessUpdateBookingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(QueueStatusModel status) statusLoaded,
    required TResult Function(QueueModel queue) nextLoaded,
    required TResult Function(String reason) stopped,
    required TResult Function() processing,
    required TResult Function(String message) error,
    required TResult Function(String message) errorUpdateBooking,
    required TResult Function(BookingModel booking) successUpdateBooking,
  }) {
    return successUpdateBooking(booking);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(QueueStatusModel status)? statusLoaded,
    TResult? Function(QueueModel queue)? nextLoaded,
    TResult? Function(String reason)? stopped,
    TResult? Function()? processing,
    TResult? Function(String message)? error,
    TResult? Function(String message)? errorUpdateBooking,
    TResult? Function(BookingModel booking)? successUpdateBooking,
  }) {
    return successUpdateBooking?.call(booking);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(QueueStatusModel status)? statusLoaded,
    TResult Function(QueueModel queue)? nextLoaded,
    TResult Function(String reason)? stopped,
    TResult Function()? processing,
    TResult Function(String message)? error,
    TResult Function(String message)? errorUpdateBooking,
    TResult Function(BookingModel booking)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (successUpdateBooking != null) {
      return successUpdateBooking(booking);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_StatusLoaded value) statusLoaded,
    required TResult Function(_NextLoaded value) nextLoaded,
    required TResult Function(_Stopped value) stopped,
    required TResult Function(_Processing value) processing,
    required TResult Function(_Error value) error,
    required TResult Function(ErrorUpdateBooking value) errorUpdateBooking,
    required TResult Function(SuccessUpdateBooking value) successUpdateBooking,
  }) {
    return successUpdateBooking(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_StatusLoaded value)? statusLoaded,
    TResult? Function(_NextLoaded value)? nextLoaded,
    TResult? Function(_Stopped value)? stopped,
    TResult? Function(_Processing value)? processing,
    TResult? Function(_Error value)? error,
    TResult? Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult? Function(SuccessUpdateBooking value)? successUpdateBooking,
  }) {
    return successUpdateBooking?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_StatusLoaded value)? statusLoaded,
    TResult Function(_NextLoaded value)? nextLoaded,
    TResult Function(_Stopped value)? stopped,
    TResult Function(_Processing value)? processing,
    TResult Function(_Error value)? error,
    TResult Function(ErrorUpdateBooking value)? errorUpdateBooking,
    TResult Function(SuccessUpdateBooking value)? successUpdateBooking,
    required TResult orElse(),
  }) {
    if (successUpdateBooking != null) {
      return successUpdateBooking(this);
    }
    return orElse();
  }
}

abstract class SuccessUpdateBooking implements QueueState {
  const factory SuccessUpdateBooking(final BookingModel booking) =
      _$SuccessUpdateBookingImpl;

  BookingModel get booking;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessUpdateBookingImplCopyWith<_$SuccessUpdateBookingImpl>
  get copyWith => throw _privateConstructorUsedError;
}
