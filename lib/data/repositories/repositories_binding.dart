import 'package:pokemon_sleep_tools/all_in_one/utils/utils.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

void setupRepositoriesDependencies() {
  const bind = registerSingleton;

  bind<EvolutionRepository>(EvolutionRepository());
  bind<FieldRepository>(FieldRepository());
  bind<FoodRepository>(FoodRepository());
  bind<PokemonBasicProfileRepository>(PokemonBasicProfileRepository());
  bind<PokemonProfileRepository>(PokemonProfileRepository());
  bind<PokemonTeamRepository>(PokemonTeamRepository());
  bind<SleepFaceRepository>(SleepFaceRepository());

}