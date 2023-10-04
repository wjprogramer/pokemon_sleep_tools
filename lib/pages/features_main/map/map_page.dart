import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_illustrated_book/pokemon_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

class _MapPageArgs {
  _MapPageArgs(this.field);

  final PokemonField field;
}

/// TODO:
/// 篩選：
/// 寶可夢屬性、樹果、專長、睡眠類型、食材 Lv1、食材 Lv30、食材 Lv60、進化階段、主技能
///
/// [PokemonIllustratedBookPage] 可以參考此頁面的資訊
///
class MapPage extends StatefulWidget {
  const MapPage._(this._args);

  static const MyPageRoute route = ('/MapPage', _builder);
  static Widget _builder(dynamic args) {
    return MapPage._(args);
  }

  static void go(BuildContext context, PokemonField field) {
    context.nav.push(
      route,
      arguments: _MapPageArgs(field),
    );
  }

  final _MapPageArgs _args;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  SleepFaceRepository get _sleepFaceRepo => getIt();

  PokemonField get _field => widget._args.field;

  // UI
  late ThemeData _theme;

  // Page status
  var _initialized = false;

  // Data
  var _rewards = <SnorlaxReward>[];
  var _sleepFacesOfRank = <SnorlaxRank, List<SleepFace>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _rewards = _field.getSnorlaxRewardList();
      for (var reward in _rewards) {
        _sleepFacesOfRank[reward.rank] = [];
      }

      final sleepFaces = await _sleepFaceRepo.findAll();
      sleepFaces.removeWhere((sleepFace) => sleepFace.field != _field);
      for (var sleepFace in sleepFaces) {
        _sleepFacesOfRank[sleepFace.snorlaxRank]?.add(sleepFace);
      }

      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    if (!_initialized) {
      return LoadingView();
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: _field.nameI18nKey.xTr,
      ),
      body: buildListView(
        children: [
          ..._rewards.map((e) => <Widget>[
            Text(
              '${e.rank.title.nameI18nKey.xTr} ${e.rank.number}',
            ),
            Row(
              children: [
                const EnergyIcon(),
                Text(
                  Display.numInt(e.energy),
                ),
                Gap.sm,
                const DreamChipIcon(),
                Text(
                  Display.numInt(e.dreamChips),
                ),
              ],
            ),
            Text(
              (_sleepFacesOfRank[e.rank]?.length ?? 0).toString(),
            ),
          ]).expand((e) => e),
        ],
      ),
    );
  }
}


