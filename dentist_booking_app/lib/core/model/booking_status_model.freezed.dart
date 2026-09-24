// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
BookingStatusModel _$BookingStatusModelFromJson(
  Map<String, dynamic> json
) {
    return _$BookingStatusModelImpl.fromJson(
      json
    );
}

/// @nodoc
mixin _$BookingStatusModel {

@JsonKey(name: 'is_open') bool? get isOpen;@JsonKey(name: 'shift') BookingShift? get shift;@JsonKey(name: 'time_left') int? get timeLeft;@JsonKey(name: 'is_booking_enabled') bool? get isBookingEnabled;@JsonKey(name: 'stop_reason') String? get stopReason;/// When set, the current clock window's shift is closed for booking.
@JsonKey(name: 'shift_closed') BookingShift? get shiftClosed;/// Legacy: set only when no remaining bookable shift (blocks old clients).
@JsonKey(name: 'shift_full') BookingShift? get shiftFull;@JsonKey(name: 'morning_full') bool? get morningFull;@JsonKey(name: 'evening_full') bool? get eveningFull;@JsonKey(name: 'morning_available') bool? get morningAvailable;@JsonKey(name: 'evening_available') bool? get eveningAvailable;/// Clinic morning booking open time as HH:MM (from get_booking_status).
@JsonKey(name: 'booking_morning_start_time') String? get bookingMorningStartTime;
/// Create a copy of BookingStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingStatusModelCopyWith<BookingStatusModel> get copyWith => _$BookingStatusModelCopyWithImpl<BookingStatusModel>(this as BookingStatusModel, _$identity);

  /// Serializes this BookingStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingStatusModel&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.timeLeft, timeLeft) || other.timeLeft == timeLeft)&&(identical(other.isBookingEnabled, isBookingEnabled) || other.isBookingEnabled == isBookingEnabled)&&(identical(other.stopReason, stopReason) || other.stopReason == stopReason)&&(identical(other.shiftClosed, shiftClosed) || other.shiftClosed == shiftClosed)&&(identical(other.shiftFull, shiftFull) || other.shiftFull == shiftFull)&&(identical(other.morningFull, morningFull) || other.morningFull == morningFull)&&(identical(other.eveningFull, eveningFull) || other.eveningFull == eveningFull)&&(identical(other.morningAvailable, morningAvailable) || other.morningAvailable == morningAvailable)&&(identical(other.eveningAvailable, eveningAvailable) || other.eveningAvailable == eveningAvailable)&&(identical(other.bookingMorningStartTime, bookingMorningStartTime) || other.bookingMorningStartTime == bookingMorningStartTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOpen,shift,timeLeft,isBookingEnabled,stopReason,shiftClosed,shiftFull,morningFull,eveningFull,morningAvailable,eveningAvailable,bookingMorningStartTime);

@override
String toString() {
  return 'BookingStatusModel(isOpen: $isOpen, shift: $shift, timeLeft: $timeLeft, isBookingEnabled: $isBookingEnabled, stopReason: $stopReason, shiftClosed: $shiftClosed, shiftFull: $shiftFull, morningFull: $morningFull, eveningFull: $eveningFull, morningAvailable: $morningAvailable, eveningAvailable: $eveningAvailable, bookingMorningStartTime: $bookingMorningStartTime)';
}


}

