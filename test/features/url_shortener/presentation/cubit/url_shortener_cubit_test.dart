import 'package:bloc_test/bloc_test.dart';
import 'package:dart_either/dart_either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nubank_shorten_links/core/enums/key_strings.dart';
import 'package:nubank_shorten_links/core/errors/failure.dart';
import 'package:nubank_shorten_links/core/storage/local_datasource_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:nubank_shorten_links/features/url_shortener/domain/usecases/post_url_shortener_usecase.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/cubit/url_shortener_cubit.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/cubit/url_shortener_state.dart';

class MockPostUrlShortenerUsecase extends Mock
    implements PostUrlShortenerUsecase {}

class MockLocalDatasource extends Mock implements LocalDatasourceImpl {}

class ShortUrlModelFake extends Fake implements ShortUrlModel {}

void main() {
  late UrlShortenerCubit cubit;
  late MockPostUrlShortenerUsecase mockUsecase;
  late MockLocalDatasource mockLocalDatasource;

  setUp(() {
    mockUsecase = MockPostUrlShortenerUsecase();
    mockLocalDatasource = MockLocalDatasource();
    cubit = UrlShortenerCubit(
      postUrlShortenerUsecase: mockUsecase,
      localDatasource: mockLocalDatasource,
    );
  });

  setUpAll(() {
    registerFallbackValue(ShortUrlModelFake());
  });

  group('shortenUrl cubit tests', () {
    const tOriginalUrl = 'https://example.com';
    const tShortUrl = 'https://short.ly/abc123';
    const tAlias = 'abc123';
    final tShortUrlModel = ShortUrlModel(
      originalUrl: tOriginalUrl,
      shortUrl: tShortUrl,
      alias: tAlias,
    );

    test('should have initial state as UrlShortenerInitial', () {
      // Arrange & Act & Assert
      expect(cubit.state, UrlShortenerInitial());
    });

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'should emit nothing when originalUrl is empty',
      build: () => cubit,
      act: (cubit) => cubit.shortenUrl(''),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockUsecase(any()));
      },
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'should emit [Loading, Failure] when usecase returns ServerFailure',
      build: () {
        when(
          () => mockUsecase(any()),
        ).thenAnswer((_) async => Left(ServerFailure('Server error')));
        return cubit;
      },
      act: (cubit) => cubit.shortenUrl(tOriginalUrl),
      expect: () => [
        UrlShortenerLoading(),
        UrlShortenerFailure(
          errorMessage: 'Server error, please try again later.',
        ),
      ],
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'should emit [Loading, Failure] when usecase returns NetworkFailure',
      build: () {
        when(() => mockUsecase(any())).thenAnswer(
          (_) async => Left(NetworkFailure('No internet connection')),
        );
        return cubit;
      },
      act: (cubit) => cubit.shortenUrl(tOriginalUrl),
      expect: () => [
        UrlShortenerLoading(),
        UrlShortenerFailure(
          errorMessage: 'No internet connection, please check your connection.',
        ),
      ],
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'should emit [Loading, Success, ListLoading, StoredUrlsLoaded] on successful shorten',
      build: () {
        when(
          () => mockUsecase(any()),
        ).thenAnswer((_) async => Right(tShortUrlModel));
        when(
          () => mockLocalDatasource.setStorage(
            key: any(named: 'key'),
            url: any(named: 'url'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockLocalDatasource.getStorage(),
        ).thenAnswer((_) async => [tShortUrlModel]);
        return cubit;
      },
      act: (cubit) => cubit.shortenUrl(tOriginalUrl),
      expect: () => [
        UrlShortenerLoading(),
        UrlShortenerSuccess(shortUrl: tShortUrlModel),
        UrlShortenerListLoading(),
        UrlShortenerStoredUrlsLoaded(urls: [tShortUrlModel]),
      ],
      verify: (_) {
        verify(() => mockUsecase(tOriginalUrl)).called(1);
        verify(
          () => mockLocalDatasource.setStorage(
            key: KeyStrings.urlShortener.value,
            url: any(named: 'url'),
          ),
        ).called(1);
        verify(() => mockLocalDatasource.getStorage()).called(1);
      },
    );
  });

  group('loadStoredUrls', () {
    final tStoredUrls = [
      ShortUrlModel(
        originalUrl: 'https://a.com',
        shortUrl: 'https://short.ly/a',
        alias: 'a',
      ),
      ShortUrlModel(
        originalUrl: 'https://b.com',
        shortUrl: 'https://short.ly/b',
        alias: 'b',
      ),
    ];

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'should emit [ListLoading, StoredUrlsLoaded] when getStorage succeeds',
      build: () {
        when(
          () => mockLocalDatasource.getStorage(),
        ).thenAnswer((_) async => tStoredUrls);
        return cubit;
      },
      act: (cubit) => cubit.loadStoredUrls(),
      expect: () => [
        UrlShortenerListLoading(),
        UrlShortenerStoredUrlsLoaded(urls: tStoredUrls),
      ],
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'should emit [ListLoading, Failure] when getStorage throws',
      build: () {
        when(
          () => mockLocalDatasource.getStorage(),
        ).thenThrow(Exception('error'));
        return cubit;
      },
      act: (cubit) => cubit.loadStoredUrls(),
      expect: () => [
        UrlShortenerListLoading(),
        UrlShortenerFailure(errorMessage: 'Failed to load stored URLs.'),
      ],
    );
  });

  group('clearList', () {
    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'should call clearStorage and emit [ListLoading, StoredUrlsLoaded]',
      build: () {
        when(
          () => mockLocalDatasource.clearStorage(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockLocalDatasource.getStorage(),
        ).thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.clearList(),
      expect: () => [
        UrlShortenerListLoading(),
        UrlShortenerStoredUrlsLoaded(urls: []),
      ],
      verify: (_) {
        verify(
          () => mockLocalDatasource.clearStorage(KeyStrings.urlShortener.value),
        ).called(1);
        verify(() => mockLocalDatasource.getStorage()).called(1);
      },
    );
  });
}
