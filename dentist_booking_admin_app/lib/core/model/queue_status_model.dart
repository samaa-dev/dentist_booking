import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_model.dart';

part 'queue_status_model.freezed.dart';

@freezed
class QueueStatusModel with _$QueueStatusModel {
  const factory QueueStatusModel({
    required String state,
    String? shift,
    @JsonKey(name: 'current_queue_number') int? currentQueueNumber,
    @JsonKey(name: 'current_booking') BookingModel? currentBooking,
    @JsonKey(name: 'waiting_count') int? waitingCount,
    String? message,
  }) = _QueueStatusModel;

  factory QueueStatusModel.fromJson(Map<String, dynamic> json) {
    BookingModel? currentBooking;
    final rawBooking = json['current_booking'];
    if (rawBooking is Map) {
      try {
        currentBooking = BookingModel.fromJson(
          Map<String, dynamic>.from(rawBooking),
        );
      } catch (_) {
        currentBooking = null;
      }
    }

    return QueueStatusModel(
      state: json['state'] as String? ?? 'UNKNOWN',
      shift: json['shift'] as String?,
      currentQueueNumber: (json['current_queue_number'] as num?)?.toInt(),
      currentBooking: currentBooking,
      waitingCount: (json['waiting_count'] as num?)?.toInt(),
      message: json['message'] as String?,
    );
  }
}
