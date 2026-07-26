import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClinicSettingsRepo {
  final SupabaseClient _client;

  ClinicSettingsRepo({
    required SupabaseClient client,
  }) : _client = client;

  /// Fetches clinic phone from clinic_settings via get_full_clinic_config.
  /// Returns null if not set or on error.
  Future<String?> getClinicPhone() async {
    try {
      final response = await _client.rpc('get_full_clinic_config');
      if (response == null || response is! Map) return null;
      final settings = response['settings'];
      if (settings == null || settings is! Map) return null;
      final phone = settings['clinic_phone'];
      return phone is String ? (phone.trim().isEmpty ? null : phone) : null;
    } catch (e) {
      debugPrint('ClinicSettingsRepo.getClinicPhone: $e');
      return null;
    }
  }
}
