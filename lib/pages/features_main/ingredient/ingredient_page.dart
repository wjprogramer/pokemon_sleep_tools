import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dream_chip_icon.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/energy_icon.dart';

class _IngredientPageArgs {
  _IngredientPageArgs(this.ingredient);

  final Ingredient ingredient;
}

class IngredientPage extends StatefulWidget {
  const IngredientPage._(this._args);

  static const MyPageRoute route = ('/IngredientPage', _builder);
  static Widget _builder(dynamic args) {
    return IngredientPage._(args);
  }

  static void go(BuildContext context, Ingredient ingredient) {
    context.nav.push(
      route,
      arguments: _IngredientPageArgs(ingredient),
    );
  }

  final _IngredientPageArgs _args;

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  Ingredient get _ingredient => widget._args.ingredient;
  String get _titleText => _ingredient.nameI18nKey.xTr;

  // UI
  late ThemeData _theme;

  // Page status
  var _initialized = false;

  // Data
  final _dishList = <Dish>[];
  final _dishIngredientsOf = <Dish, List<(Ingredient, int)>>{};
  var _basicProfiles = <PokemonBasicProfile>[];

  var _currPokemonLevel = 1;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _basicProfiles = (await _basicProfileRepo.findAll()).where((basicProfile) {
        return basicProfile.ingredient1 == _ingredient ||
            [
              ...basicProfile.ingredientOptions2.map((e) => e.$1),
              ...basicProfile.ingredientOptions3.map((e) => e.$1),
            ].contains(_ingredient);
      }).toList()..sort((a, b) {
        if (a.ingredient1 == b.ingredient1) { return 0; }
        return a.ingredient1 == _ingredient ? -1 : 1;
      });

      for (final dish in Dish.values) {
        final ingredients = dish.getIngredients();
        final dishContainsTargetIngredient = ingredients.any((pair) => pair.$1 == _ingredient);
        if (!dishContainsTargetIngredient) {
          continue;
        }

        _dishList.add(dish);
        _dishIngredientsOf[dish] = ingredients;
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
        titleText: _titleText,
      ),
      body: buildListView(
        children: [
          ...Hp.list(
            children: [
              Row(
                children: [
                  EnergyIcon(),
                  Gap.xl,
                  Text(
                    Display.numInt(_ingredient.energy),
                  ),
                ],
              ),
              Gap.md,
              Row(
                children: [
                  DreamChipIcon(),
                  Gap.xl,
                  Text(
                    Display.numInt(_ingredient.dreamChips),
                  ),
                ],
              ),
              MySubHeader(
                titleText: 't_food'.xTr,
              ),
            ],
          ),
          if (_dishList.isEmpty)
            Hp(child: Text('t_none'.xTr),)
          else ..._dishList.map((dish) => InkWell(
            onTap: () {
              DishPage.go(context, dish);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: HORIZON_PADDING,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    dish.nameI18nKey.xTr,
                    style: _theme.textTheme.bodyLarge,
                  ),
                  Text(
                    _dishIngredientsOf[dish]
                        ?.map((ingredientPair) => '${ingredientPair.$1.nameI18nKey.xTr} x${ingredientPair.$2}')
                        .join(', ') ?? '',
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: greyColor3,
                    ),
                  ),
                ],
              ),
            ),
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
              Gap.sm,
              Divider(),
              Gap.sm,
              MySubHeader(
                titleText: 't_hold_someone_pokemon'.trParams({
                  'someone': _ingredient.nameI18nKey.xTr,
                }),
              ),
              ..._basicProfiles
                  .map((e) => _buildBasicProfile(e))
                  .expand((e) => e),
            ],
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  /// TODO: 反查寶可夢
  /// TODO: 需要計算各種組合的能量
  ///     例如
  ///     [PokemonBasicProfile.ingredientOptions2] 的第一個，配上 [PokemonBasicProfile.ingredientOptions3] 第一個
  ///     [PokemonBasicProfile.ingredientOptions2] 的第一個，配上 [PokemonBasicProfile.ingredientOptions3] 第二個
  ///     然後各種組合的差異數值 （攻略網站：同一種寶可夢不同組合，會有不同的間隔時間、能量）
  ///     https://pks.raenonx.cc/ingredient/3
  ///
  /// TODO: 注意，有些對應食材，需要等到 Lv 30 或 Lv 60
  List<Widget> _buildBasicProfile(PokemonBasicProfile basicProfile) {
    return [
      Gap.sm,
      Text(basicProfile.nameI18nKey.xTr),
      Text('1. ${basicProfile.ingredient1.nameI18nKey.xTr}'),
      if (_currPokemonLevel >= 30)
        Text('2. ${basicProfile.ingredientOptions2.map((e) => e.$1.nameI18nKey.xTr).join('t_separator'.xTr)}'),
      if (_currPokemonLevel >= 60)
        Text('3. ${basicProfile.ingredientOptions3.map((e) => e.$1.nameI18nKey.xTr).join('t_separator'.xTr)}'),
      Gap.md,
    ];
  }
}


