// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueueStatsModelImpl _$$QueueStatsModelImplFromJson(
  Map<String, dynamic> json,
) => _$QueueStatsModelImpl(
  isPaused: json['is_paused'] as bool,
  currentQueueNumber: (json['current_queue_number'] as num).toInt(),
  patientsBeforeYou: (json['patients_before_you'] as num).toInt(),
  lastUpdated: DateTime.parse(json['last_updated'] as String),
  totalInQueue: (json['total_in_queue'] as num).toInt(),
  estimatedWaitTime: (json['estimated_wait_time'] as num).toInt(),
);

Map<String, dynamic> _$$QueueStatsModelImplToJson(
  _$QueueStatsModelImpl instance,
) => <String, dynamic>{
  'is_paused': instance.isPaused,
  'current_queue_number': instance.currentQueueNumber,
  'patients_before_you': instance.patientsBeforeYou,
  'last_updated': instance.lastUpdated.toIso8601String(),
  'total_in_queue': instance.totalInQueue,
  'estimated_wait_time': instance.estimatedWaitTime,
};
