import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/sleep_face_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/sleep_face_view_model.dart';
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
///
/// TODO: 需要增加圖示說明? 例如星號代表全睡姿蒐集完成
/// TODO: 切換顯示 "隱藏或不隱藏沒有睡姿的寶可夢"
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

  // UI
  late ThemeData _theme;

  var _basicProfileOf = <int, PokemonBasicProfile>{};

  /// [PokemonBasicProfile.id] to sleep face names
  var _sleepFacesNamesOf = <int, Map<int, String>>{};

  /// [PokemonBasicProfile.id] to [SleepFace] list
  final _sleepFacesOf = <int, List<SleepFace>>{};

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
      _sleepFacesNamesOf = await _sleepFaceRepo.findAllNames();

      final sleepFaces = await _sleepFaceRepo.findAll();
      for (final sleepFace in sleepFaces) {
        if (!_sleepFacesOf.containsKey(sleepFace.basicProfileId)) {
          _sleepFacesOf[sleepFace.basicProfileId] = [];
        }
        _sleepFacesOf[sleepFace.basicProfileId]!.add(sleepFace);
      }

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;

    return Consumer2<MainViewModel, SleepFaceViewModel>(
      builder: (context, mainViewModel, sleepFaceViewModel, child) {
        final markStylesOf = sleepFaceViewModel.markStylesOf;

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
                {...markStylesOf[entry.basicProfile.id] ?? []},
              )),
              Gap.trailing,
            ],
          ),
        );
      }
    );
  }

  Widget _buildItem(PokemonBasicProfile basicProfile, Set<int> markStyleIds) {
    final sleepFaceNameOf = _sleepFacesNamesOf[basicProfile.id] ?? {};
    final sleepFaces = _sleepFacesOf[basicProfile.id] ?? [];
    final distinctStyles = {...sleepFaces.map((e) => e.style)};
    final noAnyStyle = distinctStyles.isEmpty;
    final foundAllSleepFaces = distinctStyles.length == markStyleIds.length;
    final sleepFaceNameStyle = _theme.textTheme.bodySmall?.copyWith(color: greyColor3);

    final sleepFaceStyleItem = distinctStyles.map((style) {
      final sleepFaceName = sleepFaceNameOf[style] ?? _sleepFaceRepo.getCommonSleepFaceName(style);

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BookmarkIcon(
              marked: markStyleIds.contains(style),
              unMarkColor: greyColor2,
              size: (sleepFaceNameStyle?.fontSize ?? 12) * 1.3,
            ),
            Gap.xs,
            Text(sleepFaceName ?? '',
              style: sleepFaceNameStyle,
            ),
          ],
        ),
      );
    });

    return InkWell(
      onTap: () {
        PokemonBasicProfilePage.go(context, basicProfile);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
          vertical: 7,
        ),
        child: Row(
          children: [
            _SleepFaceHintIcon(
              atBag: _profileOf[basicProfile.id] != null,
              foundAllSleepFaces: foundAllSleepFaces,
              noAnyStyle: noAnyStyle,
            ),
            Gap.md,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    basicProfile.nameI18nKey.xTr,
                  ),
                  Wrap(
                    children: [
                      ...sleepFaceStyleItem,
                    ],
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
    required this.noAnyStyle,
  }) : super(key: key);

  final bool atBag;
  final bool foundAllSleepFaces;
  final bool noAnyStyle;

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
        if (!atBag && foundAllSleepFaces && !noAnyStyle)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.star,
              color: starIconColor,
            ),
          ),
        if (atBag && foundAllSleepFaces && !noAnyStyle)
          Positioned(
            right: -2,
            top: -6,
            child: Icon(
              Icons.star,
              color: starIconColor,
              size: 15,
            ),
          ),
        if (noAnyStyle)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Iconify(
              Tabler.zzz_off,
              color: greyColor2,
              size: 16,
            ),
          ),
      ],
    );
  }
}
