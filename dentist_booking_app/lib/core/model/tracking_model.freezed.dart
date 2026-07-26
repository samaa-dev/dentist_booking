// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrackingModel _$TrackingModelFromJson(Map<String, dynamic> json) {
  return _TrackingModel.fromJson(json);
}

/// @nodoc
mixin _$TrackingModel {
  @JsonKey(name: 'booking')
  BookingModel get booking => throw _privateConstructorUsedError;
  @JsonKey(name: 'queue_stats')
  QueueStatsModel get queueStats => throw _privateConstructorUsedError;

  /// Serializes this TrackingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackingModelCopyWith<TrackingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackingModelCopyWith<$Res> {
  factory $TrackingModelCopyWith(
    TrackingModel value,
    $Res Function(TrackingModel) then,
  ) = _$TrackingModelCopyWithImpl<$Res, TrackingModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'booking') BookingModel booking,
    @JsonKey(name: 'queue_stats') QueueStatsModel queueStats,
  });

  $BookingModelCopyWith<$Res> get booking;
  $QueueStatsModelCopyWith<$Res> get queueStats;
}

/// @nodoc
class _$TrackingModelCopyWithImpl<$Res, $Val extends TrackingModel>
    implements $TrackingModelCopyWith<$Res> {
  _$TrackingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? booking = null, Object? queueStats = null}) {
    return _then(
      _value.copyWith(
            booking: null == booking
                ? _value.booking
                : booking // ignore: cast_nullable_to_non_nullable
                      as BookingModel,
            queueStats: null == queueStats
                ? _value.queueStats
                : queueStats // ignore: cast_nullable_to_non_nullable
                      as QueueStatsModel,
          )
          as $Val,
    );
  }

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingModelCopyWith<$Res> get booking {
    return $BookingModelCopyWith<$Res>(_value.booking, (value) {
      return _then(_value.copyWith(booking: value) as $Val);
    });
  }

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueueStatsModelCopyWith<$Res> get queueStats {
    return $QueueStatsModelCopyWith<$Res>(_value.queueStats, (value) {
      return _then(_value.copyWith(queueStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TrackingModelImplCopyWith<$Res>
    implements $TrackingModelCopyWith<$Res> {
  factory _$$TrackingModelImplCopyWith(
    _$TrackingModelImpl value,
    $Res Function(_$TrackingModelImpl) then,
  ) = __$$TrackingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'booking') BookingModel booking,
    @JsonKey(name: 'queue_stats') QueueStatsModel queueStats,
  });

  @override
  $BookingModelCopyWith<$Res> get booking;
  @override
  $QueueStatsModelCopyWith<$Res> get queueStats;
}

/// @nodoc
class __$$TrackingModelImplCopyWithImpl<$Res>
    extends _$TrackingModelCopyWithImpl<$Res, _$TrackingModelImpl>
    implements _$$TrackingModelImplCopyWith<$Res> {
  __$$TrackingModelImplCopyWithImpl(
    _$TrackingModelImpl _value,
    $Res Function(_$TrackingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? booking = null, Object? queueStats = null}) {
    return _then(
      _$TrackingModelImpl(
        booking: null == booking
            ? _value.booking
            : booking // ignore: cast_nullable_to_non_nullable
                  as BookingModel,
        queueStats: null == queueStats
            ? _value.queueStats
            : queueStats // ignore: cast_nullable_to_non_nullable
                  as QueueStatsModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackingModelImpl implements _TrackingModel {
  const _$TrackingModelImpl({
    @JsonKey(name: 'booking') required this.booking,
    @JsonKey(name: 'queue_stats') required this.queueStats,
  });

  factory _$TrackingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackingModelImplFromJson(json);

  @override
  @JsonKey(name: 'booking')
  final BookingModel booking;
  @override
  @JsonKey(name: 'queue_stats')
  final QueueStatsModel queueStats;

  @override
  String toString() {
    return 'TrackingModel(booking: $booking, queueStats: $queueStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackingModelImpl &&
            (identical(other.booking, booking) || other.booking == booking) &&
            (identical(other.queueStats, queueStats) ||
                other.queueStats == queueStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, booking, queueStats);

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackingModelImplCopyWith<_$TrackingModelImpl> get copyWith =>
      __$$TrackingModelImplCopyWithImpl<_$TrackingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackingModelImplToJson(this);
  }
}

abstract class _TrackingModel implements TrackingModel {
  const factory _TrackingModel({
    @JsonKey(name: 'booking') required final BookingModel booking,
    @JsonKey(name: 'queue_stats') required final QueueStatsModel queueStats,
  }) = _$TrackingModelImpl;

  factory _TrackingModel.fromJson(Map<String, dynamic> json) =
      _$TrackingModelImpl.fromJson;

  @override
  @JsonKey(name: 'booking')
  BookingModel get booking;
  @override
  @JsonKey(name: 'queue_stats')
  QueueStatsModel get queueStats;

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackingModelImplCopyWith<_$TrackingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
