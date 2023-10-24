import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';

const _leadingPlaceholderSize = DishLabel.defaultImageSize;

/// 原攻略網站有做個等級累進料理數量 （個人覺得沒必要）
class PotPage extends StatefulWidget {
  const PotPage._();

  static const MyPageRoute route = ('/PotPage', _builder);
  static Widget _builder(dynamic args) {
    return const PotPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PotPage> createState() => _PotPageState();
}

class _PotPageState extends State<PotPage> {

  // Page status
  var _initialized = false;

  // Data
  final _dishesOfPotCapacity = <int, List<Dish>>{};
  var _searchOptions = DishSearchOptions();

  // Data (once init)
  final _capacityToIndex = <int, int>{};
  final _capacityToAccumulateDreamChips = <int, int>{};

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      POT_CAPACITIES_OPTIONS.forEachIndexed((index, capacity) {
        _capacityToIndex[capacity] = index;
        if (index == 0) {
          _capacityToAccumulateDreamChips[capacity] = POT_DREAM_CHIPS[index];
        } else {
          _capacityToAccumulateDreamChips[capacity] = _capacityToAccumulateDreamChips[POT_CAPACITIES_OPTIONS[index - 1]]! + POT_DREAM_CHIPS[index];
        }
      });

      _load();
    });
  }

  Future<void> _load({
    List<Dish>? dishes,
  }) async {
    // Clear old
    _dishesOfPotCapacity.clear();

    // Init
    for (final potCapacity in POT_CAPACITIES_OPTIONS) {
      _dishesOfPotCapacity[potCapacity] = [];
    }

    // Load
    final tmpDishes = [...(dishes ?? Dish.values)];
    for (var i = 0; i < POT_CAPACITIES_OPTIONS.length; i++) {
      _dishesOfPotCapacity[POT_CAPACITIES_OPTIONS[i]] =
          tmpDishes.xRemoveWhere((dish) => dish.capacity < POT_CAPACITIES_OPTIONS[i]);
    }

    // Complete
    _initialized = true;
    if (mounted) {
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return LoadingView();
    }

    final mainContentWidth = context.mediaQuery.size.width - 2 * HORIZON_PADDING;
    final leadingWidth = math.min(mainContentWidth * 0.2, 100).toDouble();

    Iterable<int> potCapacitiesOptions = <int>[...POT_CAPACITIES_OPTIONS];
    if (_searchOptions.potCapacity != null) {
      potCapacitiesOptions = potCapacitiesOptions
          .where((potCapacity) => potCapacity <= _searchOptions.potCapacity!);
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_pot'.xTr,
      ),
      body: buildListView(
        children: [
          ...potCapacitiesOptions.map((potCapacity) => Hp(
            child: _buildRow(
              potCapacity: potCapacity,
            ),
          )),
          Gap.trailing,
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
          _load(
            dishes: searchOptions.filter(Dish.values),
          );
        },
        isSearchOn: _searchOptions.isEmptyOptions() ? null : true,
        // onSort: () {},
      ),
    );
  }

  Widget _buildRow({
    required int potCapacity,
  }) {
    final dishes = _dishesOfPotCapacity[potCapacity] ?? [];

    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MySubHeader2(
            title: Row(
              children: [
                Stack(
                  children: [
                    _buildCapacityLeadingPlaceholder(),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildCapacityLeading(
                          potCapacity,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: DreamChipIcon(size: 18,),
                        ),
                        TextSpan(
                          text: '${Display.numInt(_capacityToAccumulateDreamChips[potCapacity]!)} (+${Display.numInt(POT_DREAM_CHIPS[_capacityToIndex[potCapacity]!])})',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: dishes.map((dish) => DishLabel(
              dish: dish,
              onTap: () {
                DishPage.go(context, dish);
              },
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityLeadingPlaceholder() {
    return _buildCapacityLeading(999, isPlaceholder: true);
  }

  Widget _buildCapacityLeading(int capacity, {
    bool isPlaceholder = false,
  }) {
    if (isPlaceholder) {
      return Opacity(
        opacity: 0,
        child: SizedBox(
          width: _leadingPlaceholderSize,
          child: Text(capacity.toString()),
        ),
      );
    }

    return Text(
      capacity.toString(),
    );
  }
}


