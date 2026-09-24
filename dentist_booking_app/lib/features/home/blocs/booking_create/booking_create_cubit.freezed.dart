// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_create_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingCreateState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingCreateState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingCreateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingCreateState()';
}


}

/// @nodoc
class $BookingCreateStateCopyWith<$Res>  {
$BookingCreateStateCopyWith(BookingCreateState _, $Res Function(BookingCreateState) __);
}


/// Adds pattern-matching-related methods to [BookingCreateState].
extension BookingCreateStatePatterns on BookingCreateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _SuccessBookingCreate value)?  successBookingCreate,TResult Function( _ErrorBookingCreate value)?  errorBookingCreate,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _SuccessBookingCreate() when successBookingCreate != null:
return successBookingCreate(_that);case _ErrorBookingCreate() when errorBookingCreate != null:
return errorBookingCreate(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _SuccessBookingCreate value)  successBookingCreate,required TResult Function( _ErrorBookingCreate value)  errorBookingCreate,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _SuccessBookingCreate():
return successBookingCreate(_that);case _ErrorBookingCreate():
return errorBookingCreate(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _SuccessBookingCreate value)?  successBookingCreate,TResult? Function( _ErrorBookingCreate value)?  errorBookingCreate,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _SuccessBookingCreate() when successBookingCreate != null:
return successBookingCreate(_that);case _ErrorBookingCreate() when errorBookingCreate != null:
return errorBookingCreate(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( BookingModel booking)?  successBookingCreate,TResult Function( String message)?  errorBookingCreate,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _SuccessBookingCreate() when successBookingCreate != null:
return successBookingCreate(_that.booking);case _ErrorBookingCreate() when errorBookingCreate != null:
return errorBookingCreate(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( BookingModel booking)  successBookingCreate,required TResult Function( String message)  errorBookingCreate,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _SuccessBookingCreate():
return successBookingCreate(_that.booking);case _ErrorBookingCreate():
return errorBookingCreate(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( BookingModel booking)?  successBookingCreate,TResult? Function( String message)?  errorBookingCreate,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _SuccessBookingCreate() when successBookingCreate != null:
return successBookingCreate(_that.booking);case _ErrorBookingCreate() when errorBookingCreate != null:
return errorBookingCreate(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial with DiagnosticableTreeMixin implements BookingCreateState {
  const _Initial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingCreateState.initial'))
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
  return 'BookingCreateState.initial()';
}


}




/// @nodoc


class _Loading with DiagnosticableTreeMixin implements BookingCreateState {
  const _Loading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingCreateState.loading'))
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
  return 'BookingCreateState.loading()';
}


}




/// @nodoc


class _SuccessBookingCreate with DiagnosticableTreeMixin implements BookingCreateState {
  const _SuccessBookingCreate(this.booking);
  

 final  BookingModel booking;

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessBookingCreateCopyWith<_SuccessBookingCreate> get copyWith => __$SuccessBookingCreateCopyWithImpl<_SuccessBookingCreate>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingCreateState.successBookingCreate'))
    ..add(DiagnosticsProperty('booking', booking));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuccessBookingCreate&&(identical(other.booking, booking) || other.booking == booking));
}


@override
int get hashCode => Object.hash(runtimeType,booking);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingCreateState.successBookingCreate(booking: $booking)';
}


}

/// @nodoc
abstract mixin class _$SuccessBookingCreateCopyWith<$Res> implements $BookingCreateStateCopyWith<$Res> {
  factory _$SuccessBookingCreateCopyWith(_SuccessBookingCreate value, $Res Function(_SuccessBookingCreate) _then) = __$SuccessBookingCreateCopyWithImpl;
@useResult
$Res call({
 BookingModel booking
});


$BookingModelCopyWith<$Res> get booking;

}
/// @nodoc
class __$SuccessBookingCreateCopyWithImpl<$Res>
    implements _$SuccessBookingCreateCopyWith<$Res> {
  __$SuccessBookingCreateCopyWithImpl(this._self, this._then);

  final _SuccessBookingCreate _self;
  final $Res Function(_SuccessBookingCreate) _then;

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? booking = null,}) {
  return _then(_SuccessBookingCreate(
null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as BookingModel,
  ));
}

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingModelCopyWith<$Res> get booking {
  
  return $BookingModelCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}

/// @nodoc


class _ErrorBookingCreate with DiagnosticableTreeMixin implements BookingCreateState {
  const _ErrorBookingCreate(this.message);
  

 final  String message;

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorBookingCreateCopyWith<_ErrorBookingCreate> get copyWith => __$ErrorBookingCreateCopyWithImpl<_ErrorBookingCreate>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingCreateState.errorBookingCreate'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorBookingCreate&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingCreateState.errorBookingCreate(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorBookingCreateCopyWith<$Res> implements $BookingCreateStateCopyWith<$Res> {
  factory _$ErrorBookingCreateCopyWith(_ErrorBookingCreate value, $Res Function(_ErrorBookingCreate) _then) = __$ErrorBookingCreateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorBookingCreateCopyWithImpl<$Res>
    implements _$ErrorBookingCreateCopyWith<$Res> {
  __$ErrorBookingCreateCopyWithImpl(this._self, this._then);

  final _ErrorBookingCreate _self;
  final $Res Function(_ErrorBookingCreate) _then;

/// Create a copy of BookingCreateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ErrorBookingCreate(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
