// data/datasources/local_data_source.dart
import 'dart:convert';

import 'package:nubank_shorten_links/core/enums/key_strings.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/datasources/local/url_shortener_local_datasource_interface.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlShortenerLocalDatasourceImpl
    implements UrlShortenerLocalDatasourceInterface {
  final SharedPreferences prefs;

  UrlShortenerLocalDatasourceImpl(this.prefs);

  @override
  Future<void> setStorage(ShortUrlModel url) async {
    await prefs.setString(KeyStrings.urlShortener.value, url.toString());
  }

  @override
  Future<List<ShortUrlModel>> getStorage() async {
    final data = prefs.getString(KeyStrings.urlShortener.value);

    if (data == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => ShortUrlModel.fromJson(e)).toList();
  }
}
