import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 此頁面不做篩選功能
class PokemonEvolutionIllustratedBookPage extends StatefulWidget {
  const PokemonEvolutionIllustratedBookPage._();

  static const MyPageRoute route = ('/PokemonEvolutionIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const PokemonEvolutionIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PokemonEvolutionIllustratedBookPage> createState() => _PokemonEvolutionIllustratedBookPageState();
}

class _PokemonEvolutionIllustratedBookPageState extends State<PokemonEvolutionIllustratedBookPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();
  EvolutionRepository get _evolutionRepo => getIt();
  MainViewModel get _mainViewModel => context.read<MainViewModel>();

  // Data
  var _data = <_TempEvolutionChain>[];
  final _disposers = <MyDisposable>[];

  /// [PokemonBasicProfile.id] to [PokemonProfile]
  final _profileOf = <int, PokemonProfile>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      await _prepareEvolutions();
      await _updateBoxProfiles();

      if (mounted) {
        setState(() { });
      }

      _disposers.addAll([
        _mainViewModel.xAddListener(_listenMainViewModel),
      ]);
    });
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    super.dispose();
  }

  /// FIXME: 會造成死當
  /// 時機：從此頁面到 BasicProfilePage，因同時有兩個 MainViewModel 在讀取（包含此頁面的 ViewModel）
  Future<void> _listenMainViewModel() async {
    // await _updateBoxProfiles();
    // if (mounted) {
    //   setState(() { });
    // }
  }

  Future<void> _updateBoxProfiles() async {
    final mainViewModel = _mainViewModel;

    final profiles = await mainViewModel.loadProfiles();
    for (final profile in profiles) {
      _profileOf[profile.basicProfileId] = profile;
    }
  }

  Future<void> _prepareEvolutions() async {
    _data = [];

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
          throw Exception('basicProfileId: $previousBasicProfileId');
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
      final data = _TempEvolutionChain();

      for (var stageIndex = 0; stageIndex < stagesWithIds.length; stageIndex++) {
        final basicIdsOfStage = stagesWithIds[stageIndex];
        for (final basicProfileId in basicIdsOfStage) {
          data.basicProfilesOfStages[stageIndex].add(_TempEvolution(
            basicProfileOf[basicProfileId]!,
            basicProfileIdToEvolution[basicProfileId]!,
          ));
        }
      }

      _data.add(data);
    }

    _data.sort((a, b) {
      return a.basicProfilesOfStages[0][0].basicProfile.boxNo - b.basicProfilesOfStages[0][0].basicProfile.boxNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_pokemon_illustrated_book'.xTr,
      ),
      body: buildListView(
        children: [
          ..._data.map((e) {
            final (mapping, basicProfileWithSmallestBoxNo) = e.getBasicProfileMappingAndSmallestBoxNo();

            return EvolutionsView(
              e.convertToEvolutions(),
              basicProfilesInEvolutionChain: mapping,
              basicProfile: null,
              basicProfileWithSmallestBoxNoInChain: basicProfileWithSmallestBoxNo,
            );
          }),
          Gap.trailing,
        ],
      ),
    );
  }

}

class _TempEvolutionChain {
  _TempEvolutionChain();

  final List<List<_TempEvolution>> basicProfilesOfStages = List
      .generate(MAX_POKEMON_EVOLUTION_STAGE, (index) => []);

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

class _TempEvolution {
  _TempEvolution(this.basicProfile, this.evolution);

  final PokemonBasicProfile basicProfile;
  final Evolution evolution;
}
