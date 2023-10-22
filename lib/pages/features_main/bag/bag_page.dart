import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

class BagPage extends StatefulWidget {
  const BagPage._();

  static const MyPageRoute route = ('/BagPage', _builder);
  static Widget _builder(dynamic args) {
    return const BagPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();
  EvolutionRepository get _evolutionRepo => getIt();
  MainViewModel get _mainViewModel => context.read<MainViewModel>();

  final _basicProfileIdToInstance = <int, PokemonBasicProfile>{};

  // UI
  late ThemeData _theme;

  // Data
  final _disposers = <MyDisposable>[];

  /// [PokemonBasicProfile.id] to [PokemonProfile]
  final _profileOf = <int, PokemonProfile>{};

  var _evolutionChains = <TempUiEvolutionChain>[];
  final _gameItemToEvolutionChains = <GameItem, List<TempUiEvolutionChain>>{};
  final _resultBetweenEvolutions = <GameItem, List<_BetweenEvolution>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      await _oldInit();
      await _prepareEvolutions();

      if (mounted) {
        setState(() { });
      }
    });
  }

  Future<void> _oldInit() async {
    for (final evolutionItem in EvolutionGameItem.values) {
      for (final basicProfileId in evolutionItem.basicProfileIds) {
        if (_basicProfileIdToInstance[basicProfileId] != null) {
          continue;
        }

        final basicProfile = await _basicProfileRepo.getBasicProfile(basicProfileId);
        if (basicProfile == null) {
          continue;
        }
        _basicProfileIdToInstance[basicProfile.id] = basicProfile;
      }
    }
  }

  Future<void> _prepareEvolutions() async {
    _evolutionChains = [];

    final evolutionMapping = await _evolutionRepo.findAllMapping();
    final evolutionTempList = evolutionMapping.entries.map((e) => e.value).toList()..sort((a, b) => a.stage - b.stage);
    final evolutionsWithBasicProfileId = <List<List<int>>>[];
    final basicProfileOf = await _basicProfileRepo.findAllMapping();
    final basicProfileIdToEvolution = <int, Evolution>{};

    for (final evolution in evolutionTempList) {
      basicProfileIdToEvolution[evolution.basicProfileId] = evolution;

      if (evolution.stage == 1) {
        evolutionsWithBasicProfileId.add([
          ...List.generate(
              MAX_POKEMON_EVOLUTION_STAGE,
                  (index) => index == 0 ? [ evolution.basicProfileId ] : []
          )
        ]);
      } else {
        final previousBasicProfileId = evolution.previousBasicProfileId;
        if (previousBasicProfileId == null) {
          continue;
        }
        for (var resultIndex = 0; resultIndex < evolutionsWithBasicProfileId.length; resultIndex++) {
          if (evolutionsWithBasicProfileId[resultIndex][evolution.stage - 2].contains(previousBasicProfileId)) {
            evolutionsWithBasicProfileId[resultIndex][evolution.stage - 1].add(evolution.basicProfileId);
            break;
          }
        }
      }
    }

    evolutionsWithBasicProfileId.sort((a, b) => a[0][0] - b[0][0]);

    for (final stagesWithIds in evolutionsWithBasicProfileId) {
      final data = TempUiEvolutionChain();

      for (var stageIndex = 0; stageIndex < stagesWithIds.length; stageIndex++) {
        final basicIdsOfStage = stagesWithIds[stageIndex];
        for (final basicProfileId in basicIdsOfStage) {
          data.basicProfilesOfStages[stageIndex].add(TempUiEvolution(
            basicProfileOf[basicProfileId]!,
            basicProfileIdToEvolution[basicProfileId]!,
          ));
        }
      }

      _evolutionChains.add(data);
    }

    _evolutionChains.sort((a, b) {
      return a.basicProfilesOfStages[0][0].basicProfile.boxNo - b.basicProfilesOfStages[0][0].basicProfile.boxNo;
    });

    _evolutionChains = _evolutionChains.where((evolutionChain) {
      return _convertToConditions(evolutionChain)
          .any((e) => e.values['type'] == 'item');
    }).toList();

    for (final evolutionChain in _evolutionChains) {
      // 最後一個階段不會升級了
      for (var stageIndex = 0; stageIndex < MAX_POKEMON_EVOLUTION_STAGE - 1; stageIndex++) {
        final uiEvolutions = evolutionChain.basicProfilesOfStages[stageIndex];

        for (var evolutionIndex = 0; evolutionIndex < uiEvolutions.length; evolutionIndex++) {
          final currEvolution = uiEvolutions[evolutionIndex];

          for (final nextStage in currEvolution.evolution.nextStages) {
            // 有寶可夢可以用兩種道具進化成同一種：呆呆獸可以用王者之證或連繫繩進化
            final gameItems = nextStage.conditions
                .whereType<EvolutionConditionRaw>()
                .where((e) => e.values['type'] == 'item')
                .map((e) => GameItem.getById(e.values['item']))
                .whereNotNull();
            if (gameItems.isEmpty) {
              continue;
            }


            if (currEvolution.basicProfile.boxNo >= 74 &&
                currEvolution.basicProfile.boxNo <= 77) {
              print(1);
            }

            for (final gameItem in gameItems) {
              _resultBetweenEvolutions[gameItem] = _resultBetweenEvolutions[gameItem] ?? [];
              final newConditions = nextStage.conditions
                  .whereType<EvolutionConditionRaw>()
                  .toList();
              newConditions.sortByCompare((e) => e.values, (a, b) {
                if (a['type'] == 'item') {
                  return -1;
                }
                return 0;
              });
              final betweenEvolution = _BetweenEvolution(
                currBasicProfile: currEvolution.basicProfile,
                nextBasicProfile: basicProfileOf[nextStage.basicProfileId]!,
                basicProfileWithSmallestBoxNo: evolutionChain.getCandyBasicProfile(),
                conditions: newConditions,
              );

              _resultBetweenEvolutions[gameItem]?.add(betweenEvolution);
            }
          }
        }
      }

      final conditions = _convertToConditions(evolutionChain).toList();

      for (var i = 0; i < conditions.length; i++) {
        final condition = conditions[i];

        if (condition.values['type'] == 'item') {
          final gameItem = GameItem.getById(condition.values['item']);
          if (gameItem == null) {
            continue;
          }
          _gameItemToEvolutionChains[gameItem] = _gameItemToEvolutionChains[gameItem] ?? [];
          _gameItemToEvolutionChains[gameItem]?.add(evolutionChain);
        }
      }
    }

  }

  Iterable<EvolutionConditionRaw> _convertToConditions(TempUiEvolutionChain evolutionChain) {
    return evolutionChain.basicProfilesOfStages
        .sublist(0, MAX_POKEMON_EVOLUTION_STAGE - 1) // 最後一個階段不會升級了
        .expand((e) => e)
        .map((e) => e.evolution)
        .map((e) => e.nextStages)
        .expand((e) => e)
        .map((e) => e.conditions)
        .expand((e) => e)
        .whereType<EvolutionConditionRaw>();
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_bag'.xTr,
      ),
      body: ListView(
        children: [
          Gap.xl,
          // 薰香
          // 進化道具
          Hp(
            child: MySubHeader(
              titleText: 't_evolution_items'.xTr,
            ),
          ),
          if (MyEnv.USE_DEBUG_IMAGE) ...[
            ..._resultBetweenEvolutions.entries.map((e) {
              final gameItem = e.key;
              final evolutions = e.value;

              return <Widget>[
                Hp(
                  child: MySubHeader2(
                    title: Row(
                      children: [
                        GameItemImage(
                          gameItem: gameItem,
                          width: 20,
                          disableTooltip: true,
                        ),
                        Gap.sm,
                        Expanded(
                          child: Text(
                            gameItem.nameI18nKey.xTr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...evolutions.map((e) => _buildBetweenEvolution(e)),
              ];
            }).expand((e) => e),
          ] else ...Hp.list(
            children: [
              ...EvolutionGameItem.values.map((evolutionItem) => <Widget>[
                Gap.lg,
                Text('# ${evolutionItem.nameI18nKey.xTr}'),
                Gap.xs,
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _buildBasicProfiles(evolutionItem),
                ),
              ]).expand((e) => e),
            ],
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  List<Widget> _buildBasicProfiles(EvolutionGameItem evolutionItem) {
    return evolutionItem.basicProfileIds
        .map((basicProfileId) => _basicProfileIdToInstance[basicProfileId])
        .whereNotNull()
        .map(_buildBasicProfileForEvolution)
        .toList();
  }

  Widget _buildBasicProfileForEvolution(PokemonBasicProfile basicProfile) {
    return InkWell(
      onTap: () {
        PokemonBasicProfilePage.go(context, basicProfile);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(basicProfile.nameI18nKey.xTr),
      ),
    );
  }

  Widget _buildBetweenEvolution(_BetweenEvolution betweenEvolution) {
    // '${e.currBasicProfile.nameI18nKey} ${e.nextBasicProfile.nameI18nKey}'
    return MyListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (MyEnv.USE_DEBUG_IMAGE) ...[
            _buildPokemonIconImage(
              betweenEvolution.currBasicProfile,
            ),
            Gap.sm,
            _buildPokemonIconImage(
              betweenEvolution.nextBasicProfile,
            ),
            Gap.md,
          ],
        ],
      ),
      title: Text.rich(
        TextSpan(
          text: betweenEvolution.currBasicProfile.nameI18nKey.xTr,
          children: [
            const TextSpan(
              text: '  ▶  ',
              style: TextStyle(
                fontSize: 12,
              )
            ),
            TextSpan(
              text: betweenEvolution.nextBasicProfile.nameI18nKey.xTr,
            ),
          ],
        ),
      ),
      subtitle: Wrap(
        spacing: 12,
        children: betweenEvolution.conditions.xMapIndexed((i, e, conditions) => <Widget>[
          buildEvolutionCondition(
            e, betweenEvolution.basicProfileWithSmallestBoxNo,
            mainAxisSize: MainAxisSize.min,
          ),
        ]).expand((e) => e).toList(),
      ),
    );
  }

  Widget _buildPokemonIconImage(PokemonBasicProfile basicProfile) {
    return InkWell(
      onTap: () {
        PokemonBasicProfilePage.go(context, basicProfile);
      },
      child: PokemonIconBorderedImage(
        basicProfile: basicProfile,
        width: 48,
        disableTooltip: true,
      ),
    );
  }

}

class _BetweenEvolution {
  _BetweenEvolution({
    required this.currBasicProfile,
    required this.nextBasicProfile,
    required this.basicProfileWithSmallestBoxNo,
    required this.conditions,
  });

  final PokemonBasicProfile currBasicProfile;
  final PokemonBasicProfile nextBasicProfile;
  final PokemonBasicProfile basicProfileWithSmallestBoxNo;
  final List<EvolutionConditionRaw> conditions;
}
