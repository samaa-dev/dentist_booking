// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_count_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BookingCountState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Map<BookingStatus, int> counts) statusCounts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Map<BookingStatus, int> counts)? statusCounts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Map<BookingStatus, int> counts)? statusCounts,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_StatusCounts value) statusCounts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_StatusCounts value)? statusCounts,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_StatusCounts value)? statusCounts,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCountStateCopyWith<$Res> {
  factory $BookingCountStateCopyWith(
    BookingCountState value,
    $Res Function(BookingCountState) then,
  ) = _$BookingCountStateCopyWithImpl<$Res, BookingCountState>;
}

/// @nodoc
class _$BookingCountStateCopyWithImpl<$Res, $Val extends BookingCountState>
    implements $BookingCountStateCopyWith<$Res> {
  _$BookingCountStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingCountState
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
    extends _$BookingCountStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingCountState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'BookingCountState.initial()';
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
    required TResult Function(Map<BookingStatus, int> counts) statusCounts,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Map<BookingStatus, int> counts)? statusCounts,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Map<BookingStatus, int> counts)? statusCounts,
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
    required TResult Function(_StatusCounts value) statusCounts,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_StatusCounts value)? statusCounts,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_StatusCounts value)? statusCounts,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements BookingCountState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$StatusCountsImplCopyWith<$Res> {
  factory _$$StatusCountsImplCopyWith(
    _$StatusCountsImpl value,
    $Res Function(_$StatusCountsImpl) then,
  ) = __$$StatusCountsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<BookingStatus, int> counts});
}

/// @nodoc
class __$$StatusCountsImplCopyWithImpl<$Res>
    extends _$BookingCountStateCopyWithImpl<$Res, _$StatusCountsImpl>
    implements _$$StatusCountsImplCopyWith<$Res> {
  __$$StatusCountsImplCopyWithImpl(
    _$StatusCountsImpl _value,
    $Res Function(_$StatusCountsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingCountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? counts = null}) {
    return _then(
      _$StatusCountsImpl(
        null == counts
            ? _value._counts
            : counts // ignore: cast_nullable_to_non_nullable
                  as Map<BookingStatus, int>,
      ),
    );
  }
}

/// @nodoc

class _$StatusCountsImpl implements _StatusCounts {
  const _$StatusCountsImpl(final Map<BookingStatus, int> counts)
    : _counts = counts;

  final Map<BookingStatus, int> _counts;
  @override
  Map<BookingStatus, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_counts);
  }

  @override
  String toString() {
    return 'BookingCountState.statusCounts(counts: $counts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusCountsImpl &&
            const DeepCollectionEquality().equals(other._counts, _counts));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_counts));

  /// Create a copy of BookingCountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusCountsImplCopyWith<_$StatusCountsImpl> get copyWith =>
      __$$StatusCountsImplCopyWithImpl<_$StatusCountsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Map<BookingStatus, int> counts) statusCounts,
  }) {
    return statusCounts(counts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Map<BookingStatus, int> counts)? statusCounts,
  }) {
    return statusCounts?.call(counts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Map<BookingStatus, int> counts)? statusCounts,
    required TResult orElse(),
  }) {
    if (statusCounts != null) {
      return statusCounts(counts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_StatusCounts value) statusCounts,
  }) {
    return statusCounts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_StatusCounts value)? statusCounts,
  }) {
    return statusCounts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_StatusCounts value)? statusCounts,
    required TResult orElse(),
  }) {
    if (statusCounts != null) {
      return statusCounts(this);
    }
    return orElse();
  }
}

abstract class _StatusCounts implements BookingCountState {
  const factory _StatusCounts(final Map<BookingStatus, int> counts) =
      _$StatusCountsImpl;

  Map<BookingStatus, int> get counts;

  /// Create a copy of BookingCountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusCountsImplCopyWith<_$StatusCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
