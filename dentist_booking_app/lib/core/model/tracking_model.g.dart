// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackingModelImpl _$$TrackingModelImplFromJson(Map<String, dynamic> json) =>
    _$TrackingModelImpl(
      booking: BookingModel.fromJson(json['booking'] as Map<String, dynamic>),
      queueStats: QueueStatsModel.fromJson(
        json['queue_stats'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$TrackingModelImplToJson(_$TrackingModelImpl instance) =>
    <String, dynamic>{
      'booking': instance.booking,
      'queue_stats': instance.queueStats,
    };
