// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdsModel _$AdsModelFromJson(Map<String, dynamic> json) => _AdsModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  body: json['body'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  linkUrl: json['link_url'] as String?,
);

Map<String, dynamic> _$AdsModelToJson(_AdsModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'images': instance.images,
  'link_url': instance.linkUrl,
};
