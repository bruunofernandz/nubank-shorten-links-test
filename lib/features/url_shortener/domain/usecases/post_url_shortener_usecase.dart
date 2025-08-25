import 'package:dart_either/src/dart_either.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:nubank_shorten_links/features/url_shortener/domain/repositories/url_shortener_repository_interface.dart';

class PostUrlShortenerUsecase {
  final IUrlShortenerRepository _repository;

  PostUrlShortenerUsecase({required IUrlShortenerRepository repository})
    : _repository = repository;

  Future<Either<Failure, ShortUrlModel>> call(String url) {
    return _repository.shortenUrl(url);
  }
}
