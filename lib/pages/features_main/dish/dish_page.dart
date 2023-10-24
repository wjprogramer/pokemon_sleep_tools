import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_list/dish_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';

class _DishPageArgs {
  _DishPageArgs(this.dish, this.calculatorVisible);

  final Dish dish;

  /// TODO: [DishListPage] 可以設定食譜等級、調整顯示能量
  ///       在此頁面也可以做這件事，但可以根據 args 決定是否要顯示
  ///       例如：如果是從 [DishListPage] 跳轉到此頁面就不顯示（因為該頁面已經有計算器）
  ///             而如果從 [IngredientPage] 反查料理到此頁面，就顯示能量計算器
  final bool calculatorVisible;
}

const _pokemonSpacing = 12.0;
const _pokemonBaseSize = 52.0;

class DishPage extends StatefulWidget {
  const DishPage._(this._args);

  static const MyPageRoute route = ('/DishPage', _builder);
  static Widget _builder(dynamic args) {
    return DishPage._(args);
  }

  static void go(BuildContext context, Dish dish, {
    bool calculatorVisible = false,
  }) {
    context.nav.push(
      route,
      arguments: _DishPageArgs(dish, calculatorVisible),
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
  /// Lv1
  final _basicProfileOfIngredientLv1 = <Ingredient, List<PokemonBasicProfile>>{};
  /// Lv 1 ~ 30
  final _basicProfileOfIngredientLv30 = <Ingredient, List<PokemonBasicProfile>>{};
  /// Lv 1 ~ 60
  final _basicProfileOfIngredientLv60 = <Ingredient, List<PokemonBasicProfile>>{};

  // Data (Dish energy calculator)
  var _currDishLevel = 1;
  DishLevelInfo? _dishLevelInfo;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _ingredients = _dish.getIngredients();
      final targetIngredients = _ingredients.map((e) => e.$1).toList();

      for (final ingredient in targetIngredients) {
        _basicProfileOfIngredientLv1[ingredient] = [];
        _basicProfileOfIngredientLv30[ingredient] = [];
        _basicProfileOfIngredientLv60[ingredient] = [];
      }

      final basicProfiles = await _basicProfileRepo.findAll();
      for (final basicProfile in basicProfiles) {
        for (final ingredient in targetIngredients) {
          if (basicProfile.ingredient1 == ingredient) {
            _basicProfileOfIngredientLv1[ingredient]?.add(basicProfile);
          }

          final ingredients2 = basicProfile.ingredientOptions2.map((e) => e.$1);
          if (ingredients2.contains(ingredient)) {
            _basicProfileOfIngredientLv30[ingredient]?.add(basicProfile);
          }

          final ingredients3 = basicProfile.ingredientOptions3.map((e) => e.$1);
          if (ingredients3.contains(ingredient)) {
            _basicProfileOfIngredientLv60[ingredient]?.add(basicProfile);
          }
        }
      }

      for (final ingredient in targetIngredients) {
        _basicProfileOfIngredientLv1[ingredient]?.sort((a, b) => a.boxNo - b.boxNo);
        _basicProfileOfIngredientLv30[ingredient]?.sort((a, b) => a.boxNo - b.boxNo);
        _basicProfileOfIngredientLv60[ingredient]?.sort((a, b) => a.boxNo - b.boxNo);
      }

      await _updateDishLevelInfo();
      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;
    final screenSize = context.mediaQuery.size;
    final mainWidth = screenSize.width - 2 * Gap.hV;

    if (!_initialized) {
      return LoadingView(titleText: _titleText);
    }

    final pokemonItemSize = UiUtility.getChildWidthInRowBy(
      baseChildWidth: _pokemonBaseSize,
      containerWidth: mainWidth,
      spacing: _pokemonSpacing,
    );

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
          if (_ingredients.isEmpty)
            Hp(child: Text('t_no_match_other_ingredient_of_dish_hint'.xTr))
          else ..._ingredients.map((ingredient) => ListTile(
            onTap: () {
              IngredientPage.go(context, ingredient.$1);
            },
            title: Row(
              children: [
                if (MyEnv.USE_DEBUG_IMAGE)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IngredientImage(
                      width: 30,
                      ingredient: ingredient.$1,
                    ),
                  ),
                Text('${ingredient.$1.nameI18nKey.xTr} x${ingredient.$2}')
              ],
            ),
          )),
          if (widget._args.calculatorVisible) ...Hp.list(
            children: [
              MySubHeader(
                titleText: 't_set_recipe_level'.xTr,
              ),
              const SizedBox(height: Gap.smV,),
              SliderWithButtons(
                value: _currDishLevel.toDouble(),
                max: MAX_RECIPE_LEVEL.toDouble(),
                min: 1,
                divisions: MAX_RECIPE_LEVEL - 1,
                onChanged: (v) async {
                  _currDishLevel = v.toInt();
                  await _updateDishLevelInfo();
                  setState(() { });
                },
                hideSlider: true,
              ),
              if (_dishLevelInfo != null)
                Text(Display.numInt(_dishLevelInfo!.energy)),
            ],
          ),
          if (_ingredients.isNotEmpty) ...Hp.list(
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
                      child: const Text('Lv 1'),
                    ),
                  ),
                  Gap.md,
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 30;
                        setState(() { });
                      },
                      child: const Text('Lv 30'),
                    ),
                  ),
                  Gap.md,
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 60;
                        setState(() { });
                      },
                      child: const Text('Lv 60'),
                    ),
                  ),
                ],
              ),
              Gap.md,
              ..._ingredients.map((ingredient) {
                final basicProfiles = <PokemonBasicProfile>[
                  if (_currPokemonLevel >= 60) ...?_basicProfileOfIngredientLv60[ingredient.$1]
                  else if (_currPokemonLevel >= 30) ...?_basicProfileOfIngredientLv30[ingredient.$1]
                  else ...?_basicProfileOfIngredientLv1[ingredient.$1],
                ];

                return [
                  MySubHeader2(
                    title: Row(
                      children: [
                        if (MyEnv.USE_DEBUG_IMAGE)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: IngredientImage(
                              ingredient: ingredient.$1,
                              width: 32,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            ingredient.$1.nameI18nKey.xTr,
                            style: _theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.xs,
                  if (MyEnv.USE_DEBUG_IMAGE) ...[
                    Wrap(
                      spacing: _pokemonSpacing,
                      runSpacing: _pokemonSpacing,
                      children: basicProfiles.map((basicProfile) => InkWell(
                        onTap: () {
                          PokemonBasicProfilePage.go(context, basicProfile);
                        },
                        child: SizedBox(
                          height: pokemonItemSize,
                          width: pokemonItemSize,
                          child: PokemonIconBorderedImage(
                            basicProfile: basicProfile,
                          ),
                        ),
                      )).toList(),
                    ),
                  ] else Text(
                    basicProfiles
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

  Future<void> _updateDishLevelInfo() async {
    _dishLevelInfo = (await calcDishExpOf(_currDishLevel))[_dish];
  }
}


