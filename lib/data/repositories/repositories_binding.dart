import 'package:pokemon_sleep_tools/all_in_one/utils/utils.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

void setupRepositoriesDependencies() {
  const bind = registerSingleton;

  bind<PokemonProfileRepository>(PokemonProfileRepository());
  bind<PokemonBasicProfileRepository>(PokemonBasicProfileRepository());
  bind<PokemonTeamRepository>(PokemonTeamRepository());
  bind<SleepFaceRepository>(SleepFaceRepository());

}