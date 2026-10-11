import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/util/session_guard.dart';
import '../model/clinic_statistics.dart';

class StatisticsRepo {
  StatisticsRepo({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  Future<ClinicStatistics> getStatistics({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final resp = await _client.rpc(
        'get_clinic_statistics',
        params: {'p_from': _date(from), 'p_to': _date(to)},
      );
      return ClinicStatistics.fromJson(Map<String, dynamic>.from(resp as Map));
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint('Failed to load statistics: $e');
      rethrow;
    }
  }

  static String _date(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
