import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/enum.dart';

part 'booking_status_model.freezed.dart';
part 'booking_status_model.g.dart';

@freezed
class BookingStatusModel with _$BookingStatusModel {
  const factory BookingStatusModel({
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'shift') BookingShift? shift,
    @JsonKey(name: 'time_left') int? timeLeft,
    @JsonKey(name: 'is_booking_enabled') bool? isBookingEnabled,
    @JsonKey(name: 'stop_reason') String? stopReason,
    /// When set, the current clock window's shift is closed for booking.
    @JsonKey(name: 'shift_closed') BookingShift? shiftClosed,
  }) = _$BookingStatusModelImpl;

  factory BookingStatusModel.fromJson(Map<String, dynamic> json) =>
      _$BookingStatusModelFromJson(json);
}
