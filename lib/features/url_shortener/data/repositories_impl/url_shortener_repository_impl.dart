import 'package:dart_either/src/dart_either.dart';
import 'package:nubank_shorten_links/core/errors/error_handler.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/datasources/remote/url_shortener_remote_datasource_interface.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:nubank_shorten_links/features/url_shortener/domain/repositories/url_shortener_repository.dart';

class UrlShortenerRepositoryImpl implements IUrlShortenerRepository {
  final IUrlShortenerRemoteDatasource _remoteDatasource;

  UrlShortenerRepositoryImpl({
    required IUrlShortenerRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, ShortUrlModel>> shortenUrl(String url) async {
    try {
      final result = await _remoteDatasource.shortenUrl(url);

      return Right(result);
    } catch (error) {
      final failure = ErrorHandler.handle(error);

      return Left(failure);
    }
  }
}
