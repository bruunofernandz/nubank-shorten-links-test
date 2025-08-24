import 'package:dart_either/dart_either.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

abstract class IUrlShortenerRepository {
  Future<Either<Failure, ShortUrlModel>> shortenUrl(String url);
}
