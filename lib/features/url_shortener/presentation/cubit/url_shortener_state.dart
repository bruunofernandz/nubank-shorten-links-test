import 'package:equatable/equatable.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';

abstract class UrlShortenerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UrlShortenerInitial extends UrlShortenerState {}

class UrlShortenerLoading extends UrlShortenerState {}

class UrlShortenerSuccess extends UrlShortenerState {
  final ShortUrlModel shortUrl;

  UrlShortenerSuccess({required this.shortUrl});

  @override
  List<Object?> get props => [shortUrl];
}

class UrlShortenerStoredUrlsLoaded extends UrlShortenerState {
  final List<ShortUrlModel> urls;

  UrlShortenerStoredUrlsLoaded({required this.urls});

  @override
  List<Object?> get props => [urls];
}

class UrlShortenerListLoading extends UrlShortenerState {}

class UrlShortenerFailure extends UrlShortenerState {
  final String errorMessage;

  UrlShortenerFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
