import 'package:pokemon_sleep_tools/all_in_one/helpers/helpers_binding.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories_binding.dart';
import 'package:pokemon_sleep_tools/persistent/persistent_binding.dart';

void setupDependencies() {
  setupHelpers();
  setupPersistentDependencies();
  setupRepositoriesDependencies();
}