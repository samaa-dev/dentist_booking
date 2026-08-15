// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingStatusModel _$BookingStatusModelFromJson(Map<String, dynamic> json) {
  return _$BookingStatusModelImpl.fromJson(json);
}

/// @nodoc
mixin _$BookingStatusModel {
  @JsonKey(name: 'is_open')
  bool? get isOpen => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift')
  BookingShift? get shift => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_left')
  int? get timeLeft => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_booking_enabled')
  bool? get isBookingEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_reason')
  String? get stopReason => throw _privateConstructorUsedError;

  /// When set, the current clock window's shift is closed for booking.
  @JsonKey(name: 'shift_closed')
  BookingShift? get shiftClosed => throw _privateConstructorUsedError;

  /// Legacy: set only when no remaining bookable shift (blocks old clients).
  @JsonKey(name: 'shift_full')
  BookingShift? get shiftFull => throw _privateConstructorUsedError;
  @JsonKey(name: 'morning_full')
  bool? get morningFull => throw _privateConstructorUsedError;
  @JsonKey(name: 'evening_full')
  bool? get eveningFull => throw _privateConstructorUsedError;
  @JsonKey(name: 'morning_available')
  bool? get morningAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'evening_available')
  bool? get eveningAvailable => throw _privateConstructorUsedError;

  /// Serializes this BookingStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingStatusModelCopyWith<BookingStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingStatusModelCopyWith<$Res> {
  factory $BookingStatusModelCopyWith(
    BookingStatusModel value,
    $Res Function(BookingStatusModel) then,
  ) = _$BookingStatusModelCopyWithImpl<$Res, BookingStatusModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'shift') BookingShift? shift,
    @JsonKey(name: 'time_left') int? timeLeft,
    @JsonKey(name: 'is_booking_enabled') bool? isBookingEnabled,
    @JsonKey(name: 'stop_reason') String? stopReason,
    @JsonKey(name: 'shift_closed') BookingShift? shiftClosed,
    @JsonKey(name: 'shift_full') BookingShift? shiftFull,
    @JsonKey(name: 'morning_full') bool? morningFull,
    @JsonKey(name: 'evening_full') bool? eveningFull,
    @JsonKey(name: 'morning_available') bool? morningAvailable,
    @JsonKey(name: 'evening_available') bool? eveningAvailable,
  });
}

/// @nodoc
class _$BookingStatusModelCopyWithImpl<$Res, $Val extends BookingStatusModel>
    implements $BookingStatusModelCopyWith<$Res> {
  _$BookingStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpen = freezed,
    Object? shift = freezed,
    Object? timeLeft = freezed,
    Object? isBookingEnabled = freezed,
    Object? stopReason = freezed,
    Object? shiftClosed = freezed,
    Object? shiftFull = freezed,
    Object? morningFull = freezed,
    Object? eveningFull = freezed,
    Object? morningAvailable = freezed,
    Object? eveningAvailable = freezed,
  }) {
    return _then(
      _value.copyWith(
            isOpen: freezed == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool?,
            shift: freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as BookingShift?,
            timeLeft: freezed == timeLeft
                ? _value.timeLeft
                : timeLeft // ignore: cast_nullable_to_non_nullable
                      as int?,
            isBookingEnabled: freezed == isBookingEnabled
                ? _value.isBookingEnabled
                : isBookingEnabled // ignore: cast_nullable_to_non_nullable
                      as bool?,
            stopReason: freezed == stopReason
                ? _value.stopReason
                : stopReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            shiftClosed: freezed == shiftClosed
                ? _value.shiftClosed
                : shiftClosed // ignore: cast_nullable_to_non_nullable
                      as BookingShift?,
            shiftFull: freezed == shiftFull
                ? _value.shiftFull
                : shiftFull // ignore: cast_nullable_to_non_nullable
                      as BookingShift?,
            morningFull: freezed == morningFull
                ? _value.morningFull
                : morningFull // ignore: cast_nullable_to_non_nullable
                      as bool?,
            eveningFull: freezed == eveningFull
                ? _value.eveningFull
                : eveningFull // ignore: cast_nullable_to_non_nullable
                      as bool?,
            morningAvailable: freezed == morningAvailable
                ? _value.morningAvailable
                : morningAvailable // ignore: cast_nullable_to_non_nullable
                      as bool?,
            eveningAvailable: freezed == eveningAvailable
                ? _value.eveningAvailable
                : eveningAvailable // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$$BookingStatusModelImplImplCopyWith<$Res>
    implements $BookingStatusModelCopyWith<$Res> {
  factory _$$$BookingStatusModelImplImplCopyWith(
    _$$BookingStatusModelImplImpl value,
    $Res Function(_$$BookingStatusModelImplImpl) then,
  ) = __$$$BookingStatusModelImplImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'shift') BookingShift? shift,
    @JsonKey(name: 'time_left') int? timeLeft,
    @JsonKey(name: 'is_booking_enabled') bool? isBookingEnabled,
    @JsonKey(name: 'stop_reason') String? stopReason,
    @JsonKey(name: 'shift_closed') BookingShift? shiftClosed,
    @JsonKey(name: 'shift_full') BookingShift? shiftFull,
    @JsonKey(name: 'morning_full') bool? morningFull,
    @JsonKey(name: 'evening_full') bool? eveningFull,
    @JsonKey(name: 'morning_available') bool? morningAvailable,
    @JsonKey(name: 'evening_available') bool? eveningAvailable,
  });
}

