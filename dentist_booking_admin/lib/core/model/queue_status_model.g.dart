// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueueStatusModelImpl _$$QueueStatusModelImplFromJson(
  Map<String, dynamic> json,
) => _$QueueStatusModelImpl(
  state: json['state'] as String,
  shift: json['shift'] as String?,
  currentQueueNumber: (json['current_queue_number'] as num?)?.toInt(),
  currentBooking: json['current_booking'] == null
      ? null
      : BookingModel.fromJson(json['current_booking'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$$QueueStatusModelImplToJson(
  _$QueueStatusModelImpl instance,
) => <String, dynamic>{
  'state': instance.state,
  'shift': instance.shift,
  'current_queue_number': instance.currentQueueNumber,
  'current_booking': instance.currentBooking,
  'message': instance.message,
};
