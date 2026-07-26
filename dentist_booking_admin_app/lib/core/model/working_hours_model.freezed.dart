// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'working_hours_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkingHoursModel _$WorkingHoursModelFromJson(Map<String, dynamic> json) {
  return _WorkingHoursModel.fromJson(json);
}

/// @nodoc
mixin _$WorkingHoursModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: "day_of_week")
  int get dayOfWeek => throw _privateConstructorUsedError;
  @JsonKey(name: "is_open")
  bool get isOpen => throw _privateConstructorUsedError;
  @JsonKey(name: "morning_start")
  String? get morningStart => throw _privateConstructorUsedError;
  @JsonKey(name: "morning_end")
  String? get morningEnd => throw _privateConstructorUsedError;
  @JsonKey(name: "evening_start")
  String? get eveningStart => throw _privateConstructorUsedError;
  @JsonKey(name: "evening_end")
  String? get eveningEnd => throw _privateConstructorUsedError;
  @JsonKey(name: "created_at")
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: "updated_at")
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WorkingHoursModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkingHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkingHoursModelCopyWith<WorkingHoursModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkingHoursModelCopyWith<$Res> {
  factory $WorkingHoursModelCopyWith(
    WorkingHoursModel value,
    $Res Function(WorkingHoursModel) then,
  ) = _$WorkingHoursModelCopyWithImpl<$Res, WorkingHoursModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: "day_of_week") int dayOfWeek,
    @JsonKey(name: "is_open") bool isOpen,
    @JsonKey(name: "morning_start") String? morningStart,
    @JsonKey(name: "morning_end") String? morningEnd,
    @JsonKey(name: "evening_start") String? eveningStart,
    @JsonKey(name: "evening_end") String? eveningEnd,
    @JsonKey(name: "created_at") DateTime createdAt,
    @JsonKey(name: "updated_at") DateTime updatedAt,
  });
}

/// @nodoc
class _$WorkingHoursModelCopyWithImpl<$Res, $Val extends WorkingHoursModel>
    implements $WorkingHoursModelCopyWith<$Res> {
  _$WorkingHoursModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkingHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? isOpen = null,
    Object? morningStart = freezed,
    Object? morningEnd = freezed,
    Object? eveningStart = freezed,
    Object? eveningEnd = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            dayOfWeek: null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            isOpen: null == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            morningStart: freezed == morningStart
                ? _value.morningStart
                : morningStart // ignore: cast_nullable_to_non_nullable
                      as String?,
            morningEnd: freezed == morningEnd
                ? _value.morningEnd
                : morningEnd // ignore: cast_nullable_to_non_nullable
                      as String?,
            eveningStart: freezed == eveningStart
                ? _value.eveningStart
                : eveningStart // ignore: cast_nullable_to_non_nullable
                      as String?,
            eveningEnd: freezed == eveningEnd
                ? _value.eveningEnd
                : eveningEnd // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkingHoursModelImplCopyWith<$Res>
    implements $WorkingHoursModelCopyWith<$Res> {
  factory _$$WorkingHoursModelImplCopyWith(
    _$WorkingHoursModelImpl value,
    $Res Function(_$WorkingHoursModelImpl) then,
  ) = __$$WorkingHoursModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: "day_of_week") int dayOfWeek,
    @JsonKey(name: "is_open") bool isOpen,
    @JsonKey(name: "morning_start") String? morningStart,
    @JsonKey(name: "morning_end") String? morningEnd,
    @JsonKey(name: "evening_start") String? eveningStart,
    @JsonKey(name: "evening_end") String? eveningEnd,
    @JsonKey(name: "created_at") DateTime createdAt,
    @JsonKey(name: "updated_at") DateTime updatedAt,
  });
}

/// @nodoc
class __$$WorkingHoursModelImplCopyWithImpl<$Res>
    extends _$WorkingHoursModelCopyWithImpl<$Res, _$WorkingHoursModelImpl>
    implements _$$WorkingHoursModelImplCopyWith<$Res> {
  __$$WorkingHoursModelImplCopyWithImpl(
    _$WorkingHoursModelImpl _value,
    $Res Function(_$WorkingHoursModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkingHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? isOpen = null,
    Object? morningStart = freezed,
    Object? morningEnd = freezed,
    Object? eveningStart = freezed,
    Object? eveningEnd = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$WorkingHoursModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dayOfWeek: null == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        isOpen: null == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        morningStart: freezed == morningStart
            ? _value.morningStart
            : morningStart // ignore: cast_nullable_to_non_nullable
                  as String?,
        morningEnd: freezed == morningEnd
            ? _value.morningEnd
            : morningEnd // ignore: cast_nullable_to_non_nullable
                  as String?,
        eveningStart: freezed == eveningStart
            ? _value.eveningStart
            : eveningStart // ignore: cast_nullable_to_non_nullable
                  as String?,
        eveningEnd: freezed == eveningEnd
            ? _value.eveningEnd
            : eveningEnd // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkingHoursModelImpl implements _WorkingHoursModel {
  const _$WorkingHoursModelImpl({
    required this.id,
    @JsonKey(name: "day_of_week") required this.dayOfWeek,
    @JsonKey(name: "is_open") required this.isOpen,
    @JsonKey(name: "morning_start") this.morningStart,
    @JsonKey(name: "morning_end") this.morningEnd,
    @JsonKey(name: "evening_start") this.eveningStart,
    @JsonKey(name: "evening_end") this.eveningEnd,
    @JsonKey(name: "created_at") required this.createdAt,
    @JsonKey(name: "updated_at") required this.updatedAt,
  });

  factory _$WorkingHoursModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkingHoursModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: "day_of_week")
  final int dayOfWeek;
  @override
  @JsonKey(name: "is_open")
  final bool isOpen;
  @override
  @JsonKey(name: "morning_start")
  final String? morningStart;
  @override
  @JsonKey(name: "morning_end")
  final String? morningEnd;
  @override
  @JsonKey(name: "evening_start")
  final String? eveningStart;
  @override
  @JsonKey(name: "evening_end")
  final String? eveningEnd;
  @override
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @override
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WorkingHoursModel(id: $id, dayOfWeek: $dayOfWeek, isOpen: $isOpen, morningStart: $morningStart, morningEnd: $morningEnd, eveningStart: $eveningStart, eveningEnd: $eveningEnd, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkingHoursModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.morningStart, morningStart) ||
                other.morningStart == morningStart) &&
            (identical(other.morningEnd, morningEnd) ||
                other.morningEnd == morningEnd) &&
            (identical(other.eveningStart, eveningStart) ||
                other.eveningStart == eveningStart) &&
            (identical(other.eveningEnd, eveningEnd) ||
                other.eveningEnd == eveningEnd) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    dayOfWeek,
    isOpen,
    morningStart,
    morningEnd,
    eveningStart,
    eveningEnd,
    createdAt,
    updatedAt,
  );

  /// Create a copy of WorkingHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkingHoursModelImplCopyWith<_$WorkingHoursModelImpl> get copyWith =>
      __$$WorkingHoursModelImplCopyWithImpl<_$WorkingHoursModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkingHoursModelImplToJson(this);
  }
}

abstract class _WorkingHoursModel implements WorkingHoursModel {
  const factory _WorkingHoursModel({
    required final String id,
    @JsonKey(name: "day_of_week") required final int dayOfWeek,
    @JsonKey(name: "is_open") required final bool isOpen,
    @JsonKey(name: "morning_start") final String? morningStart,
    @JsonKey(name: "morning_end") final String? morningEnd,
    @JsonKey(name: "evening_start") final String? eveningStart,
    @JsonKey(name: "evening_end") final String? eveningEnd,
    @JsonKey(name: "created_at") required final DateTime createdAt,
    @JsonKey(name: "updated_at") required final DateTime updatedAt,
  }) = _$WorkingHoursModelImpl;

  factory _WorkingHoursModel.fromJson(Map<String, dynamic> json) =
      _$WorkingHoursModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: "day_of_week")
  int get dayOfWeek;
  @override
  @JsonKey(name: "is_open")
  bool get isOpen;
  @override
  @JsonKey(name: "morning_start")
  String? get morningStart;
  @override
  @JsonKey(name: "morning_end")
  String? get morningEnd;
  @override
  @JsonKey(name: "evening_start")
  String? get eveningStart;
  @override
  @JsonKey(name: "evening_end")
  String? get eveningEnd;
  @override
  @JsonKey(name: "created_at")
  DateTime get createdAt;
  @override
  @JsonKey(name: "updated_at")
  DateTime get updatedAt;

  /// Create a copy of WorkingHoursModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkingHoursModelImplCopyWith<_$WorkingHoursModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
