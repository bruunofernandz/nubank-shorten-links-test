abstract class DiInterface {
  void registerLazy<T>(T Function() builder);

  void registerFactory<T>(T Function() builder);

  void registerSingleton<T>(T instance);

  T get<T>();
}
