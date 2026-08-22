import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/profile_model.dart';
import '../../../core/util/session_guard.dart';

class PatientRepo {
  final SupabaseClient _client;

  PatientRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<List<ProfileModel>> getAllPatients() async {
    try {
      final response = await _client.rpc('get_all_patients').select();

      debugPrint("response: $response");

      return response
          .map<ProfileModel>((e) => ProfileModel.fromJson(e))
          .toList();
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      debugPrint("Failed to fetch patient list: $e");
      throw Exception('Failed to fetch patient list: $e');
    }
  }

  Future<ProfileModel> updatePatient(ProfileModel patient) async {
    try {
      final resp = await _client
          .rpc(
            'update_patient',
            params: {
              'p_user_id': patient.userId,
              'p_meta': patient.meta,
              'p_role': patient.role,
              'p_status': patient.status,
            },
          )
          .select()
          .single();

      return ProfileModel.fromJson(resp);
    } catch (e) {
      final sessionError = SessionGuard.asSessionExpired(e);
      if (sessionError != null) throw sessionError;
      throw Exception('Failed to update patient: $e');
    }
  }
}
