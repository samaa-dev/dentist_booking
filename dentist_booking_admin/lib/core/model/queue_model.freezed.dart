// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QueueModel _$QueueModelFromJson(Map<String, dynamic> json) {
  return _QueueModel.fromJson(json);
}

/// @nodoc
mixin _$QueueModel {
  bool? get success => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  BookingModel? get booking => throw _privateConstructorUsedError;

  /// Serializes this QueueModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueueModelCopyWith<QueueModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueModelCopyWith<$Res> {
  factory $QueueModelCopyWith(
    QueueModel value,
    $Res Function(QueueModel) then,
  ) = _$QueueModelCopyWithImpl<$Res, QueueModel>;
  @useResult
  $Res call({
    bool? success,
    String? code,
    String? message,
    BookingModel? booking,
  });

  $BookingModelCopyWith<$Res>? get booking;
}

/// @nodoc
class _$QueueModelCopyWithImpl<$Res, $Val extends QueueModel>
    implements $QueueModelCopyWith<$Res> {
  _$QueueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? code = freezed,
    Object? message = freezed,
    Object? booking = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: freezed == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool?,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            booking: freezed == booking
                ? _value.booking
                : booking // ignore: cast_nullable_to_non_nullable
                      as BookingModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of QueueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingModelCopyWith<$Res>? get booking {
    if (_value.booking == null) {
      return null;
    }

    return $BookingModelCopyWith<$Res>(_value.booking!, (value) {
      return _then(_value.copyWith(booking: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QueueModelImplCopyWith<$Res>
    implements $QueueModelCopyWith<$Res> {
  factory _$$QueueModelImplCopyWith(
    _$QueueModelImpl value,
    $Res Function(_$QueueModelImpl) then,
  ) = __$$QueueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool? success,
    String? code,
    String? message,
    BookingModel? booking,
  });

  @override
  $BookingModelCopyWith<$Res>? get booking;
}

/// @nodoc
class __$$QueueModelImplCopyWithImpl<$Res>
    extends _$QueueModelCopyWithImpl<$Res, _$QueueModelImpl>
    implements _$$QueueModelImplCopyWith<$Res> {
  __$$QueueModelImplCopyWithImpl(
    _$QueueModelImpl _value,
    $Res Function(_$QueueModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? code = freezed,
    Object? message = freezed,
    Object? booking = freezed,
  }) {
    return _then(
      _$QueueModelImpl(
        success: freezed == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool?,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        booking: freezed == booking
            ? _value.booking
            : booking // ignore: cast_nullable_to_non_nullable
                  as BookingModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QueueModelImpl implements _QueueModel {
  const _$QueueModelImpl({this.success, this.code, this.message, this.booking});

  factory _$QueueModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueueModelImplFromJson(json);

  @override
  final bool? success;
  @override
  final String? code;
  @override
  final String? message;
  @override
  final BookingModel? booking;

  @override
  String toString() {
    return 'QueueModel(success: $success, code: $code, message: $message, booking: $booking)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.booking, booking) || other.booking == booking));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, code, message, booking);

  /// Create a copy of QueueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueModelImplCopyWith<_$QueueModelImpl> get copyWith =>
      __$$QueueModelImplCopyWithImpl<_$QueueModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueueModelImplToJson(this);
  }
}

abstract class _QueueModel implements QueueModel {
  const factory _QueueModel({
    final bool? success,
    final String? code,
    final String? message,
    final BookingModel? booking,
  }) = _$QueueModelImpl;

  factory _QueueModel.fromJson(Map<String, dynamic> json) =
      _$QueueModelImpl.fromJson;

  @override
  bool? get success;
  @override
  String? get code;
  @override
  String? get message;
  @override
  BookingModel? get booking;

  /// Create a copy of QueueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueueModelImplCopyWith<_$QueueModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
