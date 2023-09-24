import 'package:pokemon_sleep_tools/all_in_one/utils/utils.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

void setupPersistentDependencies() {
  const bind = registerSingleton;

  bind<MyLocalStorage>(MyLocalStorage());
  bind<MySharedPreferences>(MySharedPreferences());
}