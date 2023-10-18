import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/sleep_face_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// TODO: 篩選條件: 睡姿 [PokemonField]、名稱、[PokemonType]、[Fruit]、[PokemonSpecialty]、[SleepType]、利用食材 Lv1/30/60/any 查詢 [Ingredient]、目前進化街段(1,2,3)、最終進化街段(1,2,3)、
/// TODO: 篩選器有寶可夢等級，但這個等級是顯示寶可夢對應能量的數值，所以實際上不是篩選器條件之一
///
/// TODO: 顯示資訊可以調整 "ID、樹果能量、樹果產量、食材能量、食材產量、食材機率、總能量、友情點數、幫忙間隔 (基礎)、幫忙間隔 (等效)、幫忙間隔 (樹果)、幫忙間隔 (食材)、滿包所需時長、樹果、食材、主技能、睡眠類型、專長"
/// TODO: 排序可以調整 "ID、樹果能量、樹果產量、食材能量、食材產量、食材機率、總能量、友情點數、幫忙間隔 (基礎)、幫忙間隔 (等效)、幫忙間隔 (樹果)、幫忙間隔 (食材)、滿包所需時長"
///
/// TODO: 寶可夢數量: 篩選數量 / 全部數量
///
class PokemonIllustratedBookPage extends StatefulWidget {
  const PokemonIllustratedBookPage._();

  static const MyPageRoute route = ('/PokemonIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const PokemonIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PokemonIllustratedBookPage> createState() => _PokemonIllustratedBookPageState();
}

class _PokemonIllustratedBookPageState extends State<PokemonIllustratedBookPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();
  SleepFaceRepository get _sleepFaceRepo => getIt();

  // UI
  late ThemeData _theme;

  // Data
  var _basicProfiles = <PokemonBasicProfile>[];
  var _sleepFacesOf = <int, Map<int, String>>{};
  PokemonBasicProfile? _currBasicProfile;

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

      _basicProfiles = await _basicProfileRepo.findAll();
      _sleepFacesOf = await _sleepFaceRepo.findAllNames();

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    final responsive = ResponsiveBreakpoints.of(context);

    final mainContent = Consumer<MainViewModel>(
      builder: (context, mainViewModel, child) {
        final profiles = mainViewModel.profiles;

        return buildListView(
          children: [
            ..._basicProfiles.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: Gap.xsV),
              child: _buildBasicProfile(e, isMobile: responsive.isMobile),
            )),
            Gap.trailing,
          ],
        );
      },
    );

    if (responsive.isMobile) {
      return Scaffold(
        appBar: buildAppBar(
          titleText: 't_pokemon_illustrated_book'.xTr,
        ),
        body: mainContent,
      );
    }

    final basicProfile = _currBasicProfile;
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_pokemon_illustrated_book'.xTr,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: COMMON_SIDE_WIDTH,
            child: mainContent,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: Divider.createBorderSide(context),
                ),
              ),
              child: basicProfile == null
                  ? Center(child: Text('選擇寶可夢'),)
                  : PokemonBasicProfilePage.buildView(basicProfile),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicProfile(PokemonBasicProfile basicProfile, {
    required bool isMobile,
  }) {
    return InkWell(
      onTap: () {
        if (isMobile) {
          PokemonBasicProfilePage.go(context, basicProfile);
        } else {
          setState(() {
            _currBasicProfile = basicProfile;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: _currBasicProfile?.id == basicProfile.id ? yellowColor : null,
        ),
        child: Row(
          children: [
            Opacity(
              opacity: _profileOf[basicProfile.id] != null ? 1 : 0,
              child: const Padding(
                padding: EdgeInsets.only(right: Gap.mdV),
                child: PokemonRecordedIcon(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '#${basicProfile.boxNo} ${basicProfile.nameI18nKey.xTr}  ',
                      style: _theme.textTheme.bodyLarge,
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: PokemonTypeIcon(
                              type: basicProfile.pokemonType,
                            ),
                          ),
                        ),
                      ],
                    ),
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


