import 'package:pokemon_sleep_tools/data/repositories/repositories_binding.dart';
import 'package:pokemon_sleep_tools/persistent/persistent_binding.dart';

void setupDependencies() {
  setupPersistentDependencies();
  setupRepositoriesDependencies();
}