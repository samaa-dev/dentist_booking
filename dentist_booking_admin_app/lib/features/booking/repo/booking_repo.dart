import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/booking_model.dart';

class BookingRepo {
  final SupabaseClient _client;

  BookingRepo({required SupabaseClient client}) : _client = client;

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
          .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch bookings: $e');
      throw Exception('Failed to fetch bookings');
    }
  }

  Stream<List<Map<String, dynamic>>> getBookingsStream() {
    return _client.from('bookings').stream(primaryKey: ['id']);
  }
}
