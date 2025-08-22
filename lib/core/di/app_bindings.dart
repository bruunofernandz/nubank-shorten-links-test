import 'package:dio/dio.dart';
import 'package:nubank_shorten_links/core/di/di_impl.dart';
import 'package:nubank_shorten_links/core/di/di_interface.dart';

class AppInjector {
  static final DiInterface _injector = DiImpl();

  static void init() {
    // External
    _injector.registerLazy<Dio>(
      () => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ),
    );

    // Data sources

    // Repository

    // Cubit
  }

  static T get<T>() => _injector.get<T>();
}
