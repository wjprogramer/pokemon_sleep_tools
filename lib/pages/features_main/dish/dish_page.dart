import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_recipes/pokemon_food_recipes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class _DishPageArgs {
  _DishPageArgs(this.dish);

  final Dish dish;
}

/// TODO: [PokemonFoodRecipesPage] 可以設定食譜等級、調整顯示能量
///       在此頁面也可以做這件事，但可以根據 args 決定是否要顯示
///       例如：如果是從 [PokemonFoodRecipesPage] 跳轉到此頁面就不顯示（因為該頁面已經有計算器）
///             而如果從 [IngredientPage] 反查料理到此頁面，就顯示能量計算器
class DishPage extends StatefulWidget {
  const DishPage._(this._args);

  static const MyPageRoute route = ('/DishPage', _builder);
  static Widget _builder(dynamic args) {
    return DishPage._(args);
  }

  static void go(BuildContext context, Dish dish) {
    context.nav.push(
      route,
      arguments: _DishPageArgs(dish),
    );
  }

  final _DishPageArgs _args;

  @override
  State<DishPage> createState() => _DishPageState();
}

class _DishPageState extends State<DishPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  Dish get _dish => widget._args.dish;

  String get _titleText => _dish.nameI18nKey.xTr;

  // UI
  late ThemeData _theme;

  // Page status
  var _initialized = false;

  // Data
  var _ingredients = <(Ingredient, int)>[];
  var _currPokemonLevel = 1;
  final _basicProfileOfIngredient = <Ingredient, List<PokemonBasicProfile>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _ingredients = _dish.getIngredients();
      final targetIngredients = _ingredients.map((e) => e.$1).toList();

      for (final ingredient in targetIngredients) {
        _basicProfileOfIngredient[ingredient] = [];
      }

      final basicProfiles = await _basicProfileRepo.findAll();
      for (final basicProfile in basicProfiles) {
        for (final ingredient in targetIngredients) {
          final containsIngredient = basicProfile.ingredient1 == ingredient ||
              basicProfile.ingredientOptions2.map((e) => e.$1).contains(ingredient) ||
              basicProfile.ingredientOptions3.map((e) => e.$1).contains(ingredient);
          if (!containsIngredient) {
            continue;
          }
          _basicProfileOfIngredient[ingredient]?.add(basicProfile);
        }
      }

      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;

    if (!_initialized) {
      return LoadingView(titleText: _titleText);
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: _dish.nameI18nKey.xTr,
      ),
      body: buildListView(
        children: [
          Hp(
            child: MySubHeader(
              titleText: 't_ingredients'.xTr,
            ),
          ),
          ..._ingredients.map((ingredient) => ListTile(
            onTap: () {
              IngredientPage.go(context, ingredient.$1);
            },
            title: Text('${ingredient.$1.nameI18nKey.xTr} x${ingredient.$2}'),
          )),
          ...Hp.list(
            children: [
              MySubHeader(
                titleText: 't_set_pokemon_level'.xTr,
              ),
              SliderWithButtons(
                value: _currPokemonLevel.toDouble(),
                onChanged: (v) {
                  _currPokemonLevel = v.toInt();
                  setState(() { });
                },
                max: 60,
                min: 1,
                divisions: 59,
              ),
              Gap.md,
              Row(
                children: [
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 1;
                        setState(() { });
                      },
                      child: Text('Lv 1'),
                    ),
                  ),
                  Gap.md,
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 30;
                        setState(() { });
                      },
                      child: Text('Lv 30'),
                    ),
                  ),
                  Gap.md,
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 60;
                        setState(() { });
                      },
                      child: Text('Lv 60'),
                    ),
                  ),
                ],
              ),
              Gap.md,
              ..._ingredients.map((ingredient) {
                return [
                  Text(
                    ingredient.$1.nameI18nKey.xTr,
                    style: _theme.textTheme.bodyLarge,
                  ),
                  // TODO: 反查寶可夢
                  // TODO: 詳細可看食材頁面的寫法
                  Gap.xs,
                  Text(
                      (_basicProfileOfIngredient[ingredient.$1] ?? [])
                          .map((basicProfile) => basicProfile.nameI18nKey.xTr).join(','),
                  ),
                  Gap.md,
                ];
              }).expand((e) => e),
            ],
          ),
          Gap.trailing,
        ],
      ),
    );
  }
}


