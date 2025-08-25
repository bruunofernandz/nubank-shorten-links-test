import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/repositories/url_shortener_repository_impl.dart';
import 'package:nubank_shorten_links/features/url_shortener/domain/repositories/url_shortener_repository_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/url_shortener/data/datasources/remote/url_shortener_remote_datasource_impl.dart';
import '../features/url_shortener/data/datasources/remote/url_shortener_remote_datasource_interface.dart';
import '../features/url_shortener/domain/usecases/post_url_shortener_usecase.dart';
import '../features/url_shortener/presentation/cubit/url_shortener_cubit.dart';
import 'network/http_client_impl.dart';
import 'storage/local_datasource_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    ),
  );

  // Others
  sl.registerLazySingleton<DioHttpClient>(() => DioHttpClient(dio: sl()));

  // Datasources
  sl.registerLazySingleton<IUrlShortenerRemoteDatasource>(
    () => UrlShortenerRemoteDatasourceImpl(httpClient: sl()),
  );
  sl.registerLazySingleton<LocalDatasourceImpl>(
    () => LocalDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<IUrlShortenerRepository>(
    () => UrlShortenerRepositoryImpl(remoteDatasource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => PostUrlShortenerUsecase(repository: sl()));

  // Cubit
  sl.registerFactory(
    () =>
        UrlShortenerCubit(postUrlShortenerUsecase: sl(), localDatasource: sl()),
  );
}
