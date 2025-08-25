import 'package:flutter_test/flutter_test.dart';

import '../../../../../lib/features/url_shortener/domain/entities/url_shortener_entity.dart';

void main() {
  group('ShortUrlEntity', () {
    test('should create a valid ShortUrlEntity instance', () {
      final entity = ShortUrlEntity(
        alias: 'abc123',
        originalUrl: 'https://example.com',
        shortUrl: 'https://short.ly/abc123',
      );

      expect(entity.alias, 'abc123');
      expect(entity.originalUrl, 'https://example.com');
      expect(entity.shortUrl, 'https://short.ly/abc123');
    });

    test('should support value equality', () {
      final entity1 = ShortUrlEntity(
        alias: 'alias',
        originalUrl: 'https://original.com',
        shortUrl: 'https://short.ly/alias',
      );
      final entity2 = ShortUrlEntity(
        alias: 'alias',
        originalUrl: 'https://original.com',
        shortUrl: 'https://short.ly/alias',
      );

      expect(entity1, equals(entity2));
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('should not be equal if any property differs', () {
      final entity1 = ShortUrlEntity(
        alias: 'alias1',
        originalUrl: 'https://original.com',
        shortUrl: 'https://short.ly/alias1',
      );
      final entity2 = ShortUrlEntity(
        alias: 'alias2',
        originalUrl: 'https://original.com',
        shortUrl: 'https://short.ly/alias1',
      );

      expect(entity1, isNot(equals(entity2)));
    });
  });
}
