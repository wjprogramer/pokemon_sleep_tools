import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_recipes/pokemon_food_recipes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class PokemonFoodMenuPage extends StatefulWidget {
  const PokemonFoodMenuPage._();

  static const MyPageRoute route = ('PokemonFoodMenuPage', _builder);
  static Widget _builder(dynamic args) {
    return const PokemonFoodMenuPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PokemonFoodMenuPage> createState() => _PokemonFoodMenuPageState();
}

class _PokemonFoodMenuPageState extends State<PokemonFoodMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_food'.xTr,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: HORIZON_PADDING),
        children: [
          MyElevatedButton(
            onPressed: () {
              PokemonFoodRecipesPage.go(context);
            },
            child: Text('t_recipes_view'.xTr),
          ),
        ],
      ),
    );
  }
}
