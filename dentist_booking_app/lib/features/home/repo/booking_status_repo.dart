import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/booking_status_model.dart';

class BookingStatusRepo {
  final SupabaseClient _client;

  BookingStatusRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<BookingStatusModel> getBookingStatus() async {
    final now = DateTime.now().toIso8601String();

    try {
      final response = await _client.rpc(
        'get_booking_status',
        params: {
          "p_datetime": now,
        },
      );

      debugPrint(response.toString());

      return BookingStatusModel.fromJson(response);
    } catch (e) {
      debugPrint("Error getting booking status: $e");
      throw Exception('Error getting booking status: $e');
    }
  }
}
