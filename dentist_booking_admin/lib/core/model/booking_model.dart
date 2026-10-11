import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/enum.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// Queue number without zero padding: 12 / "0012" -> "12".
String? queueNumberFromJson(dynamic value) => _queueNumberFromJson(value);

String? _queueNumberFromJson(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return int.tryParse(text)?.toString() ?? text;
}

dynamic queueNumberToJson(String? value) {
  return value; // ترسله كما هو
}

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    @JsonKey(name: 'booking_date') required DateTime bookingDate,
    // @JsonKey(name: 'booking_time') required String bookingTime,
    @JsonKey(name: "patient_id") String? patientId,
    @JsonKey(name: "patient_type") required PatientType patientType,
    @JsonKey(name: "patient_name") String? patientName,
    @JsonKey(name: "patient_phone") String? patientPhone,
    @JsonKey(name: "patient_address") String? patientAddress,
    required BookingShift shift,
    @JsonKey(name: 'booking_status') required BookingStatus bookingStatus,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_by') String? cancelledBy,
    @JsonKey(name: 'cancel_reason') String? cancelReason,
    @JsonKey(name: 'booking_created_by') String? bookingCreatedBy,

    // @JsonKey(name: 'queue_number') String? queueNumber,
    @JsonKey(
      name: 'queue_number',
      fromJson: queueNumberFromJson,
      toJson: queueNumberToJson,
    )
    String? queueNumber,

    @JsonKey(name: 'ticket_code') String? ticketCode, // إضافة حقل جديد
    @JsonKey(name: 'people_before') int? peopleBefore,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  static String? queueNumberFromJson(dynamic value) =>
      _queueNumberFromJson(value);

  static dynamic queueNumberToJson(String? value) {
    return value; // ترسله كما هو
  }
}
