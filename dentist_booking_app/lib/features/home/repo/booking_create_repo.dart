import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/booking_model.dart';
import '../../../generated/locale_keys.g.dart';

class BookingCreateRepo {
  final SupabaseClient _client;

  BookingCreateRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<BookingModel> createBooking(BookingModel model) async {
    debugPrint("SENDING TIMESTAMP -> ${model.bookingDate.toIso8601String()}");

    try {
      final resp = await _client.rpc(
        'create_booking',
        params: {
          "p_booking_date": model.bookingDate.toIso8601String(),
          "p_patient_id": model.patientId,
          "p_patient_type": model.patientType?.code ?? "registered",
          "p_guest_name": model.patientName ?? "",
          "p_guest_phone": model.patientPhone ?? "",
          "p_guest_address": model.patientAddress ?? "",
          "p_shift": model.shift.code,
          "p_booking_status": "pending",
          "p_booking_created_by": _client.auth.currentUser?.id,
          "p_created_at": DateTime.now().toIso8601String(),
          "p_updated_at": DateTime.now().toIso8601String(),
          "p_cancelled_at": null,
          "p_completed_at": null,
          "p_cancelled_by": null,
          "p_cancel_reason": null,
        },
      );

      if (resp is! Map) {
        throw Exception(LocaleKeys.unknown_booking_error.tr());
      }

      final response = Map<String, dynamic>.from(resp);

      if (response['success'] == false) {
        final reason = response['reason'] ?? "unknown_booking_error";
        final message = response['message'];

        debugPrint("❌ Failed to create booking: ${response['reason']}");
        throw Exception(
          _mapReasonToMessage(
            reason.toString(),
            message is Map ? Map<String, dynamic>.from(message) : null,
          ),
        );
      }

      debugPrint("✅ RPC RESPONSE: $response");

      final data = response['data'];
      if (data is! Map) {
        throw Exception(LocaleKeys.unknown_booking_error.tr());
      }

      final normalized = _normalizeCreateBookingData(
        Map<String, dynamic>.from(data),
      );
      debugPrint("✅ RPC DATA CREATE: $normalized");

      return BookingModel.fromJson(normalized);
    } catch (e) {
      debugPrint("❌ Failed to create booking: $e");
      throw Exception('Failed to create booking: $e');
    }
  }

  /// create_booking returns guest_* fields; BookingModel expects patient_*.
  Map<String, dynamic> _normalizeCreateBookingData(Map<String, dynamic> data) {
    return {
      ...data,
      'id': data['id']?.toString(),
      'patient_id': data['patient_id']?.toString(),
      'booking_created_by': data['booking_created_by']?.toString(),
      'cancelled_by': data['cancelled_by']?.toString(),
      'patient_name': data['patient_name'] ?? data['guest_name'],
      'patient_phone': data['patient_phone'] ?? data['guest_phone'],
      'patient_address': data['patient_address'] ?? data['guest_address'],
    };
  }

  String _mapReasonToMessage(String reason, Map<String, dynamic>? message) {
    switch (reason) {
      case "day_not_exist":
        return LocaleKeys.day_not_exist.trnsltd;
      case "clinic_closed":
        return LocaleKeys.clinic_closed.trnsltd;
      case "morning_closed":
        return LocaleKeys.morning_shift_closed_today.trnsltd;
      case "evening_closed":
        return LocaleKeys.evening_shift_closed_today.trnsltd;
      case "booking_disabled":
        return LocaleKeys.booking_disabled.trnsltd;
      case "invalid_working_hours":
        return LocaleKeys.invalid_working_hours.trnsltd;
      case 'too_early_morning':
        final allowedStart = message?['allowed_start']?.toString() ?? '';
        return LocaleKeys.too_early_morning.tr(
          namedArgs: {
            'allowed_start': allowedStart,
          },
        );
      case 'too_late_morning':
        return LocaleKeys.too_late_morning.trnsltd;
      case "too_early_evening":
        return LocaleKeys.too_early_evening.trnsltd;
      case "too_late_evening":
        return LocaleKeys.too_late_evening.trnsltd;
      case "morning_full":
        return LocaleKeys.morning_full.trnsltd;
      case 'evening_full':
        return LocaleKeys.evening_full.trnsltd;
      case 'already_booked':
        return LocaleKeys.already_booked.trnsltd;
      case 'already_has_self_booking_today':
        return LocaleKeys.already_has_active_booking.trnsltd;
      case 'patient_name_required':
        return LocaleKeys.error_patient_name_required.trnsltd;
      default:
        return LocaleKeys.unknown_booking_error.trnsltd;
    }
  }
}
