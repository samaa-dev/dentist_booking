import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/booking_model.dart';
import 'booking_list_mapper.dart';

class BookingRepo {
  final SupabaseClient _client;

  BookingRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<List<BookingModel>> getBookings({
    required DateTime? startDate,
    required DateTime? endDate,
    required String? searchQuery,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('not_authenticated');
    }

    final isSearchEmpty = searchQuery == null || searchQuery.trim().isEmpty;
    final start = startDate?.toIso8601String().split('T').first;
    final end = endDate?.toIso8601String().split('T').first;

    try {
      debugPrint('📥 Calling RPC: get_my_bookings_for_date_range');
      debugPrint(
        '📥 Params: auth.uid=${user.id}, p_start_date=$start, p_end_date=$end',
      );

      final response = await _client.rpc(
        'get_my_bookings_for_date_range',
        params: {
          'p_start_date': start,
          'p_end_date': end,
          'p_search_query': isSearchEmpty ? null : searchQuery.trim(),
        },
      );

      debugPrint('📥 RPC Response type: ${response.runtimeType}');
      debugPrint(
        '📥 RPC Response length: ${response is List ? response.length : 'N/A'}',
      );

      if (response is List && response.isNotEmpty) {
        debugPrint('📥 First booking JSON: ${response[0]}');
        debugPrint(
          '📥 First booking patient_name: ${response[0]['patient_name']}',
        );
        debugPrint(
          '📥 First booking patient_id: ${response[0]['patient_id']}',
        );
        debugPrint(
          '📥 First booking ticket_code: ${response[0]['ticket_code']}',
        );
      }

      return BookingListMapper.mapRpcResponse(response);
    } catch (e, st) {
      debugPrint('❌ Failed to fetch bookings: $e');
      debugPrint('$st');
      // Preserve original cause so UI can distinguish empty vs hard failure.
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> watchBookings() {
    return _client.from('bookings').stream(primaryKey: ['id']);
  }

  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    final response = await _client.rpc(
      'cancel_booking',
      params: {
        'p_booking_id': bookingId,
        'p_cancel_reason': reason,
      },
    );

    if (response == null) {
      throw Exception('Empty response from cancel_booking');
    }

    if (response['success'] == false) {
      final message = response['message']?.toString();
      throw Exception(message ?? 'Failed to cancel booking');
    }
  }
}
