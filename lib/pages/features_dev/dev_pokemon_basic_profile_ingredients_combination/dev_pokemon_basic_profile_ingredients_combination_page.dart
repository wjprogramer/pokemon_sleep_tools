import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';

part 'dev_pokemon_basic_profile_ingredients_combination_logic.dart';
part 'dev_pokemon_basic_profile_ingredients_combination_view.dart';

class _Args {
  _Args(this.basicProfile);

  final PokemonBasicProfile basicProfile;
}

class DevPokemonBasicProfileIngredientsCombinationPage extends StatefulWidget {
  const DevPokemonBasicProfileIngredientsCombinationPage._(this._args);
  
  static const MyPageRoute route = ('/DevPokemonBasicProfileIngredientsCombinationPage', _builder);
  static Widget _builder(dynamic args) {
    return DevPokemonBasicProfileIngredientsCombinationPage._(args);
  }

  static void go(BuildContext context, PokemonBasicProfile basicProfile) {
    context.nav.push(
      route,
      arguments: _Args(basicProfile),
    );
  }

  final _Args _args;

  @override
  State<DevPokemonBasicProfileIngredientsCombinationPage> createState() => _DevPokemonBasicProfileIngredientsCombinationLogic();
}
