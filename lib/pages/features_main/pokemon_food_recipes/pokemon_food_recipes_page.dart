import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';

/// TODO: 儲存篩選條件？自動存？手動存？存食譜等級？存鍋子容量？可設定需要自動儲存哪些？之後會有匯出匯入資料的功能，要連同這些設定一起儲存？
/// 鍋子容量照理來說，不會變少，應該可以自動儲存？
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
  var _currLevel = 1;
  var _dishLevelInfoOf = <Dish, DishLevelInfo>{};
  var _dishes = <Dish>[];
  var _searchOptions = DishSearchOptions();

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _dishes = [...Dish.values];
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
              const SizedBox(height: Gap.smV,),
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
                hideSlider: true,
              ),
              // const SizedBox(height: Gap.smV,),
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
                // IconButton(
                //   onPressed: () {}, icon: Icon(),
                // ),
                ..._dishes.map(_buildDish),
                Gap.trailing,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarWithActions(
        onSearch: () async {
          final searchOptions = await DialogUtility.pickDishSearchOptions(
            context,
            initialSearchOptions: _searchOptions,
            calcCounts: (options) {
              final allDishCount = Dish.values.length;
              final dishes = _filterDishes(Dish.values, options);
              return (dishes.length, allDishCount);
            },
          );

          _searchOptions = searchOptions;
          _dishes = _filterDishes(Dish.values, searchOptions);
          setState(() { });
        },
        isSearchOn: _searchOptions.isEmptyOptions() ? null : true,
        // onSort: () {},
      ),
    );
  }

  List<Dish> _filterDishes(List<Dish> dishes, DishSearchOptions options) {
    if (options.isEmptyOptions()) {
      return Dish.values;
    }

    Iterable<Dish> dishes = Dish.values;

    if (options.potCapacity != null) {
      dishes = dishes.where((dish) => dish.capacity <= options.potCapacity!);
    }
    if (options.dishTypes.isNotEmpty) {
      dishes = dishes.where((dish) => options.dishTypes.contains(dish.dishType));
    }
    if (options.ingredientOf.isNotEmpty) {
      dishes = dishes.where((dish) {
        final ingredients = dish.getIngredients().map((e) => e.$1);
        return ingredients.any((e) => options.ingredientOf.contains(e));
      });
    }

    return dishes.toList();
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
