import 'dart:convert';

import 'package:nubank_shorten_links/core/enums/key_strings.dart';
import 'package:nubank_shorten_links/core/storage/local_datasource_interface.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasourceImpl implements ILocalDatasource {
  final SharedPreferences prefs;

  LocalDatasourceImpl(this.prefs);

  @override
  Future<void> setStorage({
    required String key,
    required ShortUrlModel url,
  }) async {
    final currentData = await prefs.getString(key);

    List<dynamic> urlList = [];

    if (currentData != null) {
      urlList = jsonDecode(currentData);
    }

    urlList.add(url.toJson());

    await prefs.setString(key, jsonEncode(urlList));
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

  @override
  Future<void> clearStorage(String key) {
    return prefs.remove(key);
  }
}
