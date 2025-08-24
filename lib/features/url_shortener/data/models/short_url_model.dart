import 'package:nubank_shorten_links/features/url_shortener/domain/entities/url_shortener_entity.dart';

class ShortUrlModel extends ShortUrlEntity {
  ShortUrlModel({
    required super.alias,
    required super.originalUrl,
    required super.shortUrl,
  });

  factory ShortUrlModel.fromJson(Map<String, dynamic> json) {
    final shortUrl =
        json['shortUrl'] as String? ??
        (json['_links']?['short'] as String? ?? '');

    return ShortUrlModel(
      alias: json['alias'] as String? ?? '',
      originalUrl: json['originalUrl'] as String? ?? '',
      shortUrl: shortUrl,
    );
  }
  Map<String, dynamic> toJson() {
    return {'alias': alias, 'originalUrl': originalUrl, 'shortUrl': shortUrl};
  }
}
