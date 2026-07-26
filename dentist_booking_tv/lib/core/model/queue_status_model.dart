import 'next_booking_display.dart';

/// Queue status from RPC queue_status (TV display).
class QueueStatusModel {
  const QueueStatusModel({
    required this.state,
    this.shift,
    this.currentQueueNumber,
    this.currentBooking,
    this.nextBooking,
    this.message,
    this.waitingCount,
  });

  final String state;
  final String? shift;
  final int? currentQueueNumber;
  /// The booking currently being served (queue_number = current_queue_number).
  final NextBookingDisplay? currentBooking;
  /// The next confirmed booking after the current one.
  final NextBookingDisplay? nextBooking;
  final String? message;
  final int? waitingCount;

  /// Queue is active but no number has been called yet (aligned with admin `isNotStarted`).
  bool get isQueueNotStarted =>
      state == 'NORMAL' && (currentQueueNumber ?? 0) == 0;

  /// NORMAL, or last-patient phase: NO_MORE_* with a called number (overlay/TTS tracking).
  bool get hasActiveCurrentTurn =>
      state == 'NORMAL' ||
      (state.startsWith('NO_MORE_BOOKINGS') && (currentQueueNumber ?? 0) > 0);

  factory QueueStatusModel.fromJson(Map<String, dynamic> json) {
    final cb = json['current_booking'];
    final nb = json['next_booking'];
    return QueueStatusModel(
      state: json['state'] as String,
      shift: json['shift'] as String?,
      currentQueueNumber: (json['current_queue_number'] as num?)?.toInt(),
      currentBooking: cb is Map<String, dynamic>
          ? NextBookingDisplay.fromJson(cb)
          : null,
      nextBooking: nb is Map<String, dynamic>
          ? NextBookingDisplay.fromJson(nb)
          : null,
      message: json['message'] as String?,
      waitingCount: (json['waiting_count'] as num?)?.toInt(),
    );
  }
}
