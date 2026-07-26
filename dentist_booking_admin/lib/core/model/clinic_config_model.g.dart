// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClinicConfigModelImpl _$$ClinicConfigModelImplFromJson(
  Map<String, dynamic> json,
) => _$ClinicConfigModelImpl(
  settings: ClinicSettingsModel.fromJson(
    json['settings'] as Map<String, dynamic>,
  ),
  workingHours: (json['working_hours'] as List<dynamic>)
      .map((e) => WorkingHoursModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ClinicConfigModelImplToJson(
  _$ClinicConfigModelImpl instance,
) => <String, dynamic>{
  'settings': instance.settings,
  'working_hours': instance.workingHours,
};
