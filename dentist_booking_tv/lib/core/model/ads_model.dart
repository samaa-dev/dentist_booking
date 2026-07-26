/// Ads/banners from RPC get_app_ads.

class AdsModel {
  const AdsModel({this.id, this.title, this.body, this.images, this.linkUrl});

  final String? id;
  final String? title;
  final String? body;
  final List<String>? images;
  final String? linkUrl;

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    final imagesJson = json['images'];
    return AdsModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      images: imagesJson is List<dynamic>
          ? imagesJson.map((e) => e.toString()).toList()
          : null,
      linkUrl: json['link_url'] as String?,
    );
  }
}
