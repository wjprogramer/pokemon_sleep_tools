import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

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

  var _text = '';

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

      String getNames(List<int> basicProfileIds) {
        return basicProfileIds.map((e) => basicProfileOf[e]?.nameI18nKey.xTr ?? 'none(id:$e)').join(',');
      }

      _text = '';
      for (final result in results) {
        _text += result
            .where((element) => element.isNotEmpty)
            .map((e) => getNames(e)).join('->');
        _text += '\n\n';
      }

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
          Text(_text),
        ],
      ),
    );
  }
}


