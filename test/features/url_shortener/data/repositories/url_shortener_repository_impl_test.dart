import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/repositories/url_shortener_repository_impl.dart';

import '../../../../mocks/url_shortener_repository_impl_test.mocks.dart';

void main() {
  late UrlShortenerRepositoryImpl repository;
  late MockIUrlShortenerRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockIUrlShortenerRemoteDatasource();
    repository = UrlShortenerRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
    );
  });

  group('UrlShortenerRepositoryImpl', () {
    const testUrl = 'https://example.com';
    final shortUrlModel = ShortUrlModel(
      originalUrl: testUrl,
      shortUrl: 'https://short.ly/abc123',
      alias: 'abc123',
    );

    test('should return ShortUrlModel when shortenUrl is successful', () async {
      var rightResult;
      // arrange
      when(
        mockRemoteDatasource.shortenUrl(testUrl),
      ).thenAnswer((_) async => shortUrlModel);

      // act
      final result = await repository.shortenUrl(testUrl);

      result.fold(
        ifLeft: (Failure value) {},
        ifRight: (ShortUrlModel value) {
          rightResult = value;
        },
      );

      // assert
      expect(result.isRight, isTrue);
      expect(rightResult, shortUrlModel);
      verify(mockRemoteDatasource.shortenUrl(testUrl)).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return Failure when shortenUrl throws exception', () async {
      // arrange
      final exception = Exception('Network error');
      when(mockRemoteDatasource.shortenUrl(testUrl)).thenThrow(exception);

      // act
      final result = await repository.shortenUrl(testUrl);

      // assert
      expect(result.isLeft, isTrue);

      result.fold(
        ifLeft: (l) {
          expect(l, isA<UnknownFailure>());
        },
        ifRight: (r) => {},
      );

      verify(mockRemoteDatasource.shortenUrl(testUrl)).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });
}
