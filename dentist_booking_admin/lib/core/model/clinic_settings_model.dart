import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic_settings_model.freezed.dart';
part 'clinic_settings_model.g.dart';

@freezed
class ClinicSettingsModel with _$ClinicSettingsModel {
  const factory ClinicSettingsModel({
    @JsonKey(name: "morning_count_limit") required int morningCountLimit,
    @JsonKey(name: "evening_count_limit") required int eveningCountLimit,

    // @JsonKey(name: "emergency_limit") required int emergencyLimit,
    @JsonKey(name: "is_booking_enabled") required bool isBookingEnabled,
    @JsonKey(name: "booking_morning_start_time")
    required String bookingMorningStartTime,
    // @JsonKey(name: "booking_end_time") required String bookingEndTime,
    @JsonKey(name: "allow_before_minutes") required int allowBeforeMinutes,

    @JsonKey(name: "auto_confirm") required bool autoConfirm,

    // @JsonKey(name: "allow_weekend") required bool allowWeekend,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
    @JsonKey(name: "stop_reason") String? stopReason,
    @JsonKey(name: "clinic_phone") String? clinicPhone,
    @JsonKey(name: "ticket_note") String? ticketNote,
  }) = _ClinicSetctingsModel;

  factory ClinicSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicSettingsModelFromJson(json);
}
