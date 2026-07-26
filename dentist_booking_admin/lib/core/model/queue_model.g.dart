// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueueModelImpl _$$QueueModelImplFromJson(Map<String, dynamic> json) =>
    _$QueueModelImpl(
      success: json['success'] as bool?,
      code: json['code'] as String?,
      message: json['message'] as String?,
      booking: json['booking'] == null
          ? null
          : BookingModel.fromJson(json['booking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QueueModelImplToJson(_$QueueModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'booking': instance.booking,
    };
