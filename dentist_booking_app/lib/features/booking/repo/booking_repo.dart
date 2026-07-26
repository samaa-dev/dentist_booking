import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/booking_model.dart';

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
    try {
      final isSearchEmpty = searchQuery == null || searchQuery.trim().isEmpty;

      debugPrint("📥 Calling RPC: get_all_bookings_with_filters_app");
      debugPrint("📥 Params: p_user_id=${_client.auth.currentUser!.id}, p_start_date=${startDate?.toIso8601String().split('T').first}, p_end_date=${endDate?.toIso8601String().split('T').first}");

      final response = await _client.rpc(
        'get_all_bookings_with_filters_app',
        params: {
          'p_user_id': _client.auth.currentUser!.id,
          'p_start_date': startDate?.toIso8601String().split('T').first,
          'p_end_date': endDate?.toIso8601String().split('T').first,
          'p_search_query': isSearchEmpty ? null : searchQuery,
        },
      );

      // ✅ إضافة debug logging
      debugPrint("📥 RPC Response type: ${response.runtimeType}");
      debugPrint("📥 RPC Response length: ${response is List ? response.length : 'N/A'}");
      
      if (response is List && response.isNotEmpty) {
        debugPrint("📥 First booking JSON: ${response[0]}");
        debugPrint("📥 First booking patient_name: ${response[0]['patient_name']}");
        debugPrint("📥 First booking guest_name: ${response[0]['guest_name']}");
        debugPrint("📥 First booking patient_id: ${response[0]['patient_id']}");
        debugPrint("📥 First booking patient_type: ${response[0]['patient_type']}");
      }

      return (response as List)
          .map((item) {
            // ✅ إضافة debug logging قبل parsing
            debugPrint("📥 Parsing booking: id=${item['id']}, patient_name=${item['patient_name']}, guest_name=${item['guest_name']}");
            return BookingModel.fromJson(item);
          })
          .toList();
    } catch (e) {
      debugPrint("❌ Failed to fetch bookings: $e");
      throw Exception("Failed to fetch bookings");
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
