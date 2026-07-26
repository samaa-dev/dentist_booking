import 'package:dentist_booking_tv/core/model/queue_status_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QueueRepo {
  QueueRepo({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  Stream<List<Map<String, dynamic>>> watchBookings() {
    return _client.from('bookings').stream(primaryKey: ['id']);
  }

  Stream<List<Map<String, dynamic>>> watchQueueState() {
    return _client.from('queue_state').stream(primaryKey: ['shift']);
  }

  Future<QueueStatusModel> statusQueue() async {
    final now = DateTime.now().toIso8601String();
    final resp = await _client.rpc(
      'queue_status',
      params: {'p_datetime': now},
    );
    if (resp == null) {
      throw Exception('Failed to get queue status');
    }
    return QueueStatusModel.fromJson(resp as Map<String, dynamic>);
  }
}
