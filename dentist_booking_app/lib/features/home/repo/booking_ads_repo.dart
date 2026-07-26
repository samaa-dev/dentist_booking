import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/ads_model.dart';

class BookingAdsRepo {
  final SupabaseClient _client;

  BookingAdsRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<List<AdsModel>> getBookinAds() async {
    try {
      final List<dynamic> response = await _client.rpc('get_app_ads');

      debugPrint("Response: $response");

      return response.map((e) {
        return AdsModel.fromJson(e as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint("Error getting booking Ads: $e");
      throw Exception('Error getting booking Ads: $e');
    }
  }
}
