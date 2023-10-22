import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_illustrated_book/pokemon_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class _MapPageArgs {
  _MapPageArgs(this.field);

  final PokemonField field;
}

///
/// TODO:
/// 篩選：
/// 寶可夢屬性、樹果、專長、睡眠類型、食材 Lv1、食材 Lv30、食材 Lv60、進化階段、主技能
///
/// [PokemonIllustratedBookPage] 可以參考此頁面的資訊
///
/// 睡姿篩選:
/// 顯示資訊: 睡姿、專長、睡眠類型
///
/// TODO:
/// 可以做滑到哪、顯示目前區塊是哪個寶可夢 Rank
///
/// TODO: 新增適合樹果
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
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();
  SleepFaceRepository get _sleepFaceRepo => getIt();
  MainViewModel get _mainViewModel => context.read<MainViewModel>();

  PokemonField get _field => widget._args.field;

  // UI
  late ThemeData _theme;
  var _isMobile = true;

  // Page status
  var _initialized = false;

  // Data
  var _rewards = <SnorlaxReward>[];
  var _sleepFacesOfRank = <SnorlaxRank, List<SleepFace>>{};
  var _sleepNamesOf = <int, Map<int, String>>{};
  var _basicProfileOf = <int, PokemonBasicProfile>{};
  var _accumulatePokemonCountOf = <SnorlaxRank, int>{};

  /// 顯示或隱藏已收集到的睡姿
  var _isVisible = true;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _rewards = _field.getSnorlaxRewardList();
      var accumulatePokemonCount = 0;

      // Init empty sleep faces list
      for (var reward in _rewards) {
        _sleepFacesOfRank[reward.rank] = [];
      }

      // Find all sleep faces
      final sleepFaces = await _sleepFaceRepo.findAll();
      sleepFaces.removeWhere((sleepFace) => sleepFace.field != _field);
      for (var sleepFace in sleepFaces) {
        _sleepFacesOfRank[sleepFace.snorlaxRank]?.add(sleepFace);
      }

      // Calculate sleep faces size
      for (final reward in _rewards) {
        accumulatePokemonCount += _sleepFacesOfRank[reward.rank]?.length ?? 0;
        _accumulatePokemonCountOf[reward.rank] = accumulatePokemonCount;
      }

      // Others
      _basicProfileOf = await _basicProfileRepo.findAllMapping();
      _sleepNamesOf = await _sleepFaceRepo.findAllNames();

      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    final responsive = ResponsiveBreakpoints.of(context);
    _isMobile = responsive.isMobile;

    final rankSubTitleSize = context.textTheme.bodySmall?.fontSize ?? 16;
    final rankSubIconSize = rankSubTitleSize * 1.2;
    final mainContentWidth = context.mediaQuery.size.width - 2 * HORIZON_PADDING;
    final leadingWidth = math.min(mainContentWidth * 0.3, 150).toDouble();

    final pokemonTextStyle = _theme.textTheme.bodyMedium;

    if (!_initialized) {
      return LoadingView();
    }

    final rewards = _rewards.where((reward) => (_sleepFacesOfRank[reward.rank] ?? []).isNotEmpty);
    final pokemonLabelBorderRadius = BorderRadius.circular(8);

    return Scaffold(
      appBar: buildAppBar(
        titleText: _field.nameI18nKey.xTr,
      ),
      body: buildListView(
        children: [
          ...rewards.map((reward) => Container(
            margin: const EdgeInsets.only(
              bottom: Gap.mdV,
            ),
            padding: const EdgeInsets.only(
              bottom: Gap.mdV,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: Divider.createBorderSide(context),
              ),
            ),
            child: Hp(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isMobile) ...[
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: leadingWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              SnorlaxRankItem(
                                rank: reward.rank,
                              ),
                              const Spacer(),
                            ],
                          ),
                          Row(
                            children: [
                              EnergyIcon(
                                size: rankSubIconSize,
                              ),
                              Gap.xs,
                              Expanded(
                                child: Text(
                                  Display.numInt(reward.energy),
                                  style: TextStyle(fontSize: rankSubTitleSize),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              DreamChipIcon(
                                size: rankSubIconSize,
                              ),
                              Gap.xs,
                              Expanded(
                                child: Text(
                                  Display.numInt(reward.dreamChips),
                                  style: TextStyle(fontSize: rankSubTitleSize),
                                ),
                              ),
                            ],
                          ),
                          _accumulatePokemonForRank(reward, rankSubIconSize, rankSubTitleSize),
                          // _accumulatePokemonCountOf
                        ],
                      ),
                    ),
                    Gap.md,
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_isMobile)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Wrap(
                              spacing: 12,
                              children: [
                                SnorlaxRankItem(
                                  rank: reward.rank,
                                ),
                                _energyIcon(reward, rankSubIconSize, rankSubTitleSize),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DreamChipIcon(
                                      size: rankSubIconSize,
                                    ),
                                    Gap.xs,
                                    Text(
                                      Display.numInt(reward.dreamChips),
                                      style: TextStyle(fontSize: rankSubTitleSize),
                                    ),
                                  ],
                                ),
                                _accumulatePokemonForRank(reward, rankSubIconSize, rankSubTitleSize),
                              ],
                            ),
                          ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            ...?_sleepFacesOfRank[reward.rank]?.map((sleepFace) => _buildPokemon(
                              sleepFace,
                              pokemonLabelBorderRadius,
                              pokemonTextStyle,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
          Gap.trailing,
        ],
      ),
      // TODO:
      bottomNavigationBar: !kDebugMode ? null : BottomBarWithActions(
        onVisibleChanged: (visible) {
          setState(() {
            _isVisible = visible;
          });
        },
        isVisible: _isVisible,
      ),
    );
  }

  Widget _energyIcon(SnorlaxReward reward, double rankSubIconSize, double rankSubTitleSize) {
    Widget textWidget = Text(
      Display.numInt(reward.energy),
      style: TextStyle(fontSize: rankSubTitleSize),
    );

    if (!_isMobile) {
      textWidget = Expanded(child: textWidget);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        EnergyIcon(
          size: rankSubIconSize,
        ),
        Gap.xs,
        textWidget,
      ],
    );
  }

  Widget _accumulatePokemonForRank(SnorlaxReward reward, double rankSubIconSize, double rankSubTitleSize) {
    Widget textWidget = Text(
      '${_accumulatePokemonCountOf[reward.rank]} (+${Display.numInt(_sleepFacesOfRank[reward.rank]?.length ?? 0)})',
      style: TextStyle(fontSize: rankSubTitleSize),
    );

    if (!_isMobile) {
      textWidget = Expanded(child: textWidget);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: '此等級已累積發現寶可夢數量',
          child: Icon(
            Icons.catching_pokemon,
            color: color1,
            size: rankSubIconSize,
          ),
        ),
        Gap.xs,
        textWidget,
      ],
    );
  }

  Widget _buildPokemon(SleepFace sleepFace, BorderRadius pokemonLabelBorderRadius, TextStyle? pokemonTextStyle, ) {
    final basicProfile = _basicProfileOf[sleepFace.basicProfileId];

    if (MyEnv.USE_DEBUG_IMAGE && basicProfile != null) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: InkWell(
              onTap: () {
                PokemonBasicProfilePage.go(context, basicProfile);
              },
              child: PokemonIconBorderedImage(
                basicProfile: basicProfile,
                width: 40,
                height: 40,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 1
                ),
                decoration: BoxDecoration(
                  color: sleepFace.snorlaxRank.title.bgColor.withOpacity(.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${sleepFace.style == -1 ? '' : sleepFace.style}',
                      style: pokemonTextStyle?.copyWith(
                        fontSize: (pokemonTextStyle.fontSize ?? 14) * 0.6,
                        color: greyColor3,
                      ),
                    ),
                    if (sleepFace.style == -1)
                      Image.asset(
                        AssetsPath.generic('snorlax'),
                        width: 14,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: yellowLightColor,
        borderRadius: pokemonLabelBorderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final basicProfile = _basicProfileOf[sleepFace.basicProfileId];
            if (basicProfile == null) {
              return;
            }

            PokemonBasicProfilePage.go(context, basicProfile);
          },
          borderRadius: pokemonLabelBorderRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _basicProfileOf[sleepFace.basicProfileId]?.nameI18nKey.xTr ?? '',
                  style: pokemonTextStyle,
                ),
                Text(
                  '#${sleepFace.style == -1 ? '卡' : sleepFace.style}',
                  style: pokemonTextStyle?.copyWith(
                    fontSize: (pokemonTextStyle.fontSize ?? 14) * 0.8,
                    color: greyColor3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


