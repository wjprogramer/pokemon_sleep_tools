import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';

setupHelpers() {
  const bind = registerSingleton;

  bind<MyCacheManager>(MyCacheManager());
}