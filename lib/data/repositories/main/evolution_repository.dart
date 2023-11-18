import 'package:flutter/foundation.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/data_sources/data_sources.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class EvolutionRepository implements MyInjectable {
  /// [PokemonBasicProfile.id] to [Evolution]
  Future<Map<int, Evolution>> findAllMapping() async {
    return DataSources.evolutionMapping;
  }

  Future<List<List<Evolution>>> findByBasicProfileId(int basicProfileId) async {
    final mapping = await findAllMapping();
    final res = List.generate(MAX_POKEMON_EVOLUTION_STAGE, (index) => <Evolution>[]);

    final baseEvolution = mapping[basicProfileId]!;

    tourPrevious(Evolution evolution) {
      if (baseEvolution.basicProfileId != evolution.basicProfileId) {
        res[evolution.stage - 1].add(evolution);
      }
      final previousBasicProfileId = evolution.previousBasicProfileId;
      if (previousBasicProfileId == null || evolution.stage == 1) {
        return;
      }
      tourPrevious(mapping[previousBasicProfileId]!);
    }

    tourNext(Evolution evolution) {
      res[evolution.stage - 1].add(evolution);
      for (var nextStage in evolution.nextStages) {
        final nextEvolution = mapping[nextStage.basicProfileId];
        if (nextEvolution == null) {
          debugPrint('nextEvolution is null: ${nextStage.basicProfileId}');
          continue;
        }
        tourNext(nextEvolution);
      }
    }
    tourNext(baseEvolution);
    tourPrevious(baseEvolution);

    return res;
  }

}