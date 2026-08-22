import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/dashboard_stats_model.dart';
import '../../../core/util/session_guard.dart';

class DashboardRepo {
  final SupabaseClient _client;

  DashboardRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final resp = await _client.rpc('get_dashboard_stats').single();

      return DashboardStatsModel.fromJson(resp);
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("Failed to fetch dashboard stats: $e");
      throw Exception('Failed to fetch dashboard stats: $e');
    }
  }
}
