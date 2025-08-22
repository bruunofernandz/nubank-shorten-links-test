import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

abstract class UrlShortenerLocalDatasourceInterface {
  Future<void> setStorage(ShortUrlModel url);
  Future<List<ShortUrlModel>> getStorage();
}
