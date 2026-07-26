import 'package:dentist_booking_app/core/model/booking_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'queue_stats_model.dart';

part 'tracking_model.freezed.dart';
part 'tracking_model.g.dart';

@freezed
class TrackingModel with _$TrackingModel {
  const factory TrackingModel({
    @JsonKey(name: 'booking') required BookingModel booking,
    @JsonKey(name: 'queue_stats') required QueueStatsModel queueStats,
  }) = _TrackingModel;

  factory TrackingModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingModelFromJson(json);
}
