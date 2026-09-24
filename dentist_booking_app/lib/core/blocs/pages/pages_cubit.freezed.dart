// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pages_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PagesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PagesState()';
}


}

/// @nodoc
class $PagesStateCopyWith<$Res>  {
$PagesStateCopyWith(PagesState _, $Res Function(PagesState) __);
}


/// Adds pattern-matching-related methods to [PagesState].
extension PagesStatePatterns on PagesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Changed value)?  changed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Changed() when changed != null:
return changed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Changed value)  changed,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Changed():
return changed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Changed value)?  changed,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Changed() when changed != null:
return changed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int currentPageIndex,  Map<String, dynamic>? data)?  changed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Changed() when changed != null:
return changed(_that.currentPageIndex,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int currentPageIndex,  Map<String, dynamic>? data)  changed,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Changed():
return changed(_that.currentPageIndex,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int currentPageIndex,  Map<String, dynamic>? data)?  changed,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Changed() when changed != null:
return changed(_that.currentPageIndex,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements PagesState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PagesState.initial()';
}


}




/// @nodoc


class _Changed implements PagesState {
  const _Changed({required this.currentPageIndex, final  Map<String, dynamic>? data}): _data = data;
  

 final  int currentPageIndex;
 final  Map<String, dynamic>? _data;
 Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangedCopyWith<_Changed> get copyWith => __$ChangedCopyWithImpl<_Changed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Changed&&(identical(other.currentPageIndex, currentPageIndex) || other.currentPageIndex == currentPageIndex)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,currentPageIndex,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'PagesState.changed(currentPageIndex: $currentPageIndex, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChangedCopyWith<$Res> implements $PagesStateCopyWith<$Res> {
  factory _$ChangedCopyWith(_Changed value, $Res Function(_Changed) _then) = __$ChangedCopyWithImpl;
@useResult
$Res call({
 int currentPageIndex, Map<String, dynamic>? data
});




}
/// @nodoc
class __$ChangedCopyWithImpl<$Res>
    implements _$ChangedCopyWith<$Res> {
  __$ChangedCopyWithImpl(this._self, this._then);

  final _Changed _self;
  final $Res Function(_Changed) _then;

/// Create a copy of PagesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentPageIndex = null,Object? data = freezed,}) {
  return _then(_Changed(
currentPageIndex: null == currentPageIndex ? _self.currentPageIndex : currentPageIndex // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
