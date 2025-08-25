import 'package:flutter_test/flutter_test.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

void main() {
  group('ShortUrlModel', () {
    test('should be a subclass of UrlShortenerEntity', () {
      final json = {
        'alias': 'abc123',
        'originalUrl': 'https://example.com',
        'shortUrl': 'https://short.ly/abc123',
      };

      final model = ShortUrlModel.fromJson(json);

      expect(model.alias, 'abc123');
      expect(model.originalUrl, 'https://example.com');
      expect(model.shortUrl, 'https://short.ly/abc123');
    });

    test('should return empty strings when json is null', () {
      final json = {'alias': null, 'originalUrl': null, 'shortUrl': null};

      final model = ShortUrlModel.fromJson(json);

      expect(model.alias, '');
      expect(model.originalUrl, '');
      expect(model.shortUrl, '');
    });

    test('should convert to json', () {
      final model = ShortUrlModel(
        alias: 'alias1',
        originalUrl: 'https://original.com',
        shortUrl: 'https://short.com/alias1',
      );

      final json = model.toJson();

      expect(json, {
        'alias': 'alias1',
        'originalUrl': 'https://original.com',
        'shortUrl': 'https://short.com/alias1',
      });
    });
  });
}
