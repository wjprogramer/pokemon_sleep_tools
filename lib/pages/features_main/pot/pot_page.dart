import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// TODO: 篩選 [DishSearchOptions]
/// TODO: 可設定食材等級
/// TODO: 反查料理
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

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      // Init
      for (final potCapacity in POT_CAPACITIES_OPTIONS) {
        _dishesOfPotCapacity[potCapacity] = [];
      }

      // Load
      final tmpDishes = [...Dish.values];
      for (var i = 0; i < POT_CAPACITIES_OPTIONS.length; i++) {
        _dishesOfPotCapacity[POT_CAPACITIES_OPTIONS[i]] =
            tmpDishes.xRemoveWhere((dish) => dish.capacity < POT_CAPACITIES_OPTIONS[i]);
      }

      // Complete
      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return LoadingView();
    }

    final mainContentWidth = context.mediaQuery.size.width - 2 * HORIZON_PADDING;
    final leadingWidth = math.min(mainContentWidth * 0.2, 100).toDouble();

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_pot'.xTr,
      ),
      body: buildListView(
        children: [
          ...POT_CAPACITIES_OPTIONS.map((e) => Hp(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width: leadingWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(e.toString()),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    (_dishesOfPotCapacity[e] ?? []).map((e) => e.nameI18nKey.xTr).join(', '),
                  ),
                ),
              ],
            ),
          )),
          Gap.trailing,
        ],
      ),
    );
  }
}