/// @nodoc
abstract mixin class $BookingStatusModelCopyWith<$Res>  {
  factory $BookingStatusModelCopyWith(BookingStatusModel value, $Res Function(BookingStatusModel) _then) = _$BookingStatusModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_open') bool? isOpen,@JsonKey(name: 'shift') BookingShift? shift,@JsonKey(name: 'time_left') int? timeLeft,@JsonKey(name: 'is_booking_enabled') bool? isBookingEnabled,@JsonKey(name: 'stop_reason') String? stopReason,@JsonKey(name: 'shift_closed') BookingShift? shiftClosed,@JsonKey(name: 'shift_full') BookingShift? shiftFull,@JsonKey(name: 'morning_full') bool? morningFull,@JsonKey(name: 'evening_full') bool? eveningFull,@JsonKey(name: 'morning_available') bool? morningAvailable,@JsonKey(name: 'evening_available') bool? eveningAvailable,@JsonKey(name: 'booking_morning_start_time') String? bookingMorningStartTime
});




}
/// @nodoc
class _$BookingStatusModelCopyWithImpl<$Res>
    implements $BookingStatusModelCopyWith<$Res> {
  _$BookingStatusModelCopyWithImpl(this._self, this._then);

  final BookingStatusModel _self;
  final $Res Function(BookingStatusModel) _then;

/// Create a copy of BookingStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOpen = freezed,Object? shift = freezed,Object? timeLeft = freezed,Object? isBookingEnabled = freezed,Object? stopReason = freezed,Object? shiftClosed = freezed,Object? shiftFull = freezed,Object? morningFull = freezed,Object? eveningFull = freezed,Object? morningAvailable = freezed,Object? eveningAvailable = freezed,Object? bookingMorningStartTime = freezed,}) {
  return _then(_self.copyWith(
isOpen: freezed == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool?,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as BookingShift?,timeLeft: freezed == timeLeft ? _self.timeLeft : timeLeft // ignore: cast_nullable_to_non_nullable
as int?,isBookingEnabled: freezed == isBookingEnabled ? _self.isBookingEnabled : isBookingEnabled // ignore: cast_nullable_to_non_nullable
as bool?,stopReason: freezed == stopReason ? _self.stopReason : stopReason // ignore: cast_nullable_to_non_nullable
as String?,shiftClosed: freezed == shiftClosed ? _self.shiftClosed : shiftClosed // ignore: cast_nullable_to_non_nullable
as BookingShift?,shiftFull: freezed == shiftFull ? _self.shiftFull : shiftFull // ignore: cast_nullable_to_non_nullable
as BookingShift?,morningFull: freezed == morningFull ? _self.morningFull : morningFull // ignore: cast_nullable_to_non_nullable
as bool?,eveningFull: freezed == eveningFull ? _self.eveningFull : eveningFull // ignore: cast_nullable_to_non_nullable
as bool?,morningAvailable: freezed == morningAvailable ? _self.morningAvailable : morningAvailable // ignore: cast_nullable_to_non_nullable
as bool?,eveningAvailable: freezed == eveningAvailable ? _self.eveningAvailable : eveningAvailable // ignore: cast_nullable_to_non_nullable
as bool?,bookingMorningStartTime: freezed == bookingMorningStartTime ? _self.bookingMorningStartTime : bookingMorningStartTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingStatusModel].
extension BookingStatusModelPatterns on BookingStatusModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _$BookingStatusModelImpl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _$BookingStatusModelImpl() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _$BookingStatusModelImpl value)  $default,){
final _that = this;
switch (_that) {
case _$BookingStatusModelImpl():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _$BookingStatusModelImpl value)?  $default,){
final _that = this;
switch (_that) {
case _$BookingStatusModelImpl() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_open')  bool? isOpen, @JsonKey(name: 'shift')  BookingShift? shift, @JsonKey(name: 'time_left')  int? timeLeft, @JsonKey(name: 'is_booking_enabled')  bool? isBookingEnabled, @JsonKey(name: 'stop_reason')  String? stopReason, @JsonKey(name: 'shift_closed')  BookingShift? shiftClosed, @JsonKey(name: 'shift_full')  BookingShift? shiftFull, @JsonKey(name: 'morning_full')  bool? morningFull, @JsonKey(name: 'evening_full')  bool? eveningFull, @JsonKey(name: 'morning_available')  bool? morningAvailable, @JsonKey(name: 'evening_available')  bool? eveningAvailable, @JsonKey(name: 'booking_morning_start_time')  String? bookingMorningStartTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _$BookingStatusModelImpl() when $default != null:
return $default(_that.isOpen,_that.shift,_that.timeLeft,_that.isBookingEnabled,_that.stopReason,_that.shiftClosed,_that.shiftFull,_that.morningFull,_that.eveningFull,_that.morningAvailable,_that.eveningAvailable,_that.bookingMorningStartTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_open')  bool? isOpen, @JsonKey(name: 'shift')  BookingShift? shift, @JsonKey(name: 'time_left')  int? timeLeft, @JsonKey(name: 'is_booking_enabled')  bool? isBookingEnabled, @JsonKey(name: 'stop_reason')  String? stopReason, @JsonKey(name: 'shift_closed')  BookingShift? shiftClosed, @JsonKey(name: 'shift_full')  BookingShift? shiftFull, @JsonKey(name: 'morning_full')  bool? morningFull, @JsonKey(name: 'evening_full')  bool? eveningFull, @JsonKey(name: 'morning_available')  bool? morningAvailable, @JsonKey(name: 'evening_available')  bool? eveningAvailable, @JsonKey(name: 'booking_morning_start_time')  String? bookingMorningStartTime)  $default,) {final _that = this;
switch (_that) {
case _$BookingStatusModelImpl():
return $default(_that.isOpen,_that.shift,_that.timeLeft,_that.isBookingEnabled,_that.stopReason,_that.shiftClosed,_that.shiftFull,_that.morningFull,_that.eveningFull,_that.morningAvailable,_that.eveningAvailable,_that.bookingMorningStartTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_open')  bool? isOpen, @JsonKey(name: 'shift')  BookingShift? shift, @JsonKey(name: 'time_left')  int? timeLeft, @JsonKey(name: 'is_booking_enabled')  bool? isBookingEnabled, @JsonKey(name: 'stop_reason')  String? stopReason, @JsonKey(name: 'shift_closed')  BookingShift? shiftClosed, @JsonKey(name: 'shift_full')  BookingShift? shiftFull, @JsonKey(name: 'morning_full')  bool? morningFull, @JsonKey(name: 'evening_full')  bool? eveningFull, @JsonKey(name: 'morning_available')  bool? morningAvailable, @JsonKey(name: 'evening_available')  bool? eveningAvailable, @JsonKey(name: 'booking_morning_start_time')  String? bookingMorningStartTime)?  $default,) {final _that = this;
switch (_that) {
case _$BookingStatusModelImpl() when $default != null:
return $default(_that.isOpen,_that.shift,_that.timeLeft,_that.isBookingEnabled,_that.stopReason,_that.shiftClosed,_that.shiftFull,_that.morningFull,_that.eveningFull,_that.morningAvailable,_that.eveningAvailable,_that.bookingMorningStartTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _$BookingStatusModelImpl extends BookingStatusModel {
  const _$BookingStatusModelImpl({@JsonKey(name: 'is_open') this.isOpen, @JsonKey(name: 'shift') this.shift, @JsonKey(name: 'time_left') this.timeLeft, @JsonKey(name: 'is_booking_enabled') this.isBookingEnabled, @JsonKey(name: 'stop_reason') this.stopReason, @JsonKey(name: 'shift_closed') this.shiftClosed, @JsonKey(name: 'shift_full') this.shiftFull, @JsonKey(name: 'morning_full') this.morningFull, @JsonKey(name: 'evening_full') this.eveningFull, @JsonKey(name: 'morning_available') this.morningAvailable, @JsonKey(name: 'evening_available') this.eveningAvailable, @JsonKey(name: 'booking_morning_start_time') this.bookingMorningStartTime}): super._();
  factory _$BookingStatusModelImpl.fromJson(Map<String, dynamic> json) => _$$BookingStatusModelImplFromJson(json);

@override@JsonKey(name: 'is_open') final  bool? isOpen;
@override@JsonKey(name: 'shift') final  BookingShift? shift;
@override@JsonKey(name: 'time_left') final  int? timeLeft;
@override@JsonKey(name: 'is_booking_enabled') final  bool? isBookingEnabled;
@override@JsonKey(name: 'stop_reason') final  String? stopReason;
/// When set, the current clock window's shift is closed for booking.
@override@JsonKey(name: 'shift_closed') final  BookingShift? shiftClosed;
/// Legacy: set only when no remaining bookable shift (blocks old clients).
@override@JsonKey(name: 'shift_full') final  BookingShift? shiftFull;
@override@JsonKey(name: 'morning_full') final  bool? morningFull;
@override@JsonKey(name: 'evening_full') final  bool? eveningFull;
@override@JsonKey(name: 'morning_available') final  bool? morningAvailable;
@override@JsonKey(name: 'evening_available') final  bool? eveningAvailable;
/// Clinic morning booking open time as HH:MM (from get_booking_status).
@override@JsonKey(name: 'booking_morning_start_time') final  String? bookingMorningStartTime;

/// Create a copy of BookingStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$$BookingStatusModelImplCopyWith<_$BookingStatusModelImpl> get copyWith => __$$BookingStatusModelImplCopyWithImpl<_$BookingStatusModelImpl>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$$BookingStatusModelImplToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _$BookingStatusModelImpl&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.timeLeft, timeLeft) || other.timeLeft == timeLeft)&&(identical(other.isBookingEnabled, isBookingEnabled) || other.isBookingEnabled == isBookingEnabled)&&(identical(other.stopReason, stopReason) || other.stopReason == stopReason)&&(identical(other.shiftClosed, shiftClosed) || other.shiftClosed == shiftClosed)&&(identical(other.shiftFull, shiftFull) || other.shiftFull == shiftFull)&&(identical(other.morningFull, morningFull) || other.morningFull == morningFull)&&(identical(other.eveningFull, eveningFull) || other.eveningFull == eveningFull)&&(identical(other.morningAvailable, morningAvailable) || other.morningAvailable == morningAvailable)&&(identical(other.eveningAvailable, eveningAvailable) || other.eveningAvailable == eveningAvailable)&&(identical(other.bookingMorningStartTime, bookingMorningStartTime) || other.bookingMorningStartTime == bookingMorningStartTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOpen,shift,timeLeft,isBookingEnabled,stopReason,shiftClosed,shiftFull,morningFull,eveningFull,morningAvailable,eveningAvailable,bookingMorningStartTime);

@override
String toString() {
  return 'BookingStatusModel(isOpen: $isOpen, shift: $shift, timeLeft: $timeLeft, isBookingEnabled: $isBookingEnabled, stopReason: $stopReason, shiftClosed: $shiftClosed, shiftFull: $shiftFull, morningFull: $morningFull, eveningFull: $eveningFull, morningAvailable: $morningAvailable, eveningAvailable: $eveningAvailable, bookingMorningStartTime: $bookingMorningStartTime)';
}


}

/// @nodoc
abstract mixin class _$$BookingStatusModelImplCopyWith<$Res> implements $BookingStatusModelCopyWith<$Res> {
  factory _$$BookingStatusModelImplCopyWith(_$BookingStatusModelImpl value, $Res Function(_$BookingStatusModelImpl) _then) = __$$BookingStatusModelImplCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_open') bool? isOpen,@JsonKey(name: 'shift') BookingShift? shift,@JsonKey(name: 'time_left') int? timeLeft,@JsonKey(name: 'is_booking_enabled') bool? isBookingEnabled,@JsonKey(name: 'stop_reason') String? stopReason,@JsonKey(name: 'shift_closed') BookingShift? shiftClosed,@JsonKey(name: 'shift_full') BookingShift? shiftFull,@JsonKey(name: 'morning_full') bool? morningFull,@JsonKey(name: 'evening_full') bool? eveningFull,@JsonKey(name: 'morning_available') bool? morningAvailable,@JsonKey(name: 'evening_available') bool? eveningAvailable,@JsonKey(name: 'booking_morning_start_time') String? bookingMorningStartTime
});




}
/// @nodoc
class __$$BookingStatusModelImplCopyWithImpl<$Res>
    implements _$$BookingStatusModelImplCopyWith<$Res> {
  __$$BookingStatusModelImplCopyWithImpl(this._self, this._then);

  final _$BookingStatusModelImpl _self;
  final $Res Function(_$BookingStatusModelImpl) _then;

/// Create a copy of BookingStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOpen = freezed,Object? shift = freezed,Object? timeLeft = freezed,Object? isBookingEnabled = freezed,Object? stopReason = freezed,Object? shiftClosed = freezed,Object? shiftFull = freezed,Object? morningFull = freezed,Object? eveningFull = freezed,Object? morningAvailable = freezed,Object? eveningAvailable = freezed,Object? bookingMorningStartTime = freezed,}) {
  return _then(_$BookingStatusModelImpl(
isOpen: freezed == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool?,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as BookingShift?,timeLeft: freezed == timeLeft ? _self.timeLeft : timeLeft // ignore: cast_nullable_to_non_nullable
as int?,isBookingEnabled: freezed == isBookingEnabled ? _self.isBookingEnabled : isBookingEnabled // ignore: cast_nullable_to_non_nullable
as bool?,stopReason: freezed == stopReason ? _self.stopReason : stopReason // ignore: cast_nullable_to_non_nullable
as String?,shiftClosed: freezed == shiftClosed ? _self.shiftClosed : shiftClosed // ignore: cast_nullable_to_non_nullable
as BookingShift?,shiftFull: freezed == shiftFull ? _self.shiftFull : shiftFull // ignore: cast_nullable_to_non_nullable
as BookingShift?,morningFull: freezed == morningFull ? _self.morningFull : morningFull // ignore: cast_nullable_to_non_nullable
as bool?,eveningFull: freezed == eveningFull ? _self.eveningFull : eveningFull // ignore: cast_nullable_to_non_nullable
as bool?,morningAvailable: freezed == morningAvailable ? _self.morningAvailable : morningAvailable // ignore: cast_nullable_to_non_nullable
as bool?,eveningAvailable: freezed == eveningAvailable ? _self.eveningAvailable : eveningAvailable // ignore: cast_nullable_to_non_nullable
as bool?,bookingMorningStartTime: freezed == bookingMorningStartTime ? _self.bookingMorningStartTime : bookingMorningStartTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
