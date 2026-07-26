import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/model/announcement_model.dart';

class AnnouncementRepo {
  final SupabaseClient _client;

  AnnouncementRepo({
    required SupabaseClient client,
  }) : _client = client;

  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    try {
      final response = await _client.rpc('get_all_announcements').select();

      debugPrint("response: $response");

      return (response as List)
          .map((e) => AnnouncementModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ Failed to fetch announcements list: $e");
      throw Exception('Failed to fetch announcements list: $e');
    }
  }

  Future<AnnouncementModel> createAnnouncement(
    AnnouncementModel announcement,
  ) async {
    try {
      final resp = await _client
          .rpc(
            'create_announcement',
            params: {
              'p_title': announcement.title,
              'p_body': announcement.body,
              'p_audience': announcement.audience,
              'p_images': announcement.images,

              'p_link_url': announcement.linkUrl,
              'p_is_active': announcement.isActive,

              'p_created_by_user_id': announcement.createdByUserId,
            },
          )
          .select()
          .single();

      return AnnouncementModel.fromJson(resp);
    } catch (e) {
      debugPrint("❌ Failed to create announcement: $e");
      throw Exception('Failed to create announcement: $e');
    }
  }

  Future<AnnouncementModel> updateAnnouncement(
    AnnouncementModel announcement,
  ) async {
    try {
      final resp = await _client
          .rpc(
            'update_announcement',
            params: {
              'p_id': announcement.id,
              'p_title': announcement.title,
              'p_body': announcement.body,
              'p_audience': announcement.audience,
              'p_images': announcement.images,
              'p_link_url': announcement.linkUrl,
              'p_is_active': announcement.isActive,
              'p_updated_by_user_id': announcement.createdByUserId,
            },
          )
          .select()
          .single();

      return AnnouncementModel.fromJson(resp);
    } catch (e) {
      debugPrint("❌ Failed to update announcement: $e");
      throw Exception('Failed to update announcement: $e');
    }
  }

  Future<String> deleteAnnouncement(String id) async {
    try {
      final resp = await _client
          .rpc(
            'delete_announcement',
            params: {'p_id': id},
          )
          .select()
          .single();

      return resp['deleted_id'] as String;
    } catch (e) {
      throw Exception("Failed to delete announcement: $e");
    }
  }

  Future<String?> uploadImage({
    required String folderName,
    required String filePath,
  }) async {
    final client = Supabase.instance.client;

    try {
      final file = File(filePath);
      final fileExt = filePath.split('.').last;
      final userId = client.auth.currentUser!.id;

      // مسار التخزين الصحيح بدون double slash
      final fileName =
          '$folderName/$userId/${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      // رفع الصورة
      await client.storage
          .from('assets')
          .upload(
            fileName,
            file,
            fileOptions: FileOptions(contentType: 'image/$fileExt'),
          );

      // الحصول على الرابط
      final imageUrl = client.storage.from('assets').getPublicUrl(fileName);

      return imageUrl;
    } on StorageException catch (e) {
      throw Exception('Failed to upload image: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
