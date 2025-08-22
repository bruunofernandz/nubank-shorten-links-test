import 'package:get/get.dart';
import 'package:nubank_shorten_links/core/di/di_interface.dart';

/// Implementação do IInjector usando GetX como backend
class DiImpl implements DiInterface {
  @override
  void registerLazy<T>(T Function() builder) {
    Get.lazyPut<T>(builder);
  }

  @override
  void registerSingleton<T>(T instance) {
    Get.put<T>(instance, permanent: true);
  }

  @override
  T get<T>() {
    return Get.find<T>();
  }

  @override
  void registerFactory<T>(T Function() builder) {}
}
