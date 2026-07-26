import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/clinic_config_model.dart';

class SettingsRepo {
  final SupabaseClient _client;

  SettingsRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<ClinicConfigModel> getSettings() async {
    try {
      final response = await _client.rpc('get_full_clinic_config');

      debugPrint("Clinic Config Response: $response");

      return ClinicConfigModel.fromJson(response);
    } catch (e) {
      debugPrint("Failed to fetch Settings list: $e");
      throw Exception('Failed to fetch Settings list: $e');
    }
  }

  Future<void> updateSettings(ClinicConfigModel model) async {
    try {
      await _client.rpc(
        'save_clinic_config',
        params: {
          'p_settings': model.settings.toJson(),
          'p_hours': model.workingHours.map((e) => e.toJson()).toList(),
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Failed to update Settings: $e");
      debugPrint("Stack trace: $stackTrace");
      final message = e.toString().replaceFirst('Exception: ', '').trim();
      throw Exception(message.isEmpty ? 'Failed to update Settings: $e' : message);
    }
  }
}
