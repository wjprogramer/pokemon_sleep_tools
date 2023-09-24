import 'package:get_it/get_it.dart';

T getIt<T extends Object>({
  dynamic param1,
  dynamic param2,
  String? instanceName,
  Type? type,
}) {
  return GetIt.I.get<T>();
}

T registerSingleton<T extends Object>(
  T instance, {
  String? instanceName,
  bool? signalsReady,
  DisposingFunc<T>? dispose,
}) {
  return GetIt.I.registerSingleton(
    instance,
    instanceName: instanceName,
    signalsReady: signalsReady,
    dispose: dispose,
  );
}

void registerLazySingleton<T extends Object>(
  FactoryFunc<T> factoryFunc, {
  String? instanceName,
  DisposingFunc<T>? dispose,
}) {
  return GetIt.I.registerLazySingleton(
    factoryFunc,
    instanceName: instanceName,
    dispose: dispose,
  );
}




