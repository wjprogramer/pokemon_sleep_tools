import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/food_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

part 'src/ingredients_of_pot_view.dart';
part 'src/result_dishes_view.dart';

const _spacing = 12.0;

class DishMakerPage extends StatefulWidget {
  const DishMakerPage._();

  static const MyPageRoute route = ('/DishMakerPage', _builder);
  static Widget _builder(dynamic args) {
    return const DishMakerPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DishMakerPage> createState() => _DishMakerPageState();
}

class _DishMakerPageState extends State<DishMakerPage> with SingleTickerProviderStateMixin {

  FoodViewModel get _foodViewModel => context.read<FoodViewModel>();

  final _disposers = <MyDisposable>[];

  // UI
  late TabController _tabController;

  // Page status
  var _isInitialized = false;

  // Data (fixed)
  final _tabs = _Tab.valueList;
  var _allDishes = <Dish>[];
  /// Level 1: [Dish] map to required [Ingredient]s and their amounts
  /// Level 2: [Ingredient] map to amount
  var _requiredIngredientsOfDish = <Dish, Map<Ingredient, int>>{};

  // Data
  late StoredFood _storedFood;
  var _searchOptions = DishSearchOptions();
  var _dishLevelInfoOf = <Dish, DishLevelInfo>{};
  var _currLevel = 1;

  // Data (dish with steps) (steps: init -> )
  /// search [_allDishes] by [_searchOptions]
  var _searchedDishes = <Dish>[];
  /// check can cook by [_storedFood] (ingredients amount)
  var _canCookDishes = <Dish>[];

  @override
  void initState() {
    super.initState();
    _allDishes = [...Dish.values];
    _searchedDishes = _searchOptions.filter(_allDishes);
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );

    scheduleMicrotask(() async {
      _isInitialized = false;

      // Load fixed
      for (final dish in Dish.values) {
        final ingredientOptions = dish.getIngredients();
        _requiredIngredientsOfDish[dish] = ingredientOptions
            .toMap((e) => e.$1, (e) => e.$2);
      }

      // Load
      _storedFood = _foodViewModel.stored;
      await _updatePage();

      // Load finish
      _isInitialized = true;
      if (mounted) {
        setState(() { });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _disposers.addAll([
        _foodViewModel.xAddListener(_listenFoodViewModel),
      ]);
    });
  }

  Future<void> _listenFoodViewModel() async {
    _storedFood = _foodViewModel.stored;
    await _updatePage();
    setState(() { });
  }

  Future<void> _updatePage() async {
    _dishLevelInfoOf = await calcDishExpOf(_currLevel);

    // find dishes
    _canCookDishes = [];

    final currentPot = _storedFood.ingredientOf.mapping;
    for (final dish in _searchedDishes) {
      final requiredIngredients = _requiredIngredientsOfDish[dish] ?? {};
      var isEnough = true;

      for (final ingredientAndAmount in requiredIngredients.entries) {
        final ingredient = ingredientAndAmount.key;
        final requiredAmount = ingredientAndAmount.value;
        final currentAmount = currentPot[ingredient]?.amount ?? 0;
        if (currentAmount < requiredAmount) {
          isEnough = false;
          break;
        }
      }

      if (isEnough) {
        _canCookDishes.add(dish);
      }
    }
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildSingleTabView(_Tab tab, {
    required double dishItemWidth,
    required double ingredientItemWidth,
  }) {
    return switch (tab) {
      _Tab.potIngredients => _IngredientsOfPotView(
        itemWidth: ingredientItemWidth,
        onAmountChanged: (ingredient, amount) {
          /// TODO: use Debounce?
          _onIngredientAmountChanged(ingredient, amount);
        },
        storedIngredientOf: _storedFood.ingredientOf.mapping,
      ),
      _Tab.resultDishes => _ResultDishesView(
        dishes: _searchedDishes,
        canCookDishSet: _canCookDishes.toSet(),
        itemWidth: dishItemWidth,
        dishLevelInfoOf: _dishLevelInfoOf,
        level: _currLevel,
        storedIngredientOf: _storedFood.ingredientOf.mapping,
      ),
    };
  }

  Future<void> _onIngredientAmountChanged(Ingredient ingredient, int amount) async {
    await _foodViewModel.updateIngredientAmount(ingredient, amount);
  }

  Widget _buildTab(_Tab tab) {
    return switch (tab) {
      _Tab.potIngredients => Text(
        tab.nameI18nKey.xTr,
      ),
      _Tab.resultDishes => Tooltip(
        message: '可製作/${_searchOptions.isEmptyOptions() ? '總數' : '篩選後數量'}',
        child: Text(
          '${tab.nameI18nKey.xTr} (${_canCookDishes.length}/${_searchedDishes.length})',
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const LoadingView();
    }

    final screenSize = context.mediaQuery.size;
    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;

    // for Dish
    final dishItemWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: 350,
      containerWidth: mainWidth,
      spacing: _spacing,
    );

    // for Ingredient
    final ingredientItemWidth = dishItemWidth;

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_dish_maker'.xTr,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              DialogUtility.text(
                context,
                title: Text('說明'.xTr),
                content: Text('1. 庫存會自動儲存'.xTr),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            tabs: [ // _canCookDishes
              ..._tabs.map((e) => _buildTab(e)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((e) => _buildSingleTabView(
                e,
                dishItemWidth: dishItemWidth,
                ingredientItemWidth: ingredientItemWidth,
              )).toList(),
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
              final allDishCount = _allDishes.length;
              final dishes = options.filter(_allDishes);
              return (dishes.length, allDishCount);
            },
          );
          if (searchOptions == null) {
            return;
          }

          _searchOptions = searchOptions;
          _searchedDishes = searchOptions.filter(_allDishes);
          _updatePage();
          setState(() { });
        },
        isSearchOn: _searchOptions.isEmptyOptions() ? null : true,
        // onSort: () {},
      ),
    );
  }
}

enum _Tab {
  /// 擁有食材
  potIngredients('擁有食材'),
  /// 可製作料理
  resultDishes('可製作料理');

  const _Tab(this.nameI18nKey);

  final String nameI18nKey;

  static List<_Tab> valueList = [
    potIngredients,
    resultDishes,
  ];

}


