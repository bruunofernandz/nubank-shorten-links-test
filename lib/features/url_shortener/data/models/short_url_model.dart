import 'package:nubank_shorten_links/features/url_shortener/domain/entities/short_url_entity.dart';

class ShortUrlModel extends ShortUrlEntity {
  ShortUrlModel({
    required super.alias,
    required super.originalUrl,
    required super.shortUrl,
  });

  factory ShortUrlModel.fromJson(Map<String, dynamic> json) {
    return ShortUrlModel(
      alias: json['alias'] as String,
      originalUrl: json['originalUrl'] as String,
      shortUrl: json['shortUrl'] as String,
    );
  }
}
