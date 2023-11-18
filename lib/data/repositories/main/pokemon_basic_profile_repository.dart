import 'package:collection/collection.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/data_sources/data_sources.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonBasicProfileRepository implements MyInjectable {

  Future<Map<int, double>> findAllIngredientRateOf() async {
    return DataSources.allIngredientRateOf;
  }

  PokemonBasicProfileRepository() {
    for (final entry in DataSources.allPokemonMapping.entries) {
      final pokemonId = entry.key;
      final basicProfile = entry.value;

      basicProfile.ingredientChain = DataSources.ingredientChainMap[basicProfile.ingredientChainId];
    }
  }

  Future<Map<int, PokemonBasicProfile>> findAllMapping() async {
    return DataSources.allPokemonMapping;
  }

  Future<Map<int, PokemonBasicProfile>> findByIdList(List<int> basicProfileIdList) async {
    final mapping = await findAllMapping();
    return basicProfileIdList
        .map((e) => mapping[e])
        .whereNotNull()
        .toList()
        .toMap((profile) => profile.id, (profile) => profile);
  }

  Future<List<PokemonBasicProfile>> findAll() async {
    final x = [...DataSources.allPokemonMapping.entries.map((e) => e.value)];
    x.sort((a, b) => a.boxNo - b.boxNo);
    return x;
  }

  Future<List<PokemonBasicProfile>> findInIdList({
    required List<int> idList,
  }) async {
    final tmp = await Future.wait(idList.map((e) => getBasicProfile(e)));
    final profiles = tmp.whereNotNull().toList();
    return profiles;
  }

  Future<PokemonBasicProfile?> getBasicProfile(int basicProfileId) async {
    return DataSources.allPokemonMapping[basicProfileId];
  }
}


