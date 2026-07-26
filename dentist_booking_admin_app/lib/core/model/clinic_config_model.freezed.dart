// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinic_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ClinicConfigModel _$ClinicConfigModelFromJson(Map<String, dynamic> json) {
  return _ClinicConfigModel.fromJson(json);
}

/// @nodoc
mixin _$ClinicConfigModel {
  ClinicSettingsModel get settings => throw _privateConstructorUsedError;
  @JsonKey(name: "working_hours")
  List<WorkingHoursModel> get workingHours =>
      throw _privateConstructorUsedError;

  /// Serializes this ClinicConfigModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClinicConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClinicConfigModelCopyWith<ClinicConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClinicConfigModelCopyWith<$Res> {
  factory $ClinicConfigModelCopyWith(
    ClinicConfigModel value,
    $Res Function(ClinicConfigModel) then,
  ) = _$ClinicConfigModelCopyWithImpl<$Res, ClinicConfigModel>;
  @useResult
  $Res call({
    ClinicSettingsModel settings,
    @JsonKey(name: "working_hours") List<WorkingHoursModel> workingHours,
  });

  $ClinicSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class _$ClinicConfigModelCopyWithImpl<$Res, $Val extends ClinicConfigModel>
    implements $ClinicConfigModelCopyWith<$Res> {
  _$ClinicConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClinicConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null, Object? workingHours = null}) {
    return _then(
      _value.copyWith(
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as ClinicSettingsModel,
            workingHours: null == workingHours
                ? _value.workingHours
                : workingHours // ignore: cast_nullable_to_non_nullable
                      as List<WorkingHoursModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of ClinicConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClinicSettingsModelCopyWith<$Res> get settings {
    return $ClinicSettingsModelCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ClinicConfigModelImplCopyWith<$Res>
    implements $ClinicConfigModelCopyWith<$Res> {
  factory _$$ClinicConfigModelImplCopyWith(
    _$ClinicConfigModelImpl value,
    $Res Function(_$ClinicConfigModelImpl) then,
  ) = __$$ClinicConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ClinicSettingsModel settings,
    @JsonKey(name: "working_hours") List<WorkingHoursModel> workingHours,
  });

  @override
  $ClinicSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class __$$ClinicConfigModelImplCopyWithImpl<$Res>
    extends _$ClinicConfigModelCopyWithImpl<$Res, _$ClinicConfigModelImpl>
    implements _$$ClinicConfigModelImplCopyWith<$Res> {
  __$$ClinicConfigModelImplCopyWithImpl(
    _$ClinicConfigModelImpl _value,
    $Res Function(_$ClinicConfigModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClinicConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null, Object? workingHours = null}) {
    return _then(
      _$ClinicConfigModelImpl(
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as ClinicSettingsModel,
        workingHours: null == workingHours
            ? _value._workingHours
            : workingHours // ignore: cast_nullable_to_non_nullable
                  as List<WorkingHoursModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClinicConfigModelImpl implements _ClinicConfigModel {
  const _$ClinicConfigModelImpl({
    required this.settings,
    @JsonKey(name: "working_hours")
    required final List<WorkingHoursModel> workingHours,
  }) : _workingHours = workingHours;

  factory _$ClinicConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClinicConfigModelImplFromJson(json);

  @override
  final ClinicSettingsModel settings;
  final List<WorkingHoursModel> _workingHours;
  @override
  @JsonKey(name: "working_hours")
  List<WorkingHoursModel> get workingHours {
    if (_workingHours is EqualUnmodifiableListView) return _workingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workingHours);
  }

  @override
  String toString() {
    return 'ClinicConfigModel(settings: $settings, workingHours: $workingHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClinicConfigModelImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            const DeepCollectionEquality().equals(
              other._workingHours,
              _workingHours,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    settings,
    const DeepCollectionEquality().hash(_workingHours),
  );

  /// Create a copy of ClinicConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClinicConfigModelImplCopyWith<_$ClinicConfigModelImpl> get copyWith =>
      __$$ClinicConfigModelImplCopyWithImpl<_$ClinicConfigModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ClinicConfigModelImplToJson(this);
  }
}

abstract class _ClinicConfigModel implements ClinicConfigModel {
  const factory _ClinicConfigModel({
    required final ClinicSettingsModel settings,
    @JsonKey(name: "working_hours")
    required final List<WorkingHoursModel> workingHours,
  }) = _$ClinicConfigModelImpl;

  factory _ClinicConfigModel.fromJson(Map<String, dynamic> json) =
      _$ClinicConfigModelImpl.fromJson;

  @override
  ClinicSettingsModel get settings;
  @override
  @JsonKey(name: "working_hours")
  List<WorkingHoursModel> get workingHours;

  /// Create a copy of ClinicConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClinicConfigModelImplCopyWith<_$ClinicConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
