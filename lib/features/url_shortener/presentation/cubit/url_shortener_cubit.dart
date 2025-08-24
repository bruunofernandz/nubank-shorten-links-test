import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nubank_shorten_links/core/enums/key_strings.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';
import 'package:nubank_shorten_links/core/storage/local_datasource_impl.dart';
import 'package:nubank_shorten_links/core/storage/local_datasource_interface.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:nubank_shorten_links/features/url_shortener/domain/usecases/post_url_shortener_usecase.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/cubit/url_shortener_state.dart';

class UrlShortenerCubit extends Cubit<UrlShortenerState> {
  final PostUrlShortenerUsecase _postUrlShortenerUsecase;
  final ILocalDatasource _localDatasource;

  UrlShortenerCubit({
    required PostUrlShortenerUsecase postUrlShortenerUsecase,
    required LocalDatasourceImpl localDatasource,
  }) : _postUrlShortenerUsecase = postUrlShortenerUsecase,
       _localDatasource = localDatasource,
       super(UrlShortenerInitial());

  Future<void> shortenUrl(String originalUrl) async {
    if (originalUrl.isEmpty) return;

    emit(UrlShortenerLoading());
    final result = await _postUrlShortenerUsecase(originalUrl);

    result.fold(
      ifLeft: (failure) =>
          emit(UrlShortenerFailure(errorMessage: _mapErrorHandling(failure))),
      ifRight: (result) async {
        emit(UrlShortenerSuccess(shortUrl: result));

        final model = ShortUrlModel(
          originalUrl: originalUrl,
          shortUrl: result.shortUrl,
          alias: result.alias,
        );

        await _localDatasource.setStorage(
          key: KeyStrings.urlShortener.value,
          url: model,
        );

        loadStoredUrls();
      },
    );
  }

  Future<void> loadStoredUrls() async {
    emit(UrlShortenerListLoading());

    try {
      final storedUrls = await _localDatasource.getStorage();
      emit(UrlShortenerStoredUrlsLoaded(urls: storedUrls));
    } catch (e) {
      emit(UrlShortenerFailure(errorMessage: 'Failed to load stored URLs.'));
    }
  }

  String _mapErrorHandling(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error, please try again later.';
    }

    if (failure is NetworkFailure) {
      return 'No internet connection, please check your connection.';
    }

    return 'Unexpected Error occurred.';
  }

  void clearList() {
    _localDatasource.clearStorage(KeyStrings.urlShortener.value);

    loadStoredUrls();
  }
}