/// @nodoc
class __$$$BookingStatusModelImplImplCopyWithImpl<$Res>
    extends
        _$BookingStatusModelCopyWithImpl<$Res, _$$BookingStatusModelImplImpl>
    implements _$$$BookingStatusModelImplImplCopyWith<$Res> {
  __$$$BookingStatusModelImplImplCopyWithImpl(
    _$$BookingStatusModelImplImpl _value,
    $Res Function(_$$BookingStatusModelImplImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpen = freezed,
    Object? shift = freezed,
    Object? timeLeft = freezed,
    Object? isBookingEnabled = freezed,
    Object? stopReason = freezed,
    Object? shiftClosed = freezed,
    Object? shiftFull = freezed,
    Object? morningFull = freezed,
    Object? eveningFull = freezed,
    Object? morningAvailable = freezed,
    Object? eveningAvailable = freezed,
  }) {
    return _then(
      _$$BookingStatusModelImplImpl(
        isOpen: freezed == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        shift: freezed == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as BookingShift?,
        timeLeft: freezed == timeLeft
            ? _value.timeLeft
            : timeLeft // ignore: cast_nullable_to_non_nullable
                  as int?,
        isBookingEnabled: freezed == isBookingEnabled
            ? _value.isBookingEnabled
            : isBookingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        stopReason: freezed == stopReason
            ? _value.stopReason
            : stopReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        shiftClosed: freezed == shiftClosed
            ? _value.shiftClosed
            : shiftClosed // ignore: cast_nullable_to_non_nullable
                  as BookingShift?,
        shiftFull: freezed == shiftFull
            ? _value.shiftFull
            : shiftFull // ignore: cast_nullable_to_non_nullable
                  as BookingShift?,
        morningFull: freezed == morningFull
            ? _value.morningFull
            : morningFull // ignore: cast_nullable_to_non_nullable
                  as bool?,
        eveningFull: freezed == eveningFull
            ? _value.eveningFull
            : eveningFull // ignore: cast_nullable_to_non_nullable
                  as bool?,
        morningAvailable: freezed == morningAvailable
            ? _value.morningAvailable
            : morningAvailable // ignore: cast_nullable_to_non_nullable
                  as bool?,
        eveningAvailable: freezed == eveningAvailable
            ? _value.eveningAvailable
            : eveningAvailable // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$$BookingStatusModelImplImpl extends _$BookingStatusModelImpl {
  const _$$BookingStatusModelImplImpl({
    @JsonKey(name: 'is_open') this.isOpen,
    @JsonKey(name: 'shift') this.shift,
    @JsonKey(name: 'time_left') this.timeLeft,
    @JsonKey(name: 'is_booking_enabled') this.isBookingEnabled,
    @JsonKey(name: 'stop_reason') this.stopReason,
    @JsonKey(name: 'shift_closed') this.shiftClosed,
    @JsonKey(name: 'shift_full') this.shiftFull,
    @JsonKey(name: 'morning_full') this.morningFull,
    @JsonKey(name: 'evening_full') this.eveningFull,
    @JsonKey(name: 'morning_available') this.morningAvailable,
    @JsonKey(name: 'evening_available') this.eveningAvailable,
  }) : super._();

  factory _$$BookingStatusModelImplImpl.fromJson(Map<String, dynamic> json) =>
      _$$$BookingStatusModelImplImplFromJson(json);

  @override
  @JsonKey(name: 'is_open')
  final bool? isOpen;
  @override
  @JsonKey(name: 'shift')
  final BookingShift? shift;
  @override
  @JsonKey(name: 'time_left')
  final int? timeLeft;
  @override
  @JsonKey(name: 'is_booking_enabled')
  final bool? isBookingEnabled;
  @override
  @JsonKey(name: 'stop_reason')
  final String? stopReason;

  /// When set, the current clock window's shift is closed for booking.
  @override
  @JsonKey(name: 'shift_closed')
  final BookingShift? shiftClosed;

  /// Legacy: set only when no remaining bookable shift (blocks old clients).
  @override
  @JsonKey(name: 'shift_full')
  final BookingShift? shiftFull;
  @override
  @JsonKey(name: 'morning_full')
  final bool? morningFull;
  @override
  @JsonKey(name: 'evening_full')
  final bool? eveningFull;
  @override
  @JsonKey(name: 'morning_available')
  final bool? morningAvailable;
  @override
  @JsonKey(name: 'evening_available')
  final bool? eveningAvailable;

  @override
  String toString() {
    return 'BookingStatusModel(isOpen: $isOpen, shift: $shift, timeLeft: $timeLeft, isBookingEnabled: $isBookingEnabled, stopReason: $stopReason, shiftClosed: $shiftClosed, shiftFull: $shiftFull, morningFull: $morningFull, eveningFull: $eveningFull, morningAvailable: $morningAvailable, eveningAvailable: $eveningAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$BookingStatusModelImplImpl &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.timeLeft, timeLeft) ||
                other.timeLeft == timeLeft) &&
            (identical(other.isBookingEnabled, isBookingEnabled) ||
                other.isBookingEnabled == isBookingEnabled) &&
            (identical(other.stopReason, stopReason) ||
                other.stopReason == stopReason) &&
            (identical(other.shiftClosed, shiftClosed) ||
                other.shiftClosed == shiftClosed) &&
            (identical(other.shiftFull, shiftFull) ||
                other.shiftFull == shiftFull) &&
            (identical(other.morningFull, morningFull) ||
                other.morningFull == morningFull) &&
            (identical(other.eveningFull, eveningFull) ||
                other.eveningFull == eveningFull) &&
            (identical(other.morningAvailable, morningAvailable) ||
                other.morningAvailable == morningAvailable) &&
            (identical(other.eveningAvailable, eveningAvailable) ||
                other.eveningAvailable == eveningAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isOpen,
    shift,
    timeLeft,
    isBookingEnabled,
    stopReason,
    shiftClosed,
    shiftFull,
    morningFull,
    eveningFull,
    morningAvailable,
    eveningAvailable,
  );

  /// Create a copy of BookingStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$$BookingStatusModelImplImplCopyWith<_$$BookingStatusModelImplImpl>
  get copyWith =>
      __$$$BookingStatusModelImplImplCopyWithImpl<
        _$$BookingStatusModelImplImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$$BookingStatusModelImplImplToJson(this);
  }
}

abstract class _$BookingStatusModelImpl extends BookingStatusModel {
  const factory _$BookingStatusModelImpl({
    @JsonKey(name: 'is_open') final bool? isOpen,
    @JsonKey(name: 'shift') final BookingShift? shift,
    @JsonKey(name: 'time_left') final int? timeLeft,
    @JsonKey(name: 'is_booking_enabled') final bool? isBookingEnabled,
    @JsonKey(name: 'stop_reason') final String? stopReason,
    @JsonKey(name: 'shift_closed') final BookingShift? shiftClosed,
    @JsonKey(name: 'shift_full') final BookingShift? shiftFull,
    @JsonKey(name: 'morning_full') final bool? morningFull,
    @JsonKey(name: 'evening_full') final bool? eveningFull,
    @JsonKey(name: 'morning_available') final bool? morningAvailable,
    @JsonKey(name: 'evening_available') final bool? eveningAvailable,
  }) = _$$BookingStatusModelImplImpl;
  const _$BookingStatusModelImpl._() : super._();

  factory _$BookingStatusModelImpl.fromJson(Map<String, dynamic> json) =
      _$$BookingStatusModelImplImpl.fromJson;

  @override
  @JsonKey(name: 'is_open')
  bool? get isOpen;
  @override
  @JsonKey(name: 'shift')
  BookingShift? get shift;
  @override
  @JsonKey(name: 'time_left')
  int? get timeLeft;
  @override
  @JsonKey(name: 'is_booking_enabled')
  bool? get isBookingEnabled;
  @override
  @JsonKey(name: 'stop_reason')
  String? get stopReason;

  /// When set, the current clock window's shift is closed for booking.
  @override
  @JsonKey(name: 'shift_closed')
  BookingShift? get shiftClosed;

  /// Legacy: set only when no remaining bookable shift (blocks old clients).
  @override
  @JsonKey(name: 'shift_full')
  BookingShift? get shiftFull;
  @override
  @JsonKey(name: 'morning_full')
  bool? get morningFull;
  @override
  @JsonKey(name: 'evening_full')
  bool? get eveningFull;
  @override
  @JsonKey(name: 'morning_available')
  bool? get morningAvailable;
  @override
  @JsonKey(name: 'evening_available')
  bool? get eveningAvailable;

  /// Create a copy of BookingStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$$BookingStatusModelImplImplCopyWith<_$$BookingStatusModelImplImpl>
  get copyWith => throw _privateConstructorUsedError;
}
