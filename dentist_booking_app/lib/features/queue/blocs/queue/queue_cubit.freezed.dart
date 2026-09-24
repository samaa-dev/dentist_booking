// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueueState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QueueState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QueueState()';
}


}

/// @nodoc
class $QueueStateCopyWith<$Res>  {
$QueueStateCopyWith(QueueState _, $Res Function(QueueState) __);
}


/// Adds pattern-matching-related methods to [QueueState].
extension QueueStatePatterns on QueueState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,TResult Function( _ActiveQueueLoaded value)?  activeQueueLoaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _ActiveQueueLoaded() when activeQueueLoaded != null:
return activeQueueLoaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,required TResult Function( _ActiveQueueLoaded value)  activeQueueLoaded,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _ActiveQueueLoaded():
return activeQueueLoaded(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,TResult? Function( _ActiveQueueLoaded value)?  activeQueueLoaded,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _ActiveQueueLoaded() when activeQueueLoaded != null:
return activeQueueLoaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TrackingModel? queue)?  loaded,TResult Function( String message)?  error,TResult Function( List<TrackingModel> queues)?  activeQueueLoaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.queue);case _Error() when error != null:
return error(_that.message);case _ActiveQueueLoaded() when activeQueueLoaded != null:
return activeQueueLoaded(_that.queues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TrackingModel? queue)  loaded,required TResult Function( String message)  error,required TResult Function( List<TrackingModel> queues)  activeQueueLoaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.queue);case _Error():
return error(_that.message);case _ActiveQueueLoaded():
return activeQueueLoaded(_that.queues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TrackingModel? queue)?  loaded,TResult? Function( String message)?  error,TResult? Function( List<TrackingModel> queues)?  activeQueueLoaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.queue);case _Error() when error != null:
return error(_that.message);case _ActiveQueueLoaded() when activeQueueLoaded != null:
return activeQueueLoaded(_that.queues);case _:
  return null;

}
}

}

/// @nodoc


class _Initial with DiagnosticableTreeMixin implements QueueState {
  const _Initial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QueueState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QueueState.initial()';
}


}




/// @nodoc


class _Loading with DiagnosticableTreeMixin implements QueueState {
  const _Loading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QueueState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QueueState.loading()';
}


}




/// @nodoc


class _Loaded with DiagnosticableTreeMixin implements QueueState {
  const _Loaded(this.queue);
  

 final  TrackingModel? queue;

/// Create a copy of QueueState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QueueState.loaded'))
    ..add(DiagnosticsProperty('queue', queue));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.queue, queue) || other.queue == queue));
}


@override
int get hashCode => Object.hash(runtimeType,queue);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QueueState.loaded(queue: $queue)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $QueueStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 TrackingModel? queue
});


$TrackingModelCopyWith<$Res>? get queue;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of QueueState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? queue = freezed,}) {
  return _then(_Loaded(
freezed == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as TrackingModel?,
  ));
}

/// Create a copy of QueueState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackingModelCopyWith<$Res>? get queue {
    if (_self.queue == null) {
    return null;
  }

  return $TrackingModelCopyWith<$Res>(_self.queue!, (value) {
    return _then(_self.copyWith(queue: value));
  });
}
}

/// @nodoc


class _Error with DiagnosticableTreeMixin implements QueueState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of QueueState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QueueState.error'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QueueState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $QueueStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of QueueState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ActiveQueueLoaded with DiagnosticableTreeMixin implements QueueState {
  const _ActiveQueueLoaded(final  List<TrackingModel> queues): _queues = queues;
  

 final  List<TrackingModel> _queues;
 List<TrackingModel> get queues {
  if (_queues is EqualUnmodifiableListView) return _queues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queues);
}


/// Create a copy of QueueState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveQueueLoadedCopyWith<_ActiveQueueLoaded> get copyWith => __$ActiveQueueLoadedCopyWithImpl<_ActiveQueueLoaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'QueueState.activeQueueLoaded'))
    ..add(DiagnosticsProperty('queues', queues));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveQueueLoaded&&const DeepCollectionEquality().equals(other._queues, _queues));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_queues));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'QueueState.activeQueueLoaded(queues: $queues)';
}


}

/// @nodoc
abstract mixin class _$ActiveQueueLoadedCopyWith<$Res> implements $QueueStateCopyWith<$Res> {
  factory _$ActiveQueueLoadedCopyWith(_ActiveQueueLoaded value, $Res Function(_ActiveQueueLoaded) _then) = __$ActiveQueueLoadedCopyWithImpl;
@useResult
$Res call({
 List<TrackingModel> queues
});




}
/// @nodoc
class __$ActiveQueueLoadedCopyWithImpl<$Res>
    implements _$ActiveQueueLoadedCopyWith<$Res> {
  __$ActiveQueueLoadedCopyWithImpl(this._self, this._then);

  final _ActiveQueueLoaded _self;
  final $Res Function(_ActiveQueueLoaded) _then;

/// Create a copy of QueueState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? queues = null,}) {
  return _then(_ActiveQueueLoaded(
null == queues ? _self._queues : queues // ignore: cast_nullable_to_non_nullable
as List<TrackingModel>,
  ));
}


}

// dart format on
