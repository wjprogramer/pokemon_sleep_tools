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

enum _PageType {
  view,
  pick,
}

class _Args {
  _Args({
    required this.pageType,
  });

  final _PageType pageType;
}

/// TODO: 儲存篩選條件？自動存？手動存？存食譜等級？存鍋子容量？可設定需要自動儲存哪些？之後會有匯出匯入資料的功能，要連同這些設定一起儲存？
/// 鍋子容量照理來說，不會變少，應該可以自動儲存？
class DishListPage extends StatefulWidget {
  const DishListPage._(this._args);

  static const MyPageRoute route = ('/DishListPage', _builder);
  static Widget _builder(dynamic args) {
    return DishListPage._(args);
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
      arguments: _Args(pageType: _PageType.view),
    );
  }

  static Future<(Dish, int)?> pick(BuildContext context) async {
    final res = await context.nav.push(
      route,
      arguments: _Args(pageType: _PageType.pick),
    );
    return res is (Dish, int) ? res : null;
  }

  final _Args _args;

  void _popResult(BuildContext context, [(Dish, int)? dishLevel]) {
    context.nav.pop(dishLevel);
  }

  @override
  State<DishListPage> createState() => _DishListPageState();
}

class _DishListPageState extends State<DishListPage> {
  _PageType get _pageType => widget._args.pageType;

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

    scheduleMicrotask(() async {
      _dishes = [...Dish.values];
      await _updateData();

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
                onChanged: (v) async {
                  _currLevel = v.toInt();
                  await _updateData();
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
              final dishes = options.filter(Dish.values);
              return (dishes.length, allDishCount);
            },
          );
          if (searchOptions == null) {
            return;
          }

          _searchOptions = searchOptions;
          _dishes = searchOptions.filter(Dish.values);
          setState(() { });
        },
        isSearchOn: _searchOptions.isEmptyOptions() ? null : true,
        // onSort: () {},
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
          switch (_pageType) {
            case _PageType.view:
              DishPage.go(context, dish);
              break;
            case _PageType.pick:
              widget._popResult(context, (dish, _currLevel));
              break;
          }
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
