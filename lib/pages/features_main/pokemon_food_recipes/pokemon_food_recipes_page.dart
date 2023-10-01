import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

class PokemonFoodRecipesPage extends StatefulWidget {
  const PokemonFoodRecipesPage._();

  static const MyPageRoute route = ('/PokemonFoodRecipesPage', _builder);
  static Widget _builder(dynamic args) {
    return const PokemonFoodRecipesPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PokemonFoodRecipesPage> createState() => _PokemonFoodRecipesPageState();
}

class _PokemonFoodRecipesPageState extends State<PokemonFoodRecipesPage> {

  // Page status
  var _isLoading = false;

  // Data
  var _currLevel = 2;
  var _dishLevelInfoOf = <Dish, DishLevelInfo>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _updateData();

      if (mounted) {
        setState(() { });
      }
    });
  }

  Future<void> _updateData() async {
    _dishLevelInfoOf = await _calcDishExpOf(_currLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_recipes'.xTr,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...Hp.list(
            children: [
              MySubHeader(
                titleText: 't_set_recipe_level'.xTr,
              ),
              SliderWithButtons(
                value: _currLevel.toDouble(),
                max: MAX_RECIPE_LEVEL.toDouble(),
                min: 1,
                divisions: MAX_RECIPE_LEVEL - 1,
                onChanged: (v) {
                  _currLevel = v.toInt();
                  _updateData();
                  setState(() { });
                },
              ),
              const SizedBox(height: Gap.xlV,),
              MySubHeader(
                titleText: 't_recipes'.xTr,
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: HORIZON_PADDING,
              ),
              children: [
                Gap.lg,
                ...Dish.values.map(_buildDish),
                Gap.trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDish(Dish dish) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: DishCard(
        dish: dish,
        level: _currLevel,
        energy: _dishLevelInfoOf[dish]?.energy,
        onTap: () {
          DishPage.go(context, dish);
        },
      ),
    );
  }

}

Future<Map<Dish, DishLevelInfo>> _calcDishExpOf(int recipeLevel) {
  return compute<Map<String, dynamic>, Map<Dish, DishLevelInfo>>(
    _calcDishLevelInfoOfAction,
    { 'level': recipeLevel },
  );
}

Future<Map<Dish, DishLevelInfo>> _calcDishLevelInfoOfAction(Map<String, dynamic> data) async {
  final recipeLevel = data['level'];
  final res = <Dish, DishLevelInfo>{};

  for (final dish in Dish.values) {
    final levelInfo = dish.getLevels()
        .firstWhereOrNull((e) => e.level == recipeLevel);

    if (levelInfo != null) {
      res[dish] = levelInfo;
    }
  }

  return res;
}
