// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingState()';
}


}

/// @nodoc
class $BookingStateCopyWith<$Res>  {
$BookingStateCopyWith(BookingState _, $Res Function(BookingState) __);
}


/// Adds pattern-matching-related methods to [BookingState].
extension BookingStatePatterns on BookingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( Loaded value)?  loaded,TResult Function( Error value)?  error,TResult Function( _LoadingBooking value)?  loadingbooking,TResult Function( _ErrorCancelBooking value)?  errorCancelBooking,TResult Function( _SuccessCancelBooking value)?  successCancelBooking,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Loaded() when loaded != null:
return loaded(_that);case Error() when error != null:
return error(_that);case _LoadingBooking() when loadingbooking != null:
return loadingbooking(_that);case _ErrorCancelBooking() when errorCancelBooking != null:
return errorCancelBooking(_that);case _SuccessCancelBooking() when successCancelBooking != null:
return successCancelBooking(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( Loaded value)  loaded,required TResult Function( Error value)  error,required TResult Function( _LoadingBooking value)  loadingbooking,required TResult Function( _ErrorCancelBooking value)  errorCancelBooking,required TResult Function( _SuccessCancelBooking value)  successCancelBooking,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case Loading():
return loading(_that);case Loaded():
return loaded(_that);case Error():
return error(_that);case _LoadingBooking():
return loadingbooking(_that);case _ErrorCancelBooking():
return errorCancelBooking(_that);case _SuccessCancelBooking():
return successCancelBooking(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( Loaded value)?  loaded,TResult? Function( Error value)?  error,TResult? Function( _LoadingBooking value)?  loadingbooking,TResult? Function( _ErrorCancelBooking value)?  errorCancelBooking,TResult? Function( _SuccessCancelBooking value)?  successCancelBooking,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Loaded() when loaded != null:
return loaded(_that);case Error() when error != null:
return error(_that);case _LoadingBooking() when loadingbooking != null:
return loadingbooking(_that);case _ErrorCancelBooking() when errorCancelBooking != null:
return errorCancelBooking(_that);case _SuccessCancelBooking() when successCancelBooking != null:
return successCancelBooking(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<BookingModel> bookings)?  loaded,TResult Function( String message)?  error,TResult Function()?  loadingbooking,TResult Function( String message)?  errorCancelBooking,TResult Function( String message)?  successCancelBooking,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Loaded() when loaded != null:
return loaded(_that.bookings);case Error() when error != null:
return error(_that.message);case _LoadingBooking() when loadingbooking != null:
return loadingbooking();case _ErrorCancelBooking() when errorCancelBooking != null:
return errorCancelBooking(_that.message);case _SuccessCancelBooking() when successCancelBooking != null:
return successCancelBooking(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<BookingModel> bookings)  loaded,required TResult Function( String message)  error,required TResult Function()  loadingbooking,required TResult Function( String message)  errorCancelBooking,required TResult Function( String message)  successCancelBooking,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case Loading():
return loading();case Loaded():
return loaded(_that.bookings);case Error():
return error(_that.message);case _LoadingBooking():
return loadingbooking();case _ErrorCancelBooking():
return errorCancelBooking(_that.message);case _SuccessCancelBooking():
return successCancelBooking(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<BookingModel> bookings)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  loadingbooking,TResult? Function( String message)?  errorCancelBooking,TResult? Function( String message)?  successCancelBooking,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Loaded() when loaded != null:
return loaded(_that.bookings);case Error() when error != null:
return error(_that.message);case _LoadingBooking() when loadingbooking != null:
return loadingbooking();case _ErrorCancelBooking() when errorCancelBooking != null:
return errorCancelBooking(_that.message);case _SuccessCancelBooking() when successCancelBooking != null:
return successCancelBooking(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial with DiagnosticableTreeMixin implements BookingState {
  const _Initial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState.initial'))
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
  return 'BookingState.initial()';
}


}




/// @nodoc


class Loading with DiagnosticableTreeMixin implements BookingState {
  const Loading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingState.loading()';
}


}




/// @nodoc


class Loaded with DiagnosticableTreeMixin implements BookingState {
  const Loaded(final  List<BookingModel> bookings): _bookings = bookings;
  

 final  List<BookingModel> _bookings;
 List<BookingModel> get bookings {
  if (_bookings is EqualUnmodifiableListView) return _bookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookings);
}


/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadedCopyWith<Loaded> get copyWith => _$LoadedCopyWithImpl<Loaded>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState.loaded'))
    ..add(DiagnosticsProperty('bookings', bookings));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loaded&&const DeepCollectionEquality().equals(other._bookings, _bookings));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookings));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingState.loaded(bookings: $bookings)';
}


}

/// @nodoc
abstract mixin class $LoadedCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $LoadedCopyWith(Loaded value, $Res Function(Loaded) _then) = _$LoadedCopyWithImpl;
@useResult
$Res call({
 List<BookingModel> bookings
});




}
/// @nodoc
class _$LoadedCopyWithImpl<$Res>
    implements $LoadedCopyWith<$Res> {
  _$LoadedCopyWithImpl(this._self, this._then);

  final Loaded _self;
  final $Res Function(Loaded) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookings = null,}) {
  return _then(Loaded(
null == bookings ? _self._bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<BookingModel>,
  ));
}


}

/// @nodoc


class Error with DiagnosticableTreeMixin implements BookingState {
  const Error(this.message);
  

 final  String message;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState.error'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoadingBooking with DiagnosticableTreeMixin implements BookingState {
  const _LoadingBooking();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState.loadingbooking'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadingBooking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingState.loadingbooking()';
}


}




/// @nodoc


class _ErrorCancelBooking with DiagnosticableTreeMixin implements BookingState {
  const _ErrorCancelBooking(this.message);
  

 final  String message;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCancelBookingCopyWith<_ErrorCancelBooking> get copyWith => __$ErrorCancelBookingCopyWithImpl<_ErrorCancelBooking>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState.errorCancelBooking'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorCancelBooking&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingState.errorCancelBooking(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCancelBookingCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory _$ErrorCancelBookingCopyWith(_ErrorCancelBooking value, $Res Function(_ErrorCancelBooking) _then) = __$ErrorCancelBookingCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCancelBookingCopyWithImpl<$Res>
    implements _$ErrorCancelBookingCopyWith<$Res> {
  __$ErrorCancelBookingCopyWithImpl(this._self, this._then);

  final _ErrorCancelBooking _self;
  final $Res Function(_ErrorCancelBooking) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ErrorCancelBooking(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SuccessCancelBooking with DiagnosticableTreeMixin implements BookingState {
  const _SuccessCancelBooking(this.message);
  

 final  String message;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCancelBookingCopyWith<_SuccessCancelBooking> get copyWith => __$SuccessCancelBookingCopyWithImpl<_SuccessCancelBooking>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BookingState.successCancelBooking'))
    ..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuccessCancelBooking&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BookingState.successCancelBooking(message: $message)';
}


}

/// @nodoc
abstract mixin class _$SuccessCancelBookingCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory _$SuccessCancelBookingCopyWith(_SuccessCancelBooking value, $Res Function(_SuccessCancelBooking) _then) = __$SuccessCancelBookingCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$SuccessCancelBookingCopyWithImpl<$Res>
    implements _$SuccessCancelBookingCopyWith<$Res> {
  __$SuccessCancelBookingCopyWithImpl(this._self, this._then);

  final _SuccessCancelBooking _self;
  final $Res Function(_SuccessCancelBooking) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_SuccessCancelBooking(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
