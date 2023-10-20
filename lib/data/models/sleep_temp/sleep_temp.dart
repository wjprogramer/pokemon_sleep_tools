import 'package:collection/collection.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/common/evolution.dart';
import 'package:pokemon_sleep_tools/data/models/common/pokemon_basic_profile.dart';

class TempUiEvolutionChain {
  TempUiEvolutionChain();

  final List<List<TempUiEvolution>> basicProfilesOfStages = List
      .generate(MAX_POKEMON_EVOLUTION_STAGE, (index) => []);

  int getCandyBoxNo() {
    return basicProfilesOfStages
        .map((e) => e.map((x) => x.basicProfile.boxNo))
        .expand((element) => element)
        .min;
  }

  PokemonBasicProfile getCandyBasicProfile() {
    final res = basicProfilesOfStages
        .map((e) => e.map((x) => x.basicProfile))
        .expand((element) => element)
        .firstWhereByCompare((a, b) => a.boxNo < b.boxNo);
    return res;
  }

  List<List<Evolution>> convertToEvolutions() {
    return basicProfilesOfStages
        .map((e) => e.map((e) => e.evolution).toList())
        .toList();
  }

  (Map<int, PokemonBasicProfile>, PokemonBasicProfile) getBasicProfileMappingAndSmallestBoxNo() {
    final result = <int, PokemonBasicProfile>{};
    PokemonBasicProfile? basicProfileWithSmallestBoxNoInChain;

    for (final stage in basicProfilesOfStages) {
      for (final evolution in stage) {
        result[evolution.basicProfile.id] = evolution.basicProfile;
        if (basicProfileWithSmallestBoxNoInChain == null || basicProfileWithSmallestBoxNoInChain.boxNo > evolution.basicProfile.boxNo) {
          basicProfileWithSmallestBoxNoInChain = evolution.basicProfile;
        }
      }
    }
    return (result, basicProfileWithSmallestBoxNoInChain!);
  }
}

class TempUiEvolution {
  TempUiEvolution(this.basicProfile, this.evolution);

  final PokemonBasicProfile basicProfile;
  final Evolution evolution;
}
