import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nubank_shorten_links/core/injection_container.dart';
import 'package:nubank_shorten_links/core/network/http_client_impl.dart';
import 'package:nubank_shorten_links/core/storage/local_datasource_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/datasources/remote/url_shortener_remote_datasource_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/datasources/remote/url_shortener_remote_datasource_interface.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/repositories/url_shortener_repository_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/domain/repositories/url_shortener_repository_interface.dart';
import 'package:nubank_shorten_links/features/url_shortener/domain/usecases/post_url_shortener_usecase.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/cubit/url_shortener_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/injection_container_test.mocks.dart';

class MockDio extends Mock implements Dio {}

class MockDioHttpClient extends Mock implements DioHttpClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
  });

  test('should register all dependencies in GetIt', () async {
    final mockPrefs = MockSharedPreferences();
    final mockDio = MockDio();

    if (sl.isRegistered<SharedPreferences>()) {
      sl.unregister<SharedPreferences>();
    }
    if (sl.isRegistered<Dio>()) {
      sl.unregister<Dio>();
    }

    if (sl.isRegistered<DioHttpClient>()) {
      sl.unregister<DioHttpClient>();
    }

    sl.registerLazySingleton<SharedPreferences>(() => mockPrefs);
    sl.registerLazySingleton<LocalDatasourceImpl>(
      () => LocalDatasourceImpl(mockPrefs),
    );
    sl.registerLazySingleton<Dio>(() => mockDio);
    sl.registerLazySingleton<DioHttpClient>(
      () => DioHttpClient(dio: sl<Dio>()),
    );
    sl.registerLazySingleton<IUrlShortenerRemoteDatasource>(
      () => UrlShortenerRemoteDatasourceImpl(httpClient: sl<DioHttpClient>()),
    );
    sl.registerLazySingleton<IUrlShortenerRepository>(
      () => UrlShortenerRepositoryImpl(remoteDatasource: sl()),
    );
    sl.registerLazySingleton<PostUrlShortenerUsecase>(
      () => PostUrlShortenerUsecase(repository: sl()),
    );
    sl.registerFactory<UrlShortenerCubit>(
      () => UrlShortenerCubit(
        postUrlShortenerUsecase: sl(),
        localDatasource: LocalDatasourceImpl(mockPrefs),
      ),
    );

    expect(sl<SharedPreferences>(), mockPrefs);
    expect(sl<Dio>(), mockDio);
    expect(
      sl<IUrlShortenerRemoteDatasource>(),
      isA<UrlShortenerRemoteDatasourceImpl>(),
    );
    expect(sl<LocalDatasourceImpl>(), isA<LocalDatasourceImpl>());
    expect(sl<IUrlShortenerRepository>(), isA<UrlShortenerRepositoryImpl>());
    expect(sl<PostUrlShortenerUsecase>(), isA<PostUrlShortenerUsecase>());

    final cubit1 = sl<UrlShortenerCubit>();
    final cubit2 = sl<UrlShortenerCubit>();
    expect(cubit1, isA<UrlShortenerCubit>());
    expect(cubit1, isNot(same(cubit2)));
  });
}
