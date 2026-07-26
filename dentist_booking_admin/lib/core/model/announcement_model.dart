import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

@freezed
class AnnouncementModel with _$AnnouncementModel {
  const factory AnnouncementModel({
    required String id,
    required String title,
    required String body,
    @Default([]) List<String> images,
    @JsonKey(name: "link_url") String? linkUrl,
    required String audience,
    @JsonKey(name: "is_active") required bool isActive,
    @JsonKey(name: "created_by_user_id") required String createdByUserId,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);
}
