// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackingModel _$TrackingModelFromJson(Map<String, dynamic> json) =>
    _TrackingModel(
      booking: BookingModel.fromJson(json['booking'] as Map<String, dynamic>),
      queueStats: QueueStatsModel.fromJson(
        json['queue_stats'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$TrackingModelToJson(_TrackingModel instance) =>
    <String, dynamic>{
      'booking': instance.booking,
      'queue_stats': instance.queueStats,
    };
