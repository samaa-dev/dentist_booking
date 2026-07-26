import 'package:flutter/foundation.dart';
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // ✅ إضافة debug logging
    debugPrint("📥 BookingModel.fromJson - Input JSON keys: ${json.keys.toList()}");
    debugPrint("📥 BookingModel.fromJson - patient_name from JSON: ${json['patient_name']}");
    debugPrint("📥 BookingModel.fromJson - guest_name from JSON: ${json['guest_name']}");
    debugPrint("📥 BookingModel.fromJson - patient_id: ${json['patient_id']}");
    debugPrint("📥 BookingModel.fromJson - patient_type: ${json['patient_type']}");

    final result = _$$BookingModelImplFromJson(json);

    debugPrint("📥 BookingModel.fromJson - Result patientName: ${result.patientName}");
    debugPrint("📥 BookingModel.fromJson - Result patientPhone: ${result.patientPhone}");
    debugPrint("📥 BookingModel.fromJson - Result patientAddress: ${result.patientAddress}");

    return result;
  }

  static String? queueNumberFromJson(dynamic value) {
    if (value == null) return null;
    return value.toString(); // يحول int → String
  }

  static dynamic queueNumberToJson(String? value) {
    return value; // ترسله كما هو
  }
}
