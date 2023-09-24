import 'package:pokemon_sleep_tools/all_in_one/utils/utils.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

void setupRepositoriesDependencies() {
  const lazy = registerLazySingleton;

  lazy<PokemonProfileRepository>(() => PokemonProfileRepository());
  lazy<PokemonBasicProfileRepository>(() => PokemonBasicProfileRepository());
}