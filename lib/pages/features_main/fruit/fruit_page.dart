import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

class _FruitPageArgs {
  _FruitPageArgs(this.fruit);

  final Fruit fruit;
}

/// TODO: 反查地圖，帶入樹果搜尋條件，顯示哪些寶可夢有對應樹果
///       原攻略網站有地圖入口、但好像沒實作
/// TODO: 粗略顯示哪些地圖有此樹果，如果沒有就直接打叉（但也不需要 disable，因為突然想到該地圖查東西）
/// TODO: 可設定寶可夢等級，顯示樹果能量，以及顯示各項寶可夢食材組合的能量
/// TODO: 反查寶可夢
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

  // Page status
  var _initialized = false;

  // Data
  var _basicProfiles = <PokemonBasicProfile>[];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _basicProfiles = (await _basicProfileRepo.findAll()).where((basicProfile) {
        return basicProfile.fruit == _fruit;
      }).toList();

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
          ..._basicProfiles.map((e) => Text(
            e.nameI18nKey.xTr,
          )),
          Gap.trailing,
        ],
      ),
    );
  }
}


