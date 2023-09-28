import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

class DevPokemonBoxPage extends StatefulWidget {
  const DevPokemonBoxPage({super.key});

  static MyPageRoute<void> route = ('/DevPokemonBoxPage', (_) => const DevPokemonBoxPage());

  @override
  State<DevPokemonBoxPage> createState() => _DevPokemonBoxPageState();
}

class _DevPokemonBoxPageState extends State<DevPokemonBoxPage> {
  PokemonProfileRepository get _pokemonProfileRepo => getIt();

  var _pokemonList = <PokemonProfile>[];
  final _statisticsOf = <int, String>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _pokemonList = await _pokemonProfileRepo.getDemoProfiles();
      for (var pokemon in _pokemonList) {
        final statistics = PokemonProfileStatistics.from(pokemon);
        statistics.init();
        _statisticsOf[pokemon.id] = '統計\n'
            '幫忙均能/次: ${statistics.helpPerAvgEnergy.toStringAsFixed(2)}\n'
            '樹果能量: ${statistics.fruitEnergy}\n'
            '食材1能量: ${statistics.ingredientEnergy1}\n'
            '食材2能量: ${statistics.ingredientEnergy2}\n'
            '食材3能量: ${statistics.ingredientEnergy3}\n'
            '食材均能: ${statistics.ingredientEnergyAvg}\n'
            '幫手獎勵: ${statistics.helperBonus}\n'
            '幫忙速度S: ${statistics.totalHelpSpeedS}\n'
            '幫忙速度M: ${statistics.totalHelpSpeedM}\n'
            '食材機率: ${statistics}\n'
            '技能等級: ${statistics}\n'
            '主技能速度參數: ${statistics}\n'
            '持有上限溢出數: ${statistics}\n'
            '-----------------\n'
            '';
      }

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildListView(
        children: [
          Gap.xl,
          ..._pokemonList.map((pokemon) {
            final character = pokemon.character.name;
            final subSkills = pokemon.subSkills.mapIndexed((i, e) => 'Lv. ${SubSkill.levelList[i]}: ${e.nameI18nKey}').join('\n');
            final ingredients = <(Ingredient, int)>[
              (pokemon.ingredient1, pokemon.ingredientCount1),
              (pokemon.ingredient2, pokemon.ingredientCount2),
              (pokemon.ingredient3, pokemon.ingredientCount3),
            ].mapIndexed((index, ingredient) => '${index + 1}. ${ingredient.$1.nameI18nKey} x${ingredient.$2}').join('\n');
            final statistics = _statisticsOf[pokemon.id]!;

            return ListTile(
              title: Text(pokemon.basicProfile.nameI18nKey),
              subtitle: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                        '$character\n'
                            '-----------------\n'
                            '$subSkills\n'
                            '-----------------\n'
                            '食材: \n'
                            '$ingredients\n'
                    ),
                  ),
                  Expanded(
                    child: Text(statistics),
                  ),
                ],
              ),
            );
          }),
          Gap.trailing,
        ],
      ),
    );
  }
}
