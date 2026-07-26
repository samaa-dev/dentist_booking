// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffModelImpl _$$StaffModelImplFromJson(Map<String, dynamic> json) =>
    _$StaffModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      position: $enumDecode(_$StaffPositionEnumMap, json['position']),
      shiftType: $enumDecode(_$ShiftTypeEnumMap, json['shift_type']),
      status: $enumDecode(_$AccountStatusEnumMap, json['account_status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StaffModelImplToJson(_$StaffModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'position': _$StaffPositionEnumMap[instance.position]!,
      'shift_type': _$ShiftTypeEnumMap[instance.shiftType]!,
      'account_status': _$AccountStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$StaffPositionEnumMap = {
  StaffPosition.nurse: 'nurse',
  StaffPosition.receptionist: 'receptionist',
  StaffPosition.assistant: 'assistant',
  StaffPosition.technician: 'technician',
  StaffPosition.cleaner: 'cleaner',
  StaffPosition.manager: 'manager',
};

const _$ShiftTypeEnumMap = {
  ShiftType.morning: 'morning',
  ShiftType.evening: 'evening',
  ShiftType.mixed: 'mixed',
};

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.vacation: 'vacation',
  AccountStatus.suspended: 'suspended',
  AccountStatus.resigned: 'resigned',
  AccountStatus.inactive: 'inactive',
  AccountStatus.terminated: 'terminated',
  AccountStatus.banned: 'banned',
  AccountStatus.paused: 'paused',
  AccountStatus.appMaintenance: 'appMaintenance',
};
