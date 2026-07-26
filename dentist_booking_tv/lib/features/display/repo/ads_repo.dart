import 'package:dentist_booking_tv/core/model/ads_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdsRepo {
  AdsRepo({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  Future<List<AdsModel>> getAppAds() async {
    final response = await _client.rpc('get_app_ads');
    if (response == null) return [];
    final list = response as List<dynamic>;
    return list
        .map((e) => AdsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
