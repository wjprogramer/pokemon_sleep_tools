import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/pokemon_profile.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/sleep_face_repository.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

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

  /// [PokemonBasicProfile.id] to [PokemonProfile]
  final _profileOf = <int, PokemonProfile>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();
      final profiles = await mainViewModel.loadProfiles();

      for (final profile in profiles) {
        _profileOf[profile.basicProfileId] = profile;
      }

      _basicProfileOf = await _basicProfileRepo.findAllMapping();
      _sleepFacesOf = await _sleepFaceRepo.findAllNames();

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, mainViewModel, child) {
        final profiles = mainViewModel.profiles;

        return Scaffold(
          appBar: buildAppBar(
            titleText: 't_sleep_illustrated_book'.xTr,
            actions: [
            ],
          ),
          body: buildListView(
            children: [
              ..._basicProfileOf.entries.map((entry) => _buildItem(
                entry.basicProfile,
              )),
              Gap.trailing,
            ],
          ),
        );
      }
    );
  }

  Widget _buildItem(PokemonBasicProfile basicProfile) {
    final sleepFace = _sleepFacesOf[basicProfile.id];
    final sleepFaceNames = sleepFace?.entries.map((e) => e.value).join(',') ?? Display.placeHolder;

    return InkWell(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
          vertical: 6,
        ),
        child: Row(
          children: [
            _SleepFaceHintIcon(
              atBag: _profileOf[basicProfile.id] != null,
              foundAllSleepFaces: false,
            ),
            Gap.md,
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}

extension _BasicProfileEntry on MapEntry<int, PokemonBasicProfile> {
  PokemonBasicProfile get basicProfile => value;
}

class _SleepFaceHintIcon extends StatelessWidget {
  const _SleepFaceHintIcon({
    Key? key,
    required this.atBag,
    required this.foundAllSleepFaces,
  }) : super(key: key);

  final bool atBag;
  final bool foundAllSleepFaces;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Opacity(
          opacity: atBag ? 1 : 0,
          child: const Padding(
            padding: EdgeInsets.only(right: 6),
            child: PokemonRecordedIcon(
              color: PokemonRecordedIcon.defaultColor,
            ),
          ),
        ),
        if (atBag && foundAllSleepFaces)
          Positioned(
            right: -2,
            top: -6,
            child: Icon(
              Icons.star,
              color: starIconColor,
              size: 15,
            ),
          ),
      ],
    );
  }
}
