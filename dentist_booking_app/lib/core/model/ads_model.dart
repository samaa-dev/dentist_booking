import 'package:freezed_annotation/freezed_annotation.dart';

part 'ads_model.freezed.dart';
part 'ads_model.g.dart';

@freezed
class AdsModel with _$AdsModel {
  const factory AdsModel({
    String? id,
    String? title,
    String? body,
    List<String>? images,
    @JsonKey(name: 'link_url') String? linkUrl,
  }) = _AdsModel;

  factory AdsModel.fromJson(Map<String, dynamic> json) => _$AdsModelFromJson(json);
}
