import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';

class DevPokemonEvolutionsPage extends StatefulWidget {
  const DevPokemonEvolutionsPage._();

  static const MyPageRoute route = ('/DevPokemonEvolutionsPage', _builder);
  static Widget _builder(dynamic args) {
    return const DevPokemonEvolutionsPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DevPokemonEvolutionsPage> createState() => _DevPokemonEvolutionsPageState();
}

class _DevPokemonEvolutionsPageState extends State<DevPokemonEvolutionsPage> {
  EvolutionRepository get _evolutionRepository => getIt();
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  var _data = <_TempEvolutionChain>[];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      final basicData = await _evolutionRepository.findAllMapping();
      final evolutionList = basicData.entries.map((e) => e.value).toList()..sort((a, b) => a.stage - b.stage);
      final results = <List<List<int>>>[];
      final basicProfileOf = await _basicProfileRepo.findAllMapping();

      for (final evolution in evolutionList) {
        if (evolution.stage == 1) {
          results.add([
            ...List.generate(
                MAX_POKEMON_EVOLUTION_STAGE,
                    (index) => index == 0 ? [ evolution.basicProfileId ] : []
            )
          ]);
        } else {
          final previousBasicProfileId = evolution.previousBasicProfileId;
          if (previousBasicProfileId == null) {
            throw Exception('basicProfileId: $previousBasicProfileId');
          }
          for (var resultIndex = 0; resultIndex < results.length; resultIndex++) {
            if (results[resultIndex][evolution.stage - 2].contains(previousBasicProfileId)) {
              results[resultIndex][evolution.stage - 1].add(evolution.basicProfileId);
              break;
            }
          }
        }
      }

      results.sort((a, b) => a[0][0] - b[0][0]);

      for (final stagesWithIds in results) {
        final data = _TempEvolutionChain();

        for (var stageIndex = 0; stageIndex < stagesWithIds.length; stageIndex++) {
          final basicIdsOfStage = stagesWithIds[stageIndex];
          for (final basicProfileId in basicIdsOfStage) {
            data.basicProfilesOfStages[stageIndex].add(basicProfileOf[basicProfileId]!);
          }
        }

        _data.add(data);
      }

      _data.sort((a, b) {
        return a.basicProfilesOfStages[0][0].boxNo - b.basicProfilesOfStages[0][0].boxNo;
      });

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          // Text('開發用'),
          // Row(
          //   children: [
          //     Wrap(
          //       children: [
          //         MyElevatedButton(
          //           onPressed: () async {
          //
          //           },
          //           child: Text('取得所有糖果資訊'),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          Divider(),
          ..._data.map((devEvolutionItem) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              children: [
                CandyOfPokemonIcon(
                  boxNo: devEvolutionItem.getCandyBoxNo(),
                  size: 24,
                ),
                ...devEvolutionItem.basicProfilesOfStages.where((stage) => stage.isNotEmpty).xMapIndexed((stageIndex, basicProfiles, stages) {
                  return <Widget>[
                    ...basicProfiles.map((basicProfile) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        '${basicProfile.nameI18nKey.xTr} (#${basicProfile.boxNo})',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )),
                    if (stageIndex < stages.length - 1)
                      const Icon(Icons.arrow_forward_ios),
                  ];
                }).expand((e) => e),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TempEvolutionChain {
  _TempEvolutionChain();

  final List<List<PokemonBasicProfile>> basicProfilesOfStages = List
      .generate(3, (index) => []);

  int getCandyBoxNo() {
    return basicProfilesOfStages
        .map((e) => e.map((x) => x.boxNo))
        .expand((element) => element)
        .min;
  }
}


