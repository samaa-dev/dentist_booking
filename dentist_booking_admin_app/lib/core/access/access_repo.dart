import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../enum/enum.dart';
import '../util/session_guard.dart';
import 'user_access.dart';

class AccessRepo {
  AccessRepo({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  Future<UserAccess> getMyAccess({UserRole? fallbackRole}) async {
    try {
      final resp = await _client.rpc('get_my_access');
      return UserAccess.fromJson(Map<String, dynamic>.from(resp as Map));
    } on PostgrestException catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      // Server not migrated yet: keep the previous role-based behaviour.
      if (e.code == 'PGRST202' || e.code == '42883') {
        debugPrint('get_my_access missing, using role fallback');
        return UserAccess.legacyFromRole(fallbackRole);
      }
      rethrow;
    }
  }
}
