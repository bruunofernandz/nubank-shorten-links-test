import 'package:dio/dio.dart';

abstract class IHttpClient {
  Future<Response<dynamic>> get(String url);
  Future<Response<dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
  });
}
