// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ads_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdsModel {

 String? get id; String? get title; String? get body; List<String>? get images;@JsonKey(name: 'link_url') String? get linkUrl;
/// Create a copy of AdsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdsModelCopyWith<AdsModel> get copyWith => _$AdsModelCopyWithImpl<AdsModel>(this as AdsModel, _$identity);

  /// Serializes this AdsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,const DeepCollectionEquality().hash(images),linkUrl);

@override
String toString() {
  return 'AdsModel(id: $id, title: $title, body: $body, images: $images, linkUrl: $linkUrl)';
}


}

/// @nodoc
abstract mixin class $AdsModelCopyWith<$Res>  {
  factory $AdsModelCopyWith(AdsModel value, $Res Function(AdsModel) _then) = _$AdsModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? title, String? body, List<String>? images,@JsonKey(name: 'link_url') String? linkUrl
});




}
/// @nodoc
class _$AdsModelCopyWithImpl<$Res>
    implements $AdsModelCopyWith<$Res> {
  _$AdsModelCopyWithImpl(this._self, this._then);

  final AdsModel _self;
  final $Res Function(AdsModel) _then;

/// Create a copy of AdsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? body = freezed,Object? images = freezed,Object? linkUrl = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdsModel].
extension AdsModelPatterns on AdsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdsModel value)  $default,){
final _that = this;
switch (_that) {
case _AdsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? title,  String? body,  List<String>? images, @JsonKey(name: 'link_url')  String? linkUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdsModel() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.images,_that.linkUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? title,  String? body,  List<String>? images, @JsonKey(name: 'link_url')  String? linkUrl)  $default,) {final _that = this;
switch (_that) {
case _AdsModel():
return $default(_that.id,_that.title,_that.body,_that.images,_that.linkUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? title,  String? body,  List<String>? images, @JsonKey(name: 'link_url')  String? linkUrl)?  $default,) {final _that = this;
switch (_that) {
case _AdsModel() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.images,_that.linkUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdsModel implements AdsModel {
  const _AdsModel({this.id, this.title, this.body, final  List<String>? images, @JsonKey(name: 'link_url') this.linkUrl}): _images = images;
  factory _AdsModel.fromJson(Map<String, dynamic> json) => _$AdsModelFromJson(json);

@override final  String? id;
@override final  String? title;
@override final  String? body;
 final  List<String>? _images;
@override List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'link_url') final  String? linkUrl;

/// Create a copy of AdsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdsModelCopyWith<_AdsModel> get copyWith => __$AdsModelCopyWithImpl<_AdsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,const DeepCollectionEquality().hash(_images),linkUrl);

@override
String toString() {
  return 'AdsModel(id: $id, title: $title, body: $body, images: $images, linkUrl: $linkUrl)';
}


}

/// @nodoc
abstract mixin class _$AdsModelCopyWith<$Res> implements $AdsModelCopyWith<$Res> {
  factory _$AdsModelCopyWith(_AdsModel value, $Res Function(_AdsModel) _then) = __$AdsModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? title, String? body, List<String>? images,@JsonKey(name: 'link_url') String? linkUrl
});




}
/// @nodoc
class __$AdsModelCopyWithImpl<$Res>
    implements _$AdsModelCopyWith<$Res> {
  __$AdsModelCopyWithImpl(this._self, this._then);

  final _AdsModel _self;
  final $Res Function(_AdsModel) _then;

/// Create a copy of AdsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? body = freezed,Object? images = freezed,Object? linkUrl = freezed,}) {
  return _then(_AdsModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
