import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

abstract class IUrlShortenerRemoteDatasource {
  Future<ShortUrlModel> shortenUrl(String url);
}
