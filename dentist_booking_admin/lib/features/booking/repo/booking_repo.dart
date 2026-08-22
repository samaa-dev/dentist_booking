import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/booking_model.dart';
import '../../../core/model/profile_model.dart';
import '../../../core/util/session_guard.dart';
import '../../../generated/locale_keys.g.dart';

class BookingRepo {
  final SupabaseClient _client;

  BookingRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<List<BookingModel>> getAllBookings() async {
    try {
      final response = await _client.rpc('get_all_bookings').select();

      return response
          .map<BookingModel>((e) => BookingModel.fromJson(e))
          .toList();
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("Failed to fetch bookings list: $e");
      throw Exception("Failed to fetch bookings");
    }
  }

  Future<List<ProfileModel>> getAllPatients() async {
    try {
      final response = await _client
          .rpc(
            'get_all_patients',
          )
          .select();

      return response
          .map<ProfileModel>((e) => ProfileModel.fromJson(e))
          .toList();
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("Failed to fetch patients list: $e");
      throw Exception("Failed to fetch patients");
    }
  }

  Future<BookingModel> createBooking(BookingModel model) async {
    debugPrint("SENDING TIMESTAMP -> ${model.bookingDate.toIso8601String()}");

    try {
      final resp = await _client
          .rpc(
            'create_booking',

            params: {
              "p_booking_date": model.bookingDate.toIso8601String(),

              "p_patient_id": model.patientId,
              "p_patient_type": model.patientType.code,

              "p_guest_name": model.patientName ?? "",
              "p_guest_phone": model.patientPhone ?? "",
              "p_guest_address": model.patientAddress ?? "",

              "p_shift": model.shift.code,
              "p_booking_status": model.bookingStatus.code,

              "p_created_at": model.createdAt.toIso8601String(),
              "p_updated_at": model.updatedAt?.toIso8601String(),

              "p_cancelled_at": model.cancelledAt?.toIso8601String(),
              "p_completed_at": model.completedAt?.toIso8601String(),

              "p_cancelled_by": model.cancelledBy,
              "p_cancel_reason": model.cancelReason,
              "p_booking_created_by": model.bookingCreatedBy,
            },
          )
          .select()
          .single();
      // ===== تحقق من نجاح عملية الحجز =====
      if (resp['success'] == false) {
        final reason = resp['reason'] ?? "unknown_booking_error";
        final message = resp['message'];

        debugPrint("❌ Failed to create booking: ${resp['reason']}");
        throw Exception(_mapReasonToMessage(reason, message));
      }

      debugPrint("RPC RESPONSE dddd:  $resp");

      final data = resp['data'];
      if (data == null) {
        throw Exception(LocaleKeys.unknown_booking_error.trnsltd);
      }

      debugPrint("RPC DATA CREATE: ${resp['data']}");

      return BookingModel.fromJson(resp['data'] as Map<String, dynamic>);
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("❌ Failed to create booking: $e");
      throw Exception('Failed to create booking: $e');
    }
  }

  Future<BookingModel> updateBooking(BookingModel model) async {
    debugPrint("Updating booking: $model");

    try {
      final resp = await _client.rpc(
        'update_booking',
        params: {
          "p_id": model.id,
          "p_booking_date": model.bookingDate.toIso8601String(),
          "p_patient_id": model.patientId,
          "p_patient_type": model.patientType.code,
          "p_guest_name": model.patientName ?? "",
          "p_guest_phone": model.patientPhone ?? "",
          "p_guest_address": model.patientAddress ?? "",
          "p_shift": model.shift.code,
          "p_booking_status": model.bookingStatus.code,
          "p_booking_created_by": model.bookingCreatedBy,
          "p_created_at": model.createdAt.toIso8601String(),
          "p_updated_at": model.updatedAt?.toIso8601String(),
          "p_cancelled_at": model.cancelledAt?.toIso8601String(),
          "p_completed_at": model.completedAt?.toIso8601String(),
          "p_cancelled_by": model.cancelledBy,
          "p_cancel_reason": model.cancelReason,
        },
      );

      debugPrint("RPC RESPONSE UPDATE: $resp");

      if (resp == null) {
        throw Exception(LocaleKeys.unknown_booking_error.trnsltd);
      }

      if (resp['success'] == false) {
        final reason = resp['reason'] ?? "unknown_booking_error";
        final message = resp['message'];
        throw Exception(_mapReasonToMessage(reason, message));
      }

      return BookingModel.fromJson(resp['data']);
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("❌ Failed to update booking: $e");
      throw Exception('Failed to update booking: $e');
    }
  }

  String _mapReasonToMessage(String reason, Map<String, dynamic>? message) {
    switch (reason) {
      case "day_not_exist":
        return LocaleKeys.day_not_exist.trnsltd;
      case "clinic_closed":
        return LocaleKeys.clinic_closed.trnsltd;
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
        return LocaleKeys.already_booked.trnsltd;
      case 'patient_name_required':
        return LocaleKeys.error_patient_name_required.trnsltd;
      default:
        return LocaleKeys.unknown_booking_error.trnsltd;
    }
  }

  Future<bool> deleteBooking(String bookingId) async {
    try {
      final resp = await _client.rpc(
        'delete_booking',
        params: {
          "p_booking_id": bookingId,
        },
      );

      if (resp == null) {
        throw Exception("Empty response from delete_booking()");
      }

      if (resp['success'] == false) {
        debugPrint("Delete failed: ${resp['reason']}");
        return false;
      }

      return true;
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("❌ Failed to delete booking: $e");
      throw Exception("Failed to delete booking: $e");
    }
  }

  Future<List<BookingModel>> getBookingsWithFilters({
    required BookingStatus? status,
    required BookingShift? shift,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? searchQuery,
  }) async {
    try {
      final isSearchEmpty = searchQuery == null || searchQuery.trim().isEmpty;

      final response = await _client.rpc(
        'get_all_bookings_with_filters',
        params: {
          'p_status': status?.code,
          'p_shift': shift?.code,
          'p_start_date': startDate?.toIso8601String().split('T').first,
          'p_end_date': endDate?.toIso8601String().split('T').first,
          'p_search_query': isSearchEmpty ? null : searchQuery,
        },
      );

      return (response as List)
          .map((item) => BookingModel.fromJson(item))
          .toList();
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("Failed to fetch bookings: $e");
      throw Exception("Failed to fetch bookings");
    }
  }

  Stream<Map<BookingStatus, int>> getBookingStatusCountsStream() {
    return _client.from('bookings').stream(primaryKey: ['id']).map((rows) {
      final counts = <BookingStatus, int>{
        for (var s in BookingStatus.values) s: 0,
      };

      for (final row in rows) {
        final statusString = row['booking_status'] as String;
        final status = BookingStatus.values.firstWhere(
          (e) => e.code == statusString,
        );
        counts[status] = (counts[status] ?? 0) + 1;
      }

      return counts;
    });
  }

  Stream<List<Map<String, dynamic>>> getBookingsStream() {
    return _client.from('bookings').stream(primaryKey: ['id']);
  }
}
