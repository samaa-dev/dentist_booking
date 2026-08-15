import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/enum.dart';

part 'booking_status_model.freezed.dart';
part 'booking_status_model.g.dart';

@freezed
class BookingStatusModel with _$BookingStatusModel {
  const BookingStatusModel._();

  const factory BookingStatusModel({
    @JsonKey(name: 'is_open') bool? isOpen,
    @JsonKey(name: 'shift') BookingShift? shift,
    @JsonKey(name: 'time_left') int? timeLeft,
    @JsonKey(name: 'is_booking_enabled') bool? isBookingEnabled,
    @JsonKey(name: 'stop_reason') String? stopReason,
    /// When set, the current clock window's shift is closed for booking.
    @JsonKey(name: 'shift_closed') BookingShift? shiftClosed,
    /// Legacy: set only when no remaining bookable shift (blocks old clients).
    @JsonKey(name: 'shift_full') BookingShift? shiftFull,
    @JsonKey(name: 'morning_full') bool? morningFull,
    @JsonKey(name: 'evening_full') bool? eveningFull,
    @JsonKey(name: 'morning_available') bool? morningAvailable,
    @JsonKey(name: 'evening_available') bool? eveningAvailable,
  }) = _$BookingStatusModelImpl;

  factory BookingStatusModel.fromJson(Map<String, dynamic> json) =>
      _$BookingStatusModelFromJson(json);

  /// True when patients may still open the booking flow.
  bool get hasAnyBookableShift {
    if (morningAvailable != null || eveningAvailable != null) {
      return (morningAvailable ?? false) || (eveningAvailable ?? false);
    }
    // Legacy payload fallback
    return (isOpen ?? false) && shiftFull == null;
  }

  bool isShiftFull(BookingShift shift) {
    switch (shift) {
      case BookingShift.morning:
        if (morningFull != null) return morningFull!;
        return shiftFull == BookingShift.morning;
      case BookingShift.evening:
        if (eveningFull != null) return eveningFull!;
        return shiftFull == BookingShift.evening;
    }
  }

  bool isShiftAvailable(BookingShift shift) {
    switch (shift) {
      case BookingShift.morning:
        if (morningAvailable != null) return morningAvailable!;
        return hasAnyBookableShift &&
            shiftFull != BookingShift.morning &&
            shiftClosed != BookingShift.morning;
      case BookingShift.evening:
        if (eveningAvailable != null) return eveningAvailable!;
        return hasAnyBookableShift &&
            shiftFull != BookingShift.evening &&
            shiftClosed != BookingShift.evening;
    }
  }

  /// Prefer current clock shift when still bookable; otherwise first available.
  BookingShift? get preferredAvailableShift {
    final current = shift;
    if (current != null && isShiftAvailable(current)) return current;
    if (isShiftAvailable(BookingShift.morning)) return BookingShift.morning;
    if (isShiftAvailable(BookingShift.evening)) return BookingShift.evening;
    return null;
  }
}
