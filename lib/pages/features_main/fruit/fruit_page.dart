import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:provider/provider.dart';

class _FruitPageArgs {
  _FruitPageArgs(this.fruit);

  final Fruit fruit;
}

/// TODO: 反查地圖，帶入樹果搜尋條件，顯示哪些寶可夢有對應樹果
///       原攻略網站好像沒實作
/// TODO: 粗略顯示哪些地圖有此樹果，如果沒有就直接打叉（但也不需要 disable，因為突然想到該地圖查東西）
class FruitPage extends StatefulWidget {
  const FruitPage._(this._args);

  static const MyPageRoute route = ('/FruitPage', _builder);
  static Widget _builder(dynamic args) {
    return FruitPage._(args);
  }

  static void go(BuildContext context, Fruit fruit) {
    context.nav.push(
      route,
      arguments: _FruitPageArgs(fruit),
    );
  }

  final _FruitPageArgs _args;

  @override
  State<FruitPage> createState() => _FruitPageState();
}

class _FruitPageState extends State<FruitPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  Fruit get _fruit => widget._args.fruit;

  // Data
  var _basicProfiles = <PokemonBasicProfile>[];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _basicProfiles = (await _basicProfileRepo.findAll()).where((basicProfile) {
        return basicProfile.fruit == _fruit;
      }).toList();

      // for (final dish in Dish.values) {
      //   final ingredients = dish.getIngredients();
      //   final dishContainsTargetIngredient = ingredients.any((pair) => pair.$1 == _ingredient);
      //   if (!dishContainsTargetIngredient) {
      //     continue;
      //   }
      //
      //   _dishList.add(dish);
      //   _dishIngredientsOf[dish] = ingredients;
      // }
      //
      // _initialized = true;
      // if (mounted) {
      //   setState(() { });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: _fruit.nameI18nKey.xTr,
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          Row(
            children: [
              const EnergyIcon(),
              Gap.sm,
              Text(
                '${Display.numInt(_fruit.energyIn1)} ~ ${Display.numInt(_fruit.energyIn60)}',
              ),
            ],
          ),

          Gap.trailing,
        ],
      ),
    );
  }
}


