import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_calculator/exp_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruit/fruit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skill/main_skill_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:provider/provider.dart';

/// - TODO: 要注意 [_PokemonSliderDetailsPageArgs.isView] 後資料更新有沒有問題
/// - 遊戲內有 "使用道具" 的功能，但這邊應該不需要
class _PokemonSliderDetailsPageArgs {
  _PokemonSliderDetailsPageArgs({
    this.initialProfileId,
    this.initialProfileIds,
    this.isView = false,
  });

  final int? initialProfileId;

  /// [PokemonProfile.id]
  final List<int>? initialProfileIds;

  final bool isView;
}

class PokemonSliderDetailsPage extends StatefulWidget {
  const PokemonSliderDetailsPage._(this._args, {
    super.key,
  });

  static MyPageRoute<void> route = ('/PokemonSliderDetailsPage',
      (dynamic args) => PokemonSliderDetailsPage._(args));

  static void go(BuildContext context, {
    int? initialProfileId,
    List<int>? initialProfileIds,
  }) {
    context.nav.push(
      PokemonSliderDetailsPage.route,
      arguments: _PokemonSliderDetailsPageArgs(
        initialProfileId: initialProfileId,
        initialProfileIds: initialProfileIds,
      ),
    );
  }

  static Widget buildView({
    Key? key,
    int? profileId,
    List<int>? initialProfileIds,
  }) {
    return PokemonSliderDetailsPage._(
      _PokemonSliderDetailsPageArgs(
        initialProfileId: profileId,
        initialProfileIds: initialProfileIds,
        isView: true,
      ),
      key: key,
    );
  }

  final _PokemonSliderDetailsPageArgs _args;

  @override
  State<PokemonSliderDetailsPage> createState() => _PokemonSliderDetailsPageState();
}

class _PokemonSliderDetailsPageState extends State<PokemonSliderDetailsPage> {
  _PokemonSliderDetailsPageArgs get _args => widget._args;
  bool get _isView => _args.isView;

  late PageController _pageController;

  final _cache = ListQueue<PokemonProfileStatistics>(5);
  var _previousPage = 0;
  var _currIndex = 0;

  /// [PokemonProfile.id] to instance
  final _profileOf = <int, PokemonProfile>{};

  // Page status
  final _disposers = <MyDisposable>[];
  var _initialized = false;

  // List
  var _lastOffset = 0.0;
  var _profiles = <PokemonProfile>[];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      // Load
      final mainViewModel = context.read<MainViewModel>();
      await mainViewModel.loadProfiles();

      // Utils (with profiles)
      updateProfileMapping() {
        final newProfiles = mainViewModel.profiles;
        for (final profile in newProfiles) {
          _profileOf[profile.id] = profile;
        }
      }

      if (widget._args.initialProfileIds != null) {
        updateProfileMapping();

        _disposers.add(
          mainViewModel.xAddListener(() {
            updateProfileMapping();
          }),
        );
      }

      if (_args.initialProfileId != null) {
        int? index;
        if (widget._args.initialProfileIds != null) {
          _profiles = (widget._args.initialProfileIds ?? []).map((e) => _profileOf[e]).whereNotNull().toList();
          index = widget._args.initialProfileIds?.indexOrNullWhere((profileId) => profileId == _args.initialProfileId);
        } else {
          _profiles = mainViewModel.profiles;
          index = _profiles.indexOrNullWhere((e) => e.id == _args.initialProfileId);
        }

        _previousPage = index ?? _previousPage;
        _currIndex = index ?? 0;
        _loadData(index ?? 0, _profiles);
      }

      _pageController = PageController(initialPage: _currIndex);

      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  /// TODO: [initState] 的 load data 需要這裡使用？
  @override
  void didUpdateWidget(covariant PokemonSliderDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_args.isView && _args.initialProfileId != null) {
      final profileIndex = _profiles
          .indexOrNullWhere((p) => p.id == _args.initialProfileId);

      if (profileIndex != null && _pageController.hasClients) {
        _pageController.jumpToPage(profileIndex);
      }
    }
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const LoadingView();
    }

    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        final initialProfileIds = widget._args.initialProfileIds;
        if (initialProfileIds != null) {
          _profiles = initialProfileIds.map((e) => _profileOf[e]).whereNotNull().toList();
        } else {
          _profiles = viewModel.profiles;
        }

        _currIndex = _currIndex.clamp(0, _profiles.lastIndex ?? 0);
        _isView;

        if (_profiles.isEmpty) {
          return Scaffold(
            appBar: buildAppBar(),
            body: Center(
              child: Text('t_none'.xTr),
            ),
          );
        }

        Widget buildBody({ required Size viewSize}) {
          return PageView(
            controller: _pageController,
            onPageChanged: (page) => _onPageChanged(page, _profiles),
            children: _profiles.mapIndexed((profileIndex, profile) => _PokemonDetailsView(
              profile: profile,
              statistics: _getStatistics(profile),
              onDeletedSuccess: () {
                _currIndex -= 1;
              },
              initialOffset: _lastOffset,
              onScroll: (offset) {
                if (_currIndex != profileIndex) {
                  return;
                }

                _lastOffset = offset;
                setState(() { });
              },
              viewSize: viewSize,
            )).toList(),
          );
        }

        Widget body;

        if (_isView) {
          body = LayoutBuilder(
            builder: (context, constraints) {
              return buildBody(viewSize: Size(constraints.maxWidth, constraints.maxHeight));
            }
          );
        } else {
          body = buildBody(viewSize: context.mediaQuery.size);
        }

        if (_isView) {
          body = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: kToolbarHeight,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Gap.h,
                    Expanded(
                      child: _buildTitle(),
                    ),
                    ..._buildActions(),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          );
        }

        return Scaffold(
          appBar: _isView ? null : buildAppBar(
            title: _buildTitle(),
            actions: _buildActions(),
          ),
          body: body,
        );
      }
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (MyEnv.USE_DEBUG_IMAGE)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PokemonTypeImage(
              pokemonType: _profiles[_currIndex].basicProfile.pokemonType,
              width: 32,
            ),
          ),
        Expanded(child: Text(_profiles[_currIndex].basicProfile.nameI18nKey.xTr)),
      ],
    );
  }

  List<Widget> _buildActions() {
    return [
      IconButton(
        onPressed: () {
          PokemonMaintainProfilePage.goEdit(context, _profiles[_currIndex]);
        },
        icon: const Icon(Icons.edit),
      ),
    ];
  }

  void _onPageChanged(int page, List<PokemonProfile> profiles) {
    _currIndex = page;
    setState(() { });

    scheduleMicrotask(() {
      _loadData(page, profiles);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
  }

  Future<void> _loadData(int index, List<PokemonProfile> profiles) async {
    var delta = index - _previousPage;
    var preloadIndex = delta == 0 && profiles.length > 1 ? null : (
        (profiles.length + index + delta) % profiles.length
    );

    PokemonProfileStatistics? currentStatistics;
    PokemonProfileStatistics? preloadStatistics;

    for (final data in [..._cache]) {
      if (data.profile.id == profiles[index].id) {
        currentStatistics = data;
      } else if (preloadIndex != null &&
          data.profile.id == profiles[preloadIndex].id) {
        preloadStatistics = data;
      }

      if (currentStatistics != null && preloadStatistics != null) {
        break;
      }
    }

    _cache.removeWhere((statistics) {
      return statistics.profile.id == currentStatistics?.profile.id ||
          statistics.profile.id == preloadStatistics?.profile.id;
    });

    if (currentStatistics == null) {
      currentStatistics = PokemonProfileStatistics.from(profiles[index]);
      currentStatistics.init();
    }
    if (preloadIndex != null && preloadStatistics == null) {
      preloadStatistics = PokemonProfileStatistics.from(profiles[preloadIndex]);
      preloadStatistics.init();
    }

    _cache.add(currentStatistics);
    if (preloadStatistics != null) {
      _cache.add(preloadStatistics);
    }

    setState(() { });
  }

  PokemonProfileStatistics? _getStatistics(PokemonProfile profile) {
    return _cache.firstWhereOrNull((e) => e.profile.id == profile.id);
  }

}

class _PokemonDetailsView extends StatefulWidget {
  const _PokemonDetailsView({
    required this.profile,
    this.statistics,
    required this.onDeletedSuccess,
    required this.initialOffset,
    required this.onScroll,
    required this.viewSize,
  });

  final PokemonProfile profile;
  final PokemonProfileStatistics? statistics;
  final Function() onDeletedSuccess;
  final double initialOffset;
  final ValueChanged<double> onScroll;
  final Size viewSize;

  @override
  State<_PokemonDetailsView> createState() => _PokemonDetailsViewState();
}

class _PokemonDetailsViewState extends State<_PokemonDetailsView> {
  PokemonBasicProfile get basicProfile => widget.profile.basicProfile;
  PokemonProfile get _profile => widget.profile;

  late ScrollController _scrollController;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: widget.initialOffset)
      ..addListener(() {
        widget.onScroll(_scrollController.offset);
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;
    final leadingWidth = math.min(widget.viewSize.width * 0.3, 150.0);
    final mainWidth = widget.viewSize.width - 2 * HORIZON_PADDING;

    return buildListView(
      controller: _scrollController,
      children: _buildListItems(
        context,
        widget.statistics,
        leadingWidth: leadingWidth,
        mainWidth: mainWidth,
      ),
    );
  }

  List<Widget> _buildListItems(BuildContext context, PokemonProfileStatistics? statistics, {
    required double leadingWidth,
    required double mainWidth,
  }) {
    const subSkillItemSpacing = 24.0;
    const subSkillParentExtraMarginValue = 4.0;
    final subSkillWidth = (mainWidth - 2 * subSkillParentExtraMarginValue - subSkillItemSpacing) / 2;

    Widget image = Container();
    if (MyEnv.USE_DEBUG_IMAGE) {
      image = PokemonImage(
        height: 200,
        basicProfile: widget.profile.basicProfile,
        disableTooltip: true,
      );
    }
    // if (Platform.isAndroid) {
    //   image = Hero(
    //     tag: 'pokemon_image_${widget.profile.id}',
    //     child: image,
    //   );
    // }

    Widget buildWithLabel({
      required String text,
      required Widget child,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    }) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            constraints: BoxConstraints.tightFor(width: leadingWidth),
            child: MyLabel(
              text: text,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: MyLabel.verticalPaddingValue),
              child: child,
            ),
          ),
        ],
      );
    }

    Widget buildIngredientLevelLabel(int level) {
      return Stack(
        children: [
          Opacity(
            opacity: 0,
            child: Text('Lv 100'),
          ),
          Positioned.fill(
            child: Row(
              children: [
                Text('Lv'),
                Spacer(),
                Text('${level.clamp(1, 100)}'),
              ],
            ),
          ),
        ],
      );
    }

    return [
      Gap.xl,
      ...Hp.list(
        children: [
          if (MyEnv.USE_DEBUG_IMAGE)
            image,
          MyElevatedButton(
            onPressed: () {
              ExpCalculatorPage.go(
                context,
                isLarvitarChain: widget.profile.isLarvitarChain,
              );
            },
            child: const Text('提升等級'),
          ),
          Gap.xl,
          MySubHeader(
            titleText: 't_review'.xTr,
          ),
          Gap.xl,
          Text('能量積分: ${statistics?.energyScore}\n'
              '總評價: ${statistics?.rank}'),
          Gap.xl,
          MySubHeader(
            titleText: 't_help_ability'.xTr,
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_fruit'.xTr,
            crossAxisAlignment: CrossAxisAlignment.center,
            child: InkWell(
              onTap: () {
                FruitPage.go(context, basicProfile.fruit);
              },
              child: Row(
                children: [
                  if (MyEnv.USE_DEBUG_IMAGE)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: FruitImage(
                        fruit: basicProfile.fruit,
                        width: 24,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      basicProfile.fruit.nameI18nKey.xTr,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_ingredients'.xTr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    IngredientPage.go(context, basicProfile.ingredient1);
                  },
                  child: Row(
                    children: [
                      buildIngredientLevelLabel(1),
                      Gap.md,
                      if (MyEnv.USE_DEBUG_IMAGE)
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: IngredientImage(
                            ingredient: basicProfile.ingredient1,
                            width: 24,
                          ),
                        ),
                      Expanded(
                        child: Text(basicProfile.ingredient1.nameI18nKey.xTr),
                      ),
                      Text('x${basicProfile.ingredientCount1}'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    IngredientPage.go(context, widget.profile.ingredient2);
                  },
                  child: Row(
                    children: [
                      buildIngredientLevelLabel(30),
                      Gap.md,
                      if (MyEnv.USE_DEBUG_IMAGE)
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: IngredientImage(
                            ingredient: widget.profile.ingredient2,
                            width: 24,
                          ),
                        ),
                      Expanded(
                        child: Text(widget.profile.ingredient2.nameI18nKey.xTr),
                      ),
                      Text('x${widget.profile.ingredientCount2}'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    IngredientPage.go(context, widget.profile.ingredient3);
                  },
                  child: Row(
                    children: [
                      buildIngredientLevelLabel(60),
                      Gap.md,
                      if (MyEnv.USE_DEBUG_IMAGE)
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: IngredientImage(
                            ingredient: widget.profile.ingredient3,
                            width: 24,
                          ),
                        ),
                      Expanded(
                        child: Text(widget.profile.ingredient3.nameI18nKey.xTr),
                      ),
                      Text('x${widget.profile.ingredientCount3}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: '幫忙間隔'.xTr,
            child: Text(
              '${basicProfile.helpInterval} 秒',
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: '持有上限'.xTr,
            child: Text(
              '${widget.profile.basicProfile.maxCarry} 個\n',
            ),
          ),
          Gap.xl,
          MySubHeader(
            titleText: '${'t_main_skill'.xTr}${'t_slash'.xTr}${'t_sub_skills'.xTr}',
          ),
          Gap.xl,
          InkWell(
            onTap: () {
              MainSkillPage.go(context, widget.profile.basicProfile.mainSkill);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 24,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Text(
                widget.profile.basicProfile.mainSkill.nameI18nKey.xTr,
              ),
            ),
          ),
          const SizedBox(height: subSkillItemSpacing),
          // TODO: 副技能反查?
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: subSkillParentExtraMarginValue,
            ),
            child: Wrap(
              spacing: subSkillItemSpacing,
              runSpacing: subSkillItemSpacing,
              children: [
                ...widget.profile.subSkills.mapIndexed((subSkillIndex, subSkill) => Container(
                  constraints: BoxConstraints.tightFor(
                    width: subSkillWidth,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: subSkill.bgColor,
                            width: 2,
                          ),
                          color: subSkill.bgColor.withOpacity(.6),
                        ),
                        child: Center(
                          child: Text(subSkill.nameI18nKey.xTr),
                        ),
                      ),
                      Positioned(
                        left: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: subSkillLevelLabelColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 50,
                          ),
                          child: Text(
                            'Lv. ${SubSkill.levelList[subSkillIndex]}',
                            style: TextStyle(
                              fontSize: (_theme.textTheme.bodySmall?.fontSize ?? 16) * 0.7,
                              color: subSkillLevelLabelColor.fgColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          MySubHeader(
            titleText: 't_others'.xTr,
          ),
          Gap.xl,
          Text(
            _profile.character.nameI18nKey.xTr,
          ),
          Gap.md,
          MySubHeader(
            titleText: 't_analysis'.xTr,
          ),
          Gap.xl,
          ...[
            Text(
              '幫忙均能/次: ${statistics?.helpPerAvgEnergy.toStringAsFixed(2)}\n'
                  '數量: ${statistics?.fruitCount}\n'
                  '幫忙間隔: ${statistics?.helpInterval}\n'
                  '樹果能量: ${statistics?.fruitEnergy}\n'
                  '食材1能量: ${statistics?.ingredientEnergy1}\n'
                  '食材2能量: ${statistics?.ingredientEnergy2}\n'
                  '食材3能量: ${statistics?.ingredientEnergy3}\n'
                  '食材均能: ${statistics?.ingredientEnergyAvg}\n'
                  '幫手獎勵: ${statistics?.helperBonus}\n'
                  '食材機率: ${statistics?.ingredientRate}\n'
                  '技能等級: ${statistics?.skillLevel}\n'
                  '主技能速度參數: ${statistics?.mainSkillSpeedParameter}\n'
                  '持有上限溢出數: ${statistics?.maxOverflowHoldCount}\n'
                  '持有上限溢出能量: ${statistics?.overflowHoldEnergy}\n'
                  '性格速度: ${statistics?.characterSpeed}\n'
                  '活力加速: ${statistics?.accelerateVitality}\n'
                  '睡眠EXP獎勵: ${statistics?.sleepExpBonus}\n'
                  '夢之碎片獎勵: ${statistics?.dreamChipsBonus}\n'
                  '主技能能量: ${statistics?.mainSkillTotalEnergy}\n'
                  '主技活力加速: ${statistics?.mainSkillAccelerateVitality}\n',
            ),
            Text(
              '總幫忙速度加成: S(${statistics?.totalHelpSpeedS}), M(${statistics?.totalHelpSpeedM})',
            ),
          ],
          MySubHeader(
            titleText: 't_others'.xTr,
            color: dangerColor,
          ),
          MyElevatedButton(
            onPressed: () {
              PokemonBasicProfilePage.go(context, widget.profile.basicProfile);
            },
            child: Text(
              '查看圖鑑',
            ),
          ),
          MyElevatedButton(
            onPressed: () {
              // TODO: Loading, Error Handling
              DialogUtility.danger(
                context,
                confirmText: 't_delete'.xTr,
                title: Text('t_delete_pokemon'.xTr),
                content: Text(
                  't_delete_someone_hint'.xTrParams({
                    'someone': widget.profile.basicProfile.nameI18nKey.xTr,
                  }),
                ),
                onConfirm: () async {
                  await context.read<MainViewModel>().deleteProfile(widget.profile.id);
                  widget.onDeletedSuccess();
                },
              );
            },
            child: Text('t_delete'.xTr),
          ),
          Gap.xl,
        ],
      ),
      Gap.trailing,
    ];
  }
}





