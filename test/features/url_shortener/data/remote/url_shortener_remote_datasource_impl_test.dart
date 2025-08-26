import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubank_shorten_links/core/network/http_client_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/datasources/remote/url_shortener_remote_datasource_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

import '../../../../mocks/url_shortener_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([DioHttpClient, Response])
void main() {
  group('UrlShortenerRemoteDatasourceImpl', () {
    late MockDioHttpClient mockHttpClient;
    late UrlShortenerRemoteDatasourceImpl datasource;

    setUp(() {
      mockHttpClient = MockDioHttpClient();
      datasource = UrlShortenerRemoteDatasourceImpl(httpClient: mockHttpClient);
    });

    test('should return ShortUrlModel when statusCode is 200', () async {
      final url = 'https://example.com';
      final responseData = {
        'alias': 'abc123',
        'url': url,
        'short_url': 'https://short.ly/abc123',
      };
      final mockResponse = MockResponse();
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.data).thenReturn(responseData);
      when(
        mockHttpClient.post(body: anyNamed('body'), url: anyNamed('url')),
      ).thenAnswer((_) async => mockResponse);

      final result = await datasource.shortenUrl(url);

      expect(result, isA<ShortUrlModel>());
      verify(
        mockHttpClient.post(body: {'url': url}, url: anyNamed('url')),
      ).called(1);
    });

    test('should throw Exception when statusCode is not 200', () async {
      final url = 'https://example.com';
      final mockResponse = MockResponse();
      when(mockResponse.statusCode).thenReturn(400);
      when(mockResponse.statusMessage).thenReturn('Bad Request');
      when(
        mockHttpClient.post(body: anyNamed('body'), url: anyNamed('url')),
      ).thenAnswer((_) async => mockResponse);

      expect(() => datasource.shortenUrl(url), throwsA(isA<Exception>()));
      verify(
        mockHttpClient.post(body: {'url': url}, url: anyNamed('url')),
      ).called(1);
    });
  });
}
