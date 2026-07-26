import 'dart:io';

import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/model/announcement_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../repo/announcement_repo.dart';

part 'announcement_cubit.freezed.dart';
part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepo _announcementRepo;
  final SupabaseClient _client;

  AnnouncementCubit({
    required AnnouncementRepo announcementRepo,
    required SupabaseClient client,
  }) : _announcementRepo = announcementRepo,
       _client = client,
       super(AnnouncementState.initial());

  Future<void> getAllAnnouncements() async {
    emit(const AnnouncementState.loading());
    try {
      final announcementList = await _announcementRepo.getAllAnnouncements();

      debugPrint('announcementList list: $announcementList');

      emit(AnnouncementState.loaded(announcementList));
    } catch (e) {
      debugPrint('Error loading announcement: $e');
      emit(AnnouncementState.error(LocaleKeys.announcement_error_load.trnsltd));
    }
  }

  Future<void> createAnnouncement({
    required AnnouncementModel announcement,
    required List<File> newImages,
  }) async {
    emit(AnnouncementState.loadingAnnouncement());

    try {
      String? uploadedImage;

      if (newImages.isNotEmpty) {
        uploadedImage = await _announcementRepo.uploadImage(
          folderName: "announcements",
          filePath: newImages.first.path,
        );
      }

      final updatedAnnouncement = announcement.copyWith(
        images: uploadedImage != null ? [uploadedImage] : [],
        createdByUserId: _client.auth.currentUser!.id,
      );

      final created = await _announcementRepo.createAnnouncement(
        updatedAnnouncement,
      );
      final list = await _announcementRepo.getAllAnnouncements();

      emit(AnnouncementState.successAddAnnouncement(created));
      emit(AnnouncementState.loaded(list));
    } catch (e) {
      emit(
        AnnouncementState.errorAddAnnouncement(
          LocaleKeys.announcement_error_create.trnsltd,
        ),
      );
    }
  }

  Future<void> updateAnnouncement({
    required AnnouncementModel announcement,
    required List<File> newImages,
    required List<String> removedImages,
  }) async {
    emit(AnnouncementState.loadingAnnouncement());

    try {
      String? uploadedImage;

      // رفع الصورة الجديدة
      if (newImages.isNotEmpty) {
        uploadedImage = await _announcementRepo.uploadImage(
          folderName: "announcements",
          filePath: newImages.first.path,
        );
      }

      // الصورة النهائية = الجديدة OR القديمة إذا لم يرفع المستخدم صورة جديدة
      final finalImage =
          uploadedImage ??
          (announcement.images.isNotEmpty ? announcement.images.first : null);

      final updatedModel = announcement.copyWith(
        images: finalImage != null ? [finalImage] : [],
        updatedAt: DateTime.now(),
        createdByUserId: _client.auth.currentUser!.id,
      );

      final updated = await _announcementRepo.updateAnnouncement(updatedModel);
      final list = await _announcementRepo.getAllAnnouncements();

      emit(AnnouncementState.successUpdateAnnouncement(updated));
      emit(AnnouncementState.loaded(list));
    } catch (e) {
      emit(
        AnnouncementState.errorUpdateAnnouncement(
          LocaleKeys.announcement_error_update.trnsltd,
        ),
      );
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    emit(AnnouncementState.loadingAnnouncement());
    try {
      await _announcementRepo.deleteAnnouncement(id);

      final list = await _announcementRepo.getAllAnnouncements();

      emit(AnnouncementState.loaded(list));
      emit(AnnouncementState.successDeleteAnnouncement(null));
    } catch (e) {
      emit(
        AnnouncementState.errorDeleteAnnouncement(
          LocaleKeys.announcement_error_delete.trnsltd,
        ),
      );
    }
  }
}
