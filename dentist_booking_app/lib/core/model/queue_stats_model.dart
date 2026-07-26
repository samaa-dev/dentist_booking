import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_stats_model.freezed.dart';
part 'queue_stats_model.g.dart';

@freezed
class QueueStatsModel with _$QueueStatsModel {
  const factory QueueStatsModel({
    @JsonKey(name: 'is_paused') required bool isPaused,
    @JsonKey(name: 'current_queue_number') required int currentQueueNumber,
    @JsonKey(name: 'patients_before_you') required int patientsBeforeYou,
    @JsonKey(name: 'last_updated') required DateTime lastUpdated,
    @JsonKey(name: 'total_in_queue') required int totalInQueue,
    @JsonKey(name: 'estimated_wait_time') required int estimatedWaitTime,
  }) = _QueueStatsModel;

  factory QueueStatsModel.fromJson(Map<String, dynamic> json) =>
      _$QueueStatsModelFromJson(json);
}
