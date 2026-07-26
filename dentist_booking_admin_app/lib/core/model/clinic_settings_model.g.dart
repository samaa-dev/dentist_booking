// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClinicSetctingsModelImpl _$$ClinicSetctingsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ClinicSetctingsModelImpl(
  morningCountLimit: (json['morning_count_limit'] as num).toInt(),
  eveningCountLimit: (json['evening_count_limit'] as num).toInt(),
  isBookingEnabled: json['is_booking_enabled'] as bool,
  bookingMorningStartTime: json['booking_morning_start_time'] as String,
  allowBeforeMinutes: (json['allow_before_minutes'] as num).toInt(),
  autoConfirm: json['auto_confirm'] as bool,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  stopReason: json['stop_reason'] as String?,
  clinicPhone: json['clinic_phone'] as String?,
  minVersionPatient: json['min_version_patient'] as String?,
  minVersionAdmin: json['min_version_admin'] as String?,
  minVersionDesktop: json['min_version_desktop'] as String?,
  minVersionTv: json['min_version_tv'] as String?,
);

Map<String, dynamic> _$$ClinicSetctingsModelImplToJson(
  _$ClinicSetctingsModelImpl instance,
) => <String, dynamic>{
  'morning_count_limit': instance.morningCountLimit,
  'evening_count_limit': instance.eveningCountLimit,
  'is_booking_enabled': instance.isBookingEnabled,
  'booking_morning_start_time': instance.bookingMorningStartTime,
  'allow_before_minutes': instance.allowBeforeMinutes,
  'auto_confirm': instance.autoConfirm,
  'updated_at': instance.updatedAt.toIso8601String(),
  'stop_reason': instance.stopReason,
  'clinic_phone': instance.clinicPhone,
  'min_version_patient': instance.minVersionPatient,
  'min_version_admin': instance.minVersionAdmin,
  'min_version_desktop': instance.minVersionDesktop,
  'min_version_tv': instance.minVersionTv,
};
