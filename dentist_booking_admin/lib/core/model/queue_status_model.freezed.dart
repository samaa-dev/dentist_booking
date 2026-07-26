// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QueueStatusModel _$QueueStatusModelFromJson(Map<String, dynamic> json) {
  return _QueueStatusModel.fromJson(json);
}

/// @nodoc
mixin _$QueueStatusModel {
  String get state => throw _privateConstructorUsedError;
  String? get shift => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_queue_number')
  int? get currentQueueNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_booking')
  BookingModel? get currentBooking => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this QueueStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueueStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueueStatusModelCopyWith<QueueStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueStatusModelCopyWith<$Res> {
  factory $QueueStatusModelCopyWith(
    QueueStatusModel value,
    $Res Function(QueueStatusModel) then,
  ) = _$QueueStatusModelCopyWithImpl<$Res, QueueStatusModel>;
  @useResult
  $Res call({
    String state,
    String? shift,
    @JsonKey(name: 'current_queue_number') int? currentQueueNumber,
    @JsonKey(name: 'current_booking') BookingModel? currentBooking,
    String? message,
  });

  $BookingModelCopyWith<$Res>? get currentBooking;
}

/// @nodoc
class _$QueueStatusModelCopyWithImpl<$Res, $Val extends QueueStatusModel>
    implements $QueueStatusModelCopyWith<$Res> {
  _$QueueStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueueStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? shift = freezed,
    Object? currentQueueNumber = freezed,
    Object? currentBooking = freezed,
    Object? message = freezed,
  }) {
    return _then(
      _value.copyWith(
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            shift: freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentQueueNumber: freezed == currentQueueNumber
                ? _value.currentQueueNumber
                : currentQueueNumber // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentBooking: freezed == currentBooking
                ? _value.currentBooking
                : currentBooking // ignore: cast_nullable_to_non_nullable
                      as BookingModel?,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of QueueStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingModelCopyWith<$Res>? get currentBooking {
    if (_value.currentBooking == null) {
      return null;
    }

    return $BookingModelCopyWith<$Res>(_value.currentBooking!, (value) {
      return _then(_value.copyWith(currentBooking: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QueueStatusModelImplCopyWith<$Res>
    implements $QueueStatusModelCopyWith<$Res> {
  factory _$$QueueStatusModelImplCopyWith(
    _$QueueStatusModelImpl value,
    $Res Function(_$QueueStatusModelImpl) then,
  ) = __$$QueueStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String state,
    String? shift,
    @JsonKey(name: 'current_queue_number') int? currentQueueNumber,
    @JsonKey(name: 'current_booking') BookingModel? currentBooking,
    String? message,
  });

  @override
  $BookingModelCopyWith<$Res>? get currentBooking;
}

/// @nodoc
class __$$QueueStatusModelImplCopyWithImpl<$Res>
    extends _$QueueStatusModelCopyWithImpl<$Res, _$QueueStatusModelImpl>
    implements _$$QueueStatusModelImplCopyWith<$Res> {
  __$$QueueStatusModelImplCopyWithImpl(
    _$QueueStatusModelImpl _value,
    $Res Function(_$QueueStatusModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? shift = freezed,
    Object? currentQueueNumber = freezed,
    Object? currentBooking = freezed,
    Object? message = freezed,
  }) {
    return _then(
      _$QueueStatusModelImpl(
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        shift: freezed == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentQueueNumber: freezed == currentQueueNumber
            ? _value.currentQueueNumber
            : currentQueueNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentBooking: freezed == currentBooking
            ? _value.currentBooking
            : currentBooking // ignore: cast_nullable_to_non_nullable
                  as BookingModel?,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QueueStatusModelImpl implements _QueueStatusModel {
  const _$QueueStatusModelImpl({
    required this.state,
    this.shift,
    @JsonKey(name: 'current_queue_number') this.currentQueueNumber,
    @JsonKey(name: 'current_booking') this.currentBooking,
    this.message,
  });

  factory _$QueueStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueueStatusModelImplFromJson(json);

  @override
  final String state;
  @override
  final String? shift;
  @override
  @JsonKey(name: 'current_queue_number')
  final int? currentQueueNumber;
  @override
  @JsonKey(name: 'current_booking')
  final BookingModel? currentBooking;
  @override
  final String? message;

  @override
  String toString() {
    return 'QueueStatusModel(state: $state, shift: $shift, currentQueueNumber: $currentQueueNumber, currentBooking: $currentBooking, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueStatusModelImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.currentQueueNumber, currentQueueNumber) ||
                other.currentQueueNumber == currentQueueNumber) &&
            (identical(other.currentBooking, currentBooking) ||
                other.currentBooking == currentBooking) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    state,
    shift,
    currentQueueNumber,
    currentBooking,
    message,
  );

  /// Create a copy of QueueStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueStatusModelImplCopyWith<_$QueueStatusModelImpl> get copyWith =>
      __$$QueueStatusModelImplCopyWithImpl<_$QueueStatusModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QueueStatusModelImplToJson(this);
  }
}

abstract class _QueueStatusModel implements QueueStatusModel {
  const factory _QueueStatusModel({
    required final String state,
    final String? shift,
    @JsonKey(name: 'current_queue_number') final int? currentQueueNumber,
    @JsonKey(name: 'current_booking') final BookingModel? currentBooking,
    final String? message,
  }) = _$QueueStatusModelImpl;

  factory _QueueStatusModel.fromJson(Map<String, dynamic> json) =
      _$QueueStatusModelImpl.fromJson;

  @override
  String get state;
  @override
  String? get shift;
  @override
  @JsonKey(name: 'current_queue_number')
  int? get currentQueueNumber;
  @override
  @JsonKey(name: 'current_booking')
  BookingModel? get currentBooking;
  @override
  String? get message;

  /// Create a copy of QueueStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueueStatusModelImplCopyWith<_$QueueStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
