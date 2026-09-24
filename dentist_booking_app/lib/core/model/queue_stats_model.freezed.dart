// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueueStatsModel {

@JsonKey(name: 'is_paused') bool get isPaused;@JsonKey(name: 'current_queue_number') int get currentQueueNumber;@JsonKey(name: 'patients_before_you') int get patientsBeforeYou;@JsonKey(name: 'last_updated') DateTime get lastUpdated;@JsonKey(name: 'total_in_queue') int get totalInQueue;@JsonKey(name: 'estimated_wait_time') int get estimatedWaitTime;
/// Create a copy of QueueStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueStatsModelCopyWith<QueueStatsModel> get copyWith => _$QueueStatsModelCopyWithImpl<QueueStatsModel>(this as QueueStatsModel, _$identity);

  /// Serializes this QueueStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueStatsModel&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.currentQueueNumber, currentQueueNumber) || other.currentQueueNumber == currentQueueNumber)&&(identical(other.patientsBeforeYou, patientsBeforeYou) || other.patientsBeforeYou == patientsBeforeYou)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.totalInQueue, totalInQueue) || other.totalInQueue == totalInQueue)&&(identical(other.estimatedWaitTime, estimatedWaitTime) || other.estimatedWaitTime == estimatedWaitTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPaused,currentQueueNumber,patientsBeforeYou,lastUpdated,totalInQueue,estimatedWaitTime);

@override
String toString() {
  return 'QueueStatsModel(isPaused: $isPaused, currentQueueNumber: $currentQueueNumber, patientsBeforeYou: $patientsBeforeYou, lastUpdated: $lastUpdated, totalInQueue: $totalInQueue, estimatedWaitTime: $estimatedWaitTime)';
}


}

