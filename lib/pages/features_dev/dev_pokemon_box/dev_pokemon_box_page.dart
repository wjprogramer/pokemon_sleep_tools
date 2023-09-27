import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/main/list_view.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

class DevPokemonBoxPage extends StatefulWidget {
  const DevPokemonBoxPage({super.key});

  static MyPageRoute<void> route = ('/DevPokemonBoxPage', (_) => const DevPokemonBoxPage());

  @override
  State<DevPokemonBoxPage> createState() => _DevPokemonBoxPageState();
}

class _DevPokemonBoxPageState extends State<DevPokemonBoxPage> {
  PokemonProfileRepository get _pokemonProfileRepo => getIt();

  var _pokemons = <PokemonProfile>[];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _pokemons = _pokemonProfileRepo.getDemoProfiles();

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
          ..._pokemons.map((pokemon) {
            final character = pokemon.character.name;
            final subSkills = pokemon.subSkills.mapIndexed((i, e) => 'Lv. ${SubSkill.levelList[i]}: ${e.nameI18nKey}').join('\n');
            final ingredients = <(Ingredient, int)>[
              (pokemon.ingredient1, pokemon.ingredientCount1),
              (pokemon.ingredient2, pokemon.ingredientCount2),
              (pokemon.ingredient3, pokemon.ingredientCount3),
            ].mapIndexed((index, ingredient) => '${index + 1}. ${ingredient.$1.nameI18nKey} x${ingredient.$2}').join('\n');

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
                            '$subSkills'
                    ),
                  ),
                  Expanded(
                    child: Text(
                        '食材: \n'
                            '$ingredients\n'
                            '-----------------\n'
                            ''
                    ),
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
