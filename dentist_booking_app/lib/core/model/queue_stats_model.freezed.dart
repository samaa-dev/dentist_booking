// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QueueStatsModel _$QueueStatsModelFromJson(Map<String, dynamic> json) {
  return _QueueStatsModel.fromJson(json);
}

/// @nodoc
mixin _$QueueStatsModel {
  @JsonKey(name: 'is_paused')
  bool get isPaused => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_queue_number')
  int get currentQueueNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'patients_before_you')
  int get patientsBeforeYou => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_in_queue')
  int get totalInQueue => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_wait_time')
  int get estimatedWaitTime => throw _privateConstructorUsedError;

  /// Serializes this QueueStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueueStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueueStatsModelCopyWith<QueueStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueStatsModelCopyWith<$Res> {
  factory $QueueStatsModelCopyWith(
    QueueStatsModel value,
    $Res Function(QueueStatsModel) then,
  ) = _$QueueStatsModelCopyWithImpl<$Res, QueueStatsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'is_paused') bool isPaused,
    @JsonKey(name: 'current_queue_number') int currentQueueNumber,
    @JsonKey(name: 'patients_before_you') int patientsBeforeYou,
    @JsonKey(name: 'last_updated') DateTime lastUpdated,
    @JsonKey(name: 'total_in_queue') int totalInQueue,
    @JsonKey(name: 'estimated_wait_time') int estimatedWaitTime,
  });
}

/// @nodoc
class _$QueueStatsModelCopyWithImpl<$Res, $Val extends QueueStatsModel>
    implements $QueueStatsModelCopyWith<$Res> {
  _$QueueStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueueStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPaused = null,
    Object? currentQueueNumber = null,
    Object? patientsBeforeYou = null,
    Object? lastUpdated = null,
    Object? totalInQueue = null,
    Object? estimatedWaitTime = null,
  }) {
    return _then(
      _value.copyWith(
            isPaused: null == isPaused
                ? _value.isPaused
                : isPaused // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentQueueNumber: null == currentQueueNumber
                ? _value.currentQueueNumber
                : currentQueueNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            patientsBeforeYou: null == patientsBeforeYou
                ? _value.patientsBeforeYou
                : patientsBeforeYou // ignore: cast_nullable_to_non_nullable
                      as int,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalInQueue: null == totalInQueue
                ? _value.totalInQueue
                : totalInQueue // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedWaitTime: null == estimatedWaitTime
                ? _value.estimatedWaitTime
                : estimatedWaitTime // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QueueStatsModelImplCopyWith<$Res>
    implements $QueueStatsModelCopyWith<$Res> {
  factory _$$QueueStatsModelImplCopyWith(
    _$QueueStatsModelImpl value,
    $Res Function(_$QueueStatsModelImpl) then,
  ) = __$$QueueStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'is_paused') bool isPaused,
    @JsonKey(name: 'current_queue_number') int currentQueueNumber,
    @JsonKey(name: 'patients_before_you') int patientsBeforeYou,
    @JsonKey(name: 'last_updated') DateTime lastUpdated,
    @JsonKey(name: 'total_in_queue') int totalInQueue,
    @JsonKey(name: 'estimated_wait_time') int estimatedWaitTime,
  });
}

