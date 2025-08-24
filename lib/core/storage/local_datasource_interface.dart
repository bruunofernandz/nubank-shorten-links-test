import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

abstract class ILocalDatasource {
  Future<void> setStorage({required String key, required ShortUrlModel url});
  Future<List<ShortUrlModel>> getStorage();
  Future<void> clearStorage(String key);
}
