import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class PokemonTeamRepository implements MyInjectable {
  MyLocalStorage get _localStorage => getIt();

  Future<List<PokemonTeam?>> findAll() async {
    final stored = await _localStorage.readPokemonTeams();
    return stored.teams;
  }

  Future<PokemonTeam> create(int index, PokemonTeam team) async {
    PokemonTeam? newTeam;

    await _localStorage.readWrite<StoredPokemonTeams>(StoredPokemonTeams, (stored) async {
      newTeam = await stored.insert(index, team);
      return stored;
    });

    return newTeam!;
  }

  Future<void> update(int index, PokemonTeam team) async {
    await _localStorage.readWrite<StoredPokemonTeams>(StoredPokemonTeams, (stored) async {
      await stored.replace(index, team);
      return stored;
    });
  }

}