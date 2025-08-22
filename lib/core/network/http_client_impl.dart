import 'package:dio/dio.dart';
import 'package:nubank_shorten_links/core/network/http_client_interface.dart';

class DioHttpClient implements IHttpClient {
  final Dio _dio;

  DioHttpClient(this._dio);
  @override
  Future<Response<dynamic>> get(String url) async {
    final response = await _dio.get(url);
    return response.data;
  }

  @override
  Future<Response<dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await _dio.post(url, data: body);
    return response;
  }
}
