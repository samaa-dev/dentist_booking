// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_hours_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkingHoursModelImpl _$$WorkingHoursModelImplFromJson(
  Map<String, dynamic> json,
) => _$WorkingHoursModelImpl(
  id: json['id'] as String,
  dayOfWeek: (json['day_of_week'] as num).toInt(),
  isOpen: json['is_open'] as bool,
  morningStart: json['morning_start'] as String?,
  morningEnd: json['morning_end'] as String?,
  eveningStart: json['evening_start'] as String?,
  eveningEnd: json['evening_end'] as String?,
  morningIsOpen: json['morning_is_open'] as bool? ?? true,
  eveningIsOpen: json['evening_is_open'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$WorkingHoursModelImplToJson(
  _$WorkingHoursModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'day_of_week': instance.dayOfWeek,
  'is_open': instance.isOpen,
  'morning_start': instance.morningStart,
  'morning_end': instance.morningEnd,
  'evening_start': instance.eveningStart,
  'evening_end': instance.eveningEnd,
  'morning_is_open': instance.morningIsOpen,
  'evening_is_open': instance.eveningIsOpen,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
