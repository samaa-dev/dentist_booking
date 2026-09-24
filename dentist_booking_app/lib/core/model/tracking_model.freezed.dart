// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackingModel {

@JsonKey(name: 'booking') BookingModel get booking;@JsonKey(name: 'queue_stats') QueueStatsModel get queueStats;
/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingModelCopyWith<TrackingModel> get copyWith => _$TrackingModelCopyWithImpl<TrackingModel>(this as TrackingModel, _$identity);

  /// Serializes this TrackingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingModel&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.queueStats, queueStats) || other.queueStats == queueStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,booking,queueStats);

@override
String toString() {
  return 'TrackingModel(booking: $booking, queueStats: $queueStats)';
}


}

/// @nodoc
abstract mixin class $TrackingModelCopyWith<$Res>  {
  factory $TrackingModelCopyWith(TrackingModel value, $Res Function(TrackingModel) _then) = _$TrackingModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'booking') BookingModel booking,@JsonKey(name: 'queue_stats') QueueStatsModel queueStats
});


$BookingModelCopyWith<$Res> get booking;$QueueStatsModelCopyWith<$Res> get queueStats;

}
/// @nodoc
class _$TrackingModelCopyWithImpl<$Res>
    implements $TrackingModelCopyWith<$Res> {
  _$TrackingModelCopyWithImpl(this._self, this._then);

  final TrackingModel _self;
  final $Res Function(TrackingModel) _then;

/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? queueStats = null,}) {
  return _then(_self.copyWith(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as BookingModel,queueStats: null == queueStats ? _self.queueStats : queueStats // ignore: cast_nullable_to_non_nullable
as QueueStatsModel,
  ));
}
/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingModelCopyWith<$Res> get booking {
  
  return $BookingModelCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueueStatsModelCopyWith<$Res> get queueStats {
  
  return $QueueStatsModelCopyWith<$Res>(_self.queueStats, (value) {
    return _then(_self.copyWith(queueStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackingModel].
extension TrackingModelPatterns on TrackingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingModel value)  $default,){
final _that = this;
switch (_that) {
case _TrackingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'booking')  BookingModel booking, @JsonKey(name: 'queue_stats')  QueueStatsModel queueStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingModel() when $default != null:
return $default(_that.booking,_that.queueStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'booking')  BookingModel booking, @JsonKey(name: 'queue_stats')  QueueStatsModel queueStats)  $default,) {final _that = this;
switch (_that) {
case _TrackingModel():
return $default(_that.booking,_that.queueStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'booking')  BookingModel booking, @JsonKey(name: 'queue_stats')  QueueStatsModel queueStats)?  $default,) {final _that = this;
switch (_that) {
case _TrackingModel() when $default != null:
return $default(_that.booking,_that.queueStats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackingModel implements TrackingModel {
  const _TrackingModel({@JsonKey(name: 'booking') required this.booking, @JsonKey(name: 'queue_stats') required this.queueStats});
  factory _TrackingModel.fromJson(Map<String, dynamic> json) => _$TrackingModelFromJson(json);

@override@JsonKey(name: 'booking') final  BookingModel booking;
@override@JsonKey(name: 'queue_stats') final  QueueStatsModel queueStats;

/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingModelCopyWith<_TrackingModel> get copyWith => __$TrackingModelCopyWithImpl<_TrackingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingModel&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.queueStats, queueStats) || other.queueStats == queueStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,booking,queueStats);

@override
String toString() {
  return 'TrackingModel(booking: $booking, queueStats: $queueStats)';
}


}

/// @nodoc
abstract mixin class _$TrackingModelCopyWith<$Res> implements $TrackingModelCopyWith<$Res> {
  factory _$TrackingModelCopyWith(_TrackingModel value, $Res Function(_TrackingModel) _then) = __$TrackingModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'booking') BookingModel booking,@JsonKey(name: 'queue_stats') QueueStatsModel queueStats
});


@override $BookingModelCopyWith<$Res> get booking;@override $QueueStatsModelCopyWith<$Res> get queueStats;

}
/// @nodoc
class __$TrackingModelCopyWithImpl<$Res>
    implements _$TrackingModelCopyWith<$Res> {
  __$TrackingModelCopyWithImpl(this._self, this._then);

  final _TrackingModel _self;
  final $Res Function(_TrackingModel) _then;

/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? queueStats = null,}) {
  return _then(_TrackingModel(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as BookingModel,queueStats: null == queueStats ? _self.queueStats : queueStats // ignore: cast_nullable_to_non_nullable
as QueueStatsModel,
  ));
}

/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingModelCopyWith<$Res> get booking {
  
  return $BookingModelCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of TrackingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QueueStatsModelCopyWith<$Res> get queueStats {
  
  return $QueueStatsModelCopyWith<$Res>(_self.queueStats, (value) {
    return _then(_self.copyWith(queueStats: value));
  });
}
}

// dart format on
