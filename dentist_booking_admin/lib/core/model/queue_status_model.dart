import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_model.dart';

part 'queue_status_model.freezed.dart';
part 'queue_status_model.g.dart';

@freezed
class QueueStatusModel with _$QueueStatusModel {
  const factory QueueStatusModel({
    required String state,
    String? shift,
    @JsonKey(name: 'current_queue_number') int? currentQueueNumber,
    @JsonKey(name: 'current_booking') BookingModel? currentBooking,
    String? message,
  }) = _QueueStatusModel;

  factory QueueStatusModel.fromJson(Map<String, dynamic> json) =>
      _$QueueStatusModelFromJson(json);
}
