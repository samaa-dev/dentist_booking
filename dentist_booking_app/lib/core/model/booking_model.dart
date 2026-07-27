import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/enum.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

String? queueNumberFromJson(dynamic value) {
  if (value == null) return null;
  return value.toString(); // يحول int → String
}

dynamic queueNumberToJson(String? value) {
  return value; // ترسله كما هو
}

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    String? id,
    @JsonKey(name: "booking_date") required DateTime bookingDate,
    // @JsonKey(name: 'booking_time') required String bookingTime,
    @JsonKey(name: "patient_id") String? patientId,
    @JsonKey(name: "patient_name") String? patientName,
    @JsonKey(name: "patient_phone") String? patientPhone,
    @JsonKey(name: "patient_address") String? patientAddress,
    @JsonKey(name: "patient_type") PatientType? patientType,
    required BookingShift shift,
    @JsonKey(name: "booking_status") BookingStatus? bookingStatus,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "cancelled_at") DateTime? cancelledAt,
    @JsonKey(name: "completed_at") DateTime? completedAt,
    @JsonKey(name: "cancelled_by") String? cancelledBy,
    @JsonKey(name: "cancel_reason") String? cancelReason,
    @JsonKey(name: "booking_created_by") String? bookingCreatedBy,

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

  // Must use _$BookingModelFromJson so freezed also generates toJson
  // (required by TrackingModel nested serialization).
  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