/// @nodoc
class __$$QueueStatsModelImplCopyWithImpl<$Res>
    extends _$QueueStatsModelCopyWithImpl<$Res, _$QueueStatsModelImpl>
    implements _$$QueueStatsModelImplCopyWith<$Res> {
  __$$QueueStatsModelImplCopyWithImpl(
    _$QueueStatsModelImpl _value,
    $Res Function(_$QueueStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPaused = null,
    Object? currentQueueNumber = null,
    Object? patientsBeforeYou = null,
    Object? lastUpdated = null,
    Object? totalInQueue = null,
    Object? estimatedWaitTime = null,
  }) {
    return _then(
      _$QueueStatsModelImpl(
        isPaused: null == isPaused
            ? _value.isPaused
            : isPaused // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentQueueNumber: null == currentQueueNumber
            ? _value.currentQueueNumber
            : currentQueueNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        patientsBeforeYou: null == patientsBeforeYou
            ? _value.patientsBeforeYou
            : patientsBeforeYou // ignore: cast_nullable_to_non_nullable
                  as int,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalInQueue: null == totalInQueue
            ? _value.totalInQueue
            : totalInQueue // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedWaitTime: null == estimatedWaitTime
            ? _value.estimatedWaitTime
            : estimatedWaitTime // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QueueStatsModelImpl implements _QueueStatsModel {
  const _$QueueStatsModelImpl({
    @JsonKey(name: 'is_paused') required this.isPaused,
    @JsonKey(name: 'current_queue_number') required this.currentQueueNumber,
    @JsonKey(name: 'patients_before_you') required this.patientsBeforeYou,
    @JsonKey(name: 'last_updated') required this.lastUpdated,
    @JsonKey(name: 'total_in_queue') required this.totalInQueue,
    @JsonKey(name: 'estimated_wait_time') required this.estimatedWaitTime,
  });

  factory _$QueueStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueueStatsModelImplFromJson(json);

  @override
  @JsonKey(name: 'is_paused')
  final bool isPaused;
  @override
  @JsonKey(name: 'current_queue_number')
  final int currentQueueNumber;
  @override
  @JsonKey(name: 'patients_before_you')
  final int patientsBeforeYou;
  @override
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  @override
  @JsonKey(name: 'total_in_queue')
  final int totalInQueue;
  @override
  @JsonKey(name: 'estimated_wait_time')
  final int estimatedWaitTime;

  @override
  String toString() {
    return 'QueueStatsModel(isPaused: $isPaused, currentQueueNumber: $currentQueueNumber, patientsBeforeYou: $patientsBeforeYou, lastUpdated: $lastUpdated, totalInQueue: $totalInQueue, estimatedWaitTime: $estimatedWaitTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueStatsModelImpl &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.currentQueueNumber, currentQueueNumber) ||
                other.currentQueueNumber == currentQueueNumber) &&
            (identical(other.patientsBeforeYou, patientsBeforeYou) ||
                other.patientsBeforeYou == patientsBeforeYou) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.totalInQueue, totalInQueue) ||
                other.totalInQueue == totalInQueue) &&
            (identical(other.estimatedWaitTime, estimatedWaitTime) ||
                other.estimatedWaitTime == estimatedWaitTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isPaused,
    currentQueueNumber,
    patientsBeforeYou,
    lastUpdated,
    totalInQueue,
    estimatedWaitTime,
  );

  /// Create a copy of QueueStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueStatsModelImplCopyWith<_$QueueStatsModelImpl> get copyWith =>
      __$$QueueStatsModelImplCopyWithImpl<_$QueueStatsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QueueStatsModelImplToJson(this);
  }
}

abstract class _QueueStatsModel implements QueueStatsModel {
  const factory _QueueStatsModel({
    @JsonKey(name: 'is_paused') required final bool isPaused,
    @JsonKey(name: 'current_queue_number')
    required final int currentQueueNumber,
    @JsonKey(name: 'patients_before_you') required final int patientsBeforeYou,
    @JsonKey(name: 'last_updated') required final DateTime lastUpdated,
    @JsonKey(name: 'total_in_queue') required final int totalInQueue,
    @JsonKey(name: 'estimated_wait_time') required final int estimatedWaitTime,
  }) = _$QueueStatsModelImpl;

  factory _QueueStatsModel.fromJson(Map<String, dynamic> json) =
      _$QueueStatsModelImpl.fromJson;

  @override
  @JsonKey(name: 'is_paused')
  bool get isPaused;
  @override
  @JsonKey(name: 'current_queue_number')
  int get currentQueueNumber;
  @override
  @JsonKey(name: 'patients_before_you')
  int get patientsBeforeYou;
  @override
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated;
  @override
  @JsonKey(name: 'total_in_queue')
  int get totalInQueue;
  @override
  @JsonKey(name: 'estimated_wait_time')
  int get estimatedWaitTime;

  /// Create a copy of QueueStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueueStatsModelImplCopyWith<_$QueueStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
