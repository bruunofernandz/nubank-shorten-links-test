import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubank_shorten_links/core/network/http_client_impl.dart';

import '../../mocks/http_client_impl_test.mocks.dart';

@GenerateMocks([Dio, Response])
void main() {
  late MockDio mockDio;
  late DioHttpClient httpClient;

  setUp(() {
    mockDio = MockDio();
    httpClient = DioHttpClient(dio: mockDio);
  });

  group('DioHttpClient', () {
    test('should post returns response', () async {
      final url = 'https://example.com';
      final responseData = {
        'alias': 'abc123',
        'url': url,
        'short_url': 'https://short.ly/abc123',
      };

      when(mockDio.post(url, data: anyNamed('data'))).thenAnswer((_) async {
        final response = Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: url),
        );
        return response;
      });

      final result = await httpClient.post(body: {'url': url}, url: url);

      expect(result.data, responseData);
      verify(mockDio.post(url, data: {'url': url})).called(1);
    });

    test('should post throws DioError when Dio throws', () async {
      final url = 'https://example.com';
      final body = {'url': url};
      final dioError = DioException(
        requestOptions: RequestOptions(path: url),
        error: 'Network error',
        type: DioExceptionType.unknown,
      );

      when(mockDio.post(url, data: body)).thenThrow(dioError);

      expect(
        () => httpClient.post(body: body, url: url),
        throwsA(isA<DioException>()),
      );
      verify(mockDio.post(url, data: body)).called(1);
    });
  });
}
