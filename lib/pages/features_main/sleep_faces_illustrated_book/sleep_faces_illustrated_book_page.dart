import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/sleep_face_repository.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// TODO:
/// 遊戲中可以切換「顯示模式」
/// 1. 顯示睡姿
/// 2. 顯示寶可夢
///
/// TODO:
/// 用「淺夢入睡、安然入睡、深深入睡」區分
class SleepFacesIllustratedBookPage extends StatefulWidget {
  const SleepFacesIllustratedBookPage._();

  static const MyPageRoute route = ('/SleepFacesIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const SleepFacesIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<SleepFacesIllustratedBookPage> createState() => _SleepFacesIllustratedBookPageState();
}

class _SleepFacesIllustratedBookPageState extends State<SleepFacesIllustratedBookPage> {

  PokemonBasicProfileRepository get _basicProfileRepo => getIt();
  SleepFaceRepository get _sleepFaceRepo => getIt();

  var _basicProfileOf = <int, PokemonBasicProfile>{};
  var _sleepFacesOf = <int, Map<int, String>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _basicProfileOf = await _basicProfileRepo.findAllMapping();
      _sleepFacesOf = await _sleepFaceRepo.findAllNames();

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_sleep_illustrated_book'.xTr,
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          ..._basicProfileOf.entries.map((entry) => _buildItem(
            entry.basicProfile,
          )),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildItem(PokemonBasicProfile basicProfile) {
    final sleepFace = _sleepFacesOf[basicProfile.id];
    final sleepFaceNames = sleepFace?.entries.map((e) => e.value).join(',') ?? Display.placeHolder;

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            basicProfile.nameI18nKey.xTr,
          ),
          Text(
            sleepFaceNames,
          ),
        ],
      ),
    );
  }
}

extension _BasicProfileEntry on MapEntry<int, PokemonBasicProfile> {
  PokemonBasicProfile get basicProfile => value;
}


