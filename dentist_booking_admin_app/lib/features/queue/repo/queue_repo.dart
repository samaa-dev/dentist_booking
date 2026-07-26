import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/booking_model.dart';
import '../../../core/model/queue_status_model.dart';
import '../../../generated/locale_keys.g.dart';

class QueueRepo {
  final SupabaseClient _client;

  QueueRepo({
    required SupabaseClient client,
  }) : _client = client;

  Stream<List<Map<String, dynamic>>> watchBookings() {
    return _client.from('bookings').stream(primaryKey: ['id']);
  }

  Future<QueueStatusModel> statusQueue() async {
    final now = DateTime.now().toIso8601String();
    final resp = await _client.rpc('queue_status', params: {'p_datetime': now});
    return QueueStatusModel.fromJson(_asMap(resp));
  }

  Future<Map<String, dynamic>?> nextQueue() async {
    final now = DateTime.now().toIso8601String();
    final resp = await _client.rpc('queue_next', params: {'p_datetime': now});
    if (resp == null) return null;
    return _asMap(resp);
  }

  Future<void> pauseQueue(String shift) async {
    await _client.rpc('queue_pause', params: {'p_shift': shift});
  }

  Future<void> resumeQueue(String shift) async {
    await _client.rpc('queue_resume', params: {'p_shift': shift});
  }

  Future<void> restartQueue(String shift) async {
    await _client.rpc('queue_restart', params: {'p_shift': shift});
  }

  Future<BookingModel> updateBooking(BookingModel model) async {
    debugPrint('Updating booking: $model');

    try {
      final resp = await _client.rpc(
        'update_booking_queue',
        params: {
          'p_id': model.id,
          'p_booking_date': model.bookingDate.toIso8601String(),
          'p_patient_id': model.patientId,
          'p_patient_type': model.patientType.code,
          'p_guest_name': model.patientName ?? '',
          'p_guest_phone': model.patientPhone ?? '',
          'p_guest_address': model.patientAddress ?? '',
          'p_shift': model.shift.code,
          'p_booking_status': model.bookingStatus.code,
          'p_booking_created_by': model.bookingCreatedBy,
          'p_created_at': model.createdAt.toIso8601String(),
          'p_updated_at': model.updatedAt?.toIso8601String(),
          'p_cancelled_at': model.cancelledAt?.toIso8601String(),
          'p_completed_at': model.completedAt?.toIso8601String(),
          'p_cancelled_by': model.cancelledBy,
          'p_cancel_reason': model.cancelReason,
        },
      );

      debugPrint('RPC RESPONSE UPDATE: $resp');

      if (resp == null) {
        throw Exception(LocaleKeys.unknown_booking_error.trnsltd);
      }

      final map = _asMap(resp);
      if (map['success'] == false) {
        final reason = map['reason'] ?? 'unknown_booking_error';
        final message = map['message'];
        throw Exception(
          _mapReasonToMessage(
            reason.toString(),
            message is Map ? Map<String, dynamic>.from(message) : null,
          ),
        );
      }

      return BookingModel.fromJson(
        Map<String, dynamic>.from(map['data'] as Map),
      );
    } catch (e) {
      debugPrint('❌ Failed to update booking: $e');
      throw Exception('Failed to update booking: $e');
    }
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    if (raw is List && raw.isNotEmpty) {
      final first = raw.first;
      if (first is Map) return Map<String, dynamic>.from(first);
    }
    throw Exception('Unexpected RPC response shape: ${raw.runtimeType}');
  }

  String _mapReasonToMessage(String reason, Map<String, dynamic>? message) {
    switch (reason) {
      case 'day_not_exist':
        return LocaleKeys.day_not_exist.trnsltd;
      case 'clinic_closed':
        return LocaleKeys.clinic_closed.trnsltd;
      case 'booking_disabled':
        return LocaleKeys.booking_disabled.trnsltd;
      case 'invalid_working_hours':
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
      case 'too_early_evening':
        return LocaleKeys.too_early_evening.trnsltd;
      case 'too_late_evening':
        return LocaleKeys.too_late_evening.trnsltd;
      case 'morning_full':
        return LocaleKeys.morning_full.trnsltd;
      case 'evening_full':
        return LocaleKeys.evening_full.trnsltd;
      case 'already_booked':
        return LocaleKeys.already_booked.trnsltd;
      default:
        return LocaleKeys.unknown_booking_error.trnsltd;
    }
  }
}