/// @nodoc
abstract mixin class $QueueStatsModelCopyWith<$Res>  {
  factory $QueueStatsModelCopyWith(QueueStatsModel value, $Res Function(QueueStatsModel) _then) = _$QueueStatsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_paused') bool isPaused,@JsonKey(name: 'current_queue_number') int currentQueueNumber,@JsonKey(name: 'patients_before_you') int patientsBeforeYou,@JsonKey(name: 'last_updated') DateTime lastUpdated,@JsonKey(name: 'total_in_queue') int totalInQueue,@JsonKey(name: 'estimated_wait_time') int estimatedWaitTime
});




}
/// @nodoc
class _$QueueStatsModelCopyWithImpl<$Res>
    implements $QueueStatsModelCopyWith<$Res> {
  _$QueueStatsModelCopyWithImpl(this._self, this._then);

  final QueueStatsModel _self;
  final $Res Function(QueueStatsModel) _then;

/// Create a copy of QueueStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPaused = null,Object? currentQueueNumber = null,Object? patientsBeforeYou = null,Object? lastUpdated = null,Object? totalInQueue = null,Object? estimatedWaitTime = null,}) {
  return _then(_self.copyWith(
isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,currentQueueNumber: null == currentQueueNumber ? _self.currentQueueNumber : currentQueueNumber // ignore: cast_nullable_to_non_nullable
as int,patientsBeforeYou: null == patientsBeforeYou ? _self.patientsBeforeYou : patientsBeforeYou // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,totalInQueue: null == totalInQueue ? _self.totalInQueue : totalInQueue // ignore: cast_nullable_to_non_nullable
as int,estimatedWaitTime: null == estimatedWaitTime ? _self.estimatedWaitTime : estimatedWaitTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QueueStatsModel].
extension QueueStatsModelPatterns on QueueStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _QueueStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _QueueStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_paused')  bool isPaused, @JsonKey(name: 'current_queue_number')  int currentQueueNumber, @JsonKey(name: 'patients_before_you')  int patientsBeforeYou, @JsonKey(name: 'last_updated')  DateTime lastUpdated, @JsonKey(name: 'total_in_queue')  int totalInQueue, @JsonKey(name: 'estimated_wait_time')  int estimatedWaitTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueStatsModel() when $default != null:
return $default(_that.isPaused,_that.currentQueueNumber,_that.patientsBeforeYou,_that.lastUpdated,_that.totalInQueue,_that.estimatedWaitTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_paused')  bool isPaused, @JsonKey(name: 'current_queue_number')  int currentQueueNumber, @JsonKey(name: 'patients_before_you')  int patientsBeforeYou, @JsonKey(name: 'last_updated')  DateTime lastUpdated, @JsonKey(name: 'total_in_queue')  int totalInQueue, @JsonKey(name: 'estimated_wait_time')  int estimatedWaitTime)  $default,) {final _that = this;
switch (_that) {
case _QueueStatsModel():
return $default(_that.isPaused,_that.currentQueueNumber,_that.patientsBeforeYou,_that.lastUpdated,_that.totalInQueue,_that.estimatedWaitTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_paused')  bool isPaused, @JsonKey(name: 'current_queue_number')  int currentQueueNumber, @JsonKey(name: 'patients_before_you')  int patientsBeforeYou, @JsonKey(name: 'last_updated')  DateTime lastUpdated, @JsonKey(name: 'total_in_queue')  int totalInQueue, @JsonKey(name: 'estimated_wait_time')  int estimatedWaitTime)?  $default,) {final _that = this;
switch (_that) {
case _QueueStatsModel() when $default != null:
return $default(_that.isPaused,_that.currentQueueNumber,_that.patientsBeforeYou,_that.lastUpdated,_that.totalInQueue,_that.estimatedWaitTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueStatsModel implements QueueStatsModel {
  const _QueueStatsModel({@JsonKey(name: 'is_paused') required this.isPaused, @JsonKey(name: 'current_queue_number') required this.currentQueueNumber, @JsonKey(name: 'patients_before_you') required this.patientsBeforeYou, @JsonKey(name: 'last_updated') required this.lastUpdated, @JsonKey(name: 'total_in_queue') required this.totalInQueue, @JsonKey(name: 'estimated_wait_time') required this.estimatedWaitTime});
  factory _QueueStatsModel.fromJson(Map<String, dynamic> json) => _$QueueStatsModelFromJson(json);

@override@JsonKey(name: 'is_paused') final  bool isPaused;
@override@JsonKey(name: 'current_queue_number') final  int currentQueueNumber;
@override@JsonKey(name: 'patients_before_you') final  int patientsBeforeYou;
@override@JsonKey(name: 'last_updated') final  DateTime lastUpdated;
@override@JsonKey(name: 'total_in_queue') final  int totalInQueue;
@override@JsonKey(name: 'estimated_wait_time') final  int estimatedWaitTime;

/// Create a copy of QueueStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueStatsModelCopyWith<_QueueStatsModel> get copyWith => __$QueueStatsModelCopyWithImpl<_QueueStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueStatsModel&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.currentQueueNumber, currentQueueNumber) || other.currentQueueNumber == currentQueueNumber)&&(identical(other.patientsBeforeYou, patientsBeforeYou) || other.patientsBeforeYou == patientsBeforeYou)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.totalInQueue, totalInQueue) || other.totalInQueue == totalInQueue)&&(identical(other.estimatedWaitTime, estimatedWaitTime) || other.estimatedWaitTime == estimatedWaitTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPaused,currentQueueNumber,patientsBeforeYou,lastUpdated,totalInQueue,estimatedWaitTime);

@override
String toString() {
  return 'QueueStatsModel(isPaused: $isPaused, currentQueueNumber: $currentQueueNumber, patientsBeforeYou: $patientsBeforeYou, lastUpdated: $lastUpdated, totalInQueue: $totalInQueue, estimatedWaitTime: $estimatedWaitTime)';
}


}

/// @nodoc
abstract mixin class _$QueueStatsModelCopyWith<$Res> implements $QueueStatsModelCopyWith<$Res> {
  factory _$QueueStatsModelCopyWith(_QueueStatsModel value, $Res Function(_QueueStatsModel) _then) = __$QueueStatsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_paused') bool isPaused,@JsonKey(name: 'current_queue_number') int currentQueueNumber,@JsonKey(name: 'patients_before_you') int patientsBeforeYou,@JsonKey(name: 'last_updated') DateTime lastUpdated,@JsonKey(name: 'total_in_queue') int totalInQueue,@JsonKey(name: 'estimated_wait_time') int estimatedWaitTime
});




}
/// @nodoc
class __$QueueStatsModelCopyWithImpl<$Res>
    implements _$QueueStatsModelCopyWith<$Res> {
  __$QueueStatsModelCopyWithImpl(this._self, this._then);

  final _QueueStatsModel _self;
  final $Res Function(_QueueStatsModel) _then;

/// Create a copy of QueueStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPaused = null,Object? currentQueueNumber = null,Object? patientsBeforeYou = null,Object? lastUpdated = null,Object? totalInQueue = null,Object? estimatedWaitTime = null,}) {
  return _then(_QueueStatsModel(
isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,currentQueueNumber: null == currentQueueNumber ? _self.currentQueueNumber : currentQueueNumber // ignore: cast_nullable_to_non_nullable
as int,patientsBeforeYou: null == patientsBeforeYou ? _self.patientsBeforeYou : patientsBeforeYou // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,totalInQueue: null == totalInQueue ? _self.totalInQueue : totalInQueue // ignore: cast_nullable_to_non_nullable
as int,estimatedWaitTime: null == estimatedWaitTime ? _self.estimatedWaitTime : estimatedWaitTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
