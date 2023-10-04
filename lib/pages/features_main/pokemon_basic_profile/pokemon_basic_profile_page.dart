import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/sleep_face_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:provider/provider.dart';

class _PokemonBasicProfilePageArgs {
  _PokemonBasicProfilePageArgs(this.basicProfile);

  final PokemonBasicProfile basicProfile;
}

/// TODO: 反查寶可夢盒
///
/// 攻略網站：會附上各種睡姿的圖片、
class PokemonBasicProfilePage extends StatefulWidget {
  const PokemonBasicProfilePage._(this._args);

  static const MyPageRoute route = ('/PokemonBasicProfilePage', _builder);
  static Widget _builder(dynamic args) {
    return PokemonBasicProfilePage._(args);
  }

  static void go(BuildContext context, PokemonBasicProfile basicProfile) {
    context.nav.push(
      route,
      arguments: _PokemonBasicProfilePageArgs(basicProfile),
    );
  }

  final _PokemonBasicProfilePageArgs _args;

  @override
  State<PokemonBasicProfilePage> createState() => _PokemonBasicProfilePageState();
}

class _PokemonBasicProfilePageState extends State<PokemonBasicProfilePage> {
  SleepFaceRepository get _sleepFaceRepo => getIt();

  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;

  // Page status
  var _initialized = false;

  // Data
  final _sleepFacesOfField = <PokemonField, List<SleepFace>>{};

  /// [SleepFace.style] to its nama
  var _sleepNamesOfBasicProfile = <int, String>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      for (final field in PokemonField.values) {
        _sleepFacesOfField[field] = [];
      }

      final mainViewModel = context.read<MainViewModel>();
      await mainViewModel.loadProfiles();

      final allSleepFaces = await _sleepFaceRepo.findAll();
      final sleepFaces = allSleepFaces.where((sleepFace) => sleepFace.basicProfileId == _basicProfile.id).toList();

      final allSleepNames = await _sleepFaceRepo.findAllNames();
      _sleepNamesOfBasicProfile = allSleepNames[_basicProfile.id] ?? {};

      for (final sleepFace in sleepFaces) {
        _sleepFacesOfField[sleepFace.field]?.add(sleepFace);
      }

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
        titleText: _basicProfile.nameI18nKey.xTr,
      ),
      body: Consumer<MainViewModel>(
        builder: (context, mainViewModel, child) {
          final profiles = mainViewModel.profiles;

          final text = _basicProfile.pokemonType.nameI18nKey.xTr + '\n'
              + _basicProfile.mainSkill.nameI18nKey.xTr + '\n'
              + _basicProfile.sleepType.nameI18nKey.xTr+ '\n'
              + _basicProfile.specialty.nameI18nKey.xTr+ '\n'
              + _basicProfile.boxNo.toString() + '\n'
              + _basicProfile.helpInterval.toString() + '\n'
              + _basicProfile.fruit.nameI18nKey.xTr;

          // 食材 1,2,3

          return buildListView(
            padding: const EdgeInsets.symmetric(
              horizontal: HORIZON_PADDING,
            ),
            children: [
              Text(
                text,
              ),
              MySubHeader(
                titleText: 't_sleep_faces'.xTr,
              ),
              ..._sleepFacesOfField.entries.map((e) {
                final field = e.key;
                final sleepFaces = e.value;

                return <Widget>[
                  Text(
                    field.nameI18nKey.xTr,
                  ),
                  ...sleepFaces.map((sleepFace) => _buildSleepFace(sleepFace)),
                ];
              }).expand((e) => e),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSleepFace(SleepFace sleepFace) {
    return Container(
      // padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            _sleepNamesOfBasicProfile[sleepFace.style] ?? _sleepFaceRepo.getCommonSleepFaceName(sleepFace.style) ?? '',
          ),
          PokemonRankTitleIcon(rank: sleepFace.snorlaxRank.title,),
        ],
      ),
    );
  }

}


