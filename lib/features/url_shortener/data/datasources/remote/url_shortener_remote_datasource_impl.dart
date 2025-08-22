import 'package:nubank_shorten_links/core/network/http_client_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/datasources/remote/url_shortener_remote_datasource_interface.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

class UrlShortenerRemoteDatasourceImpl
    implements IUrlShortenerRemoteDatasource {
  final DioHttpClient httpClient;
  final String baseUrl = 'https://url-shortener-server.onrender.com/api/alias';

  UrlShortenerRemoteDatasourceImpl({required this.httpClient});

  @override
  Future<ShortUrlModel> shortenUrl(String url) async {
    final response = await httpClient.post(body: {'url': url}, url: baseUrl);

    if (response.statusCode == 201) {
      return ShortUrlModel.fromJson(response.data);
    }

    throw Exception('Failed to shorten URL: ${response.statusMessage}');
  }
}
