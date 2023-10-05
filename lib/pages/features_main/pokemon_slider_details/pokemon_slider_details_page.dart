import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator/exp_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

/// TODO: 刪除功能、使用道具
class _PokemonSliderDetailsPageArgs {
  _PokemonSliderDetailsPageArgs({
    this.initialProfileId,
  });

  final int? initialProfileId;
}

class PokemonSliderDetailsPage extends StatefulWidget {
  const PokemonSliderDetailsPage._({
    required _PokemonSliderDetailsPageArgs args,
  }) : _args = args;

  static MyPageRoute<void> route = ('/PokemonSliderDetailsPage', (dynamic args) => PokemonSliderDetailsPage._(
    args: args as _PokemonSliderDetailsPageArgs,
  ));

  static void go(BuildContext context, {
    int? initialProfileId,
  }) {
    context.nav.push(
      PokemonSliderDetailsPage.route,
      arguments: _PokemonSliderDetailsPageArgs(
        initialProfileId: initialProfileId,
      ),
    );
  }

  final _PokemonSliderDetailsPageArgs _args;

  @override
  State<PokemonSliderDetailsPage> createState() => _PokemonSliderDetailsPageState();
}

class _PokemonSliderDetailsPageState extends State<PokemonSliderDetailsPage> {
  _PokemonSliderDetailsPageArgs get _args => widget._args;

  late PageController _pageController;

  final _cache = ListQueue<PokemonProfileStatistics>(5);
  var _previousPage = 0;
  var _currIndex = 0;

  // List
  var _lastOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _scrollController.addListener(() {
    //   _lastOffset = _scrollController.offset;
    // });
    // _scrollController2.addListener(() {
    //   _lastOffset = _scrollController2.offset;
    // });

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();
      await mainViewModel.loadProfiles();

      if (_args.initialProfileId != null) {
        final profiles = mainViewModel.profiles;
        final index = profiles.indexOrNullWhere((e) => e.id == _args.initialProfileId);

        if (index != null) {
          _previousPage = index;
          _pageController.jumpToPage(index);
        }

        _currIndex = index ?? 0;
        _loadData(index ?? 0, mainViewModel.profiles);
        if (mounted) {
          setState(() { });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        final profiles = viewModel.profiles;
        _currIndex = _currIndex.clamp(0, profiles.lastIndex ?? 0);

        if (profiles.isEmpty) {
          return Scaffold(
            appBar: buildAppBar(),
            body: Center(
              child: Text('t_none'.xTr),
            ),
          );
        }

        return Scaffold(
          appBar: buildAppBar(
            titleText: profiles[_currIndex].basicProfile.nameI18nKey.xTr,
            actions: [
              IconButton(
                onPressed: () {
                  PokemonMaintainProfilePage.goEdit(context, profiles[_currIndex]);
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (page) => _onPageChanged(page, profiles),
            children: profiles.mapIndexed((profileIndex, profile) => _PokemonDetailsView(
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
            )).toList(),
          ),
        );
      }
    );
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
  });

  final PokemonProfile profile;
  final PokemonProfileStatistics? statistics;
  final Function() onDeletedSuccess;
  final double initialOffset;
  final ValueChanged<double> onScroll;

  @override
  State<_PokemonDetailsView> createState() => _PokemonDetailsViewState();
}

class _PokemonDetailsViewState extends State<_PokemonDetailsView> {
  PokemonBasicProfile get basicProfile => widget.profile.basicProfile;

  late ScrollController _scrollController;

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
    return buildListView(
      controller: _scrollController,
      children: _buildListItems(context, widget.statistics),
    );
  }

  List<Widget> _buildListItems(BuildContext context, PokemonProfileStatistics? statistics) {
    final screenSize = MediaQuery.of(context).size;
    final leadingWidth = math.min(screenSize.width * 0.3, 150.0);

    Widget buildWithLabel({
      required String text,
      required Widget child,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

    return [
      Gap.xl,
      ...Hp.list(
        children: [
          MyElevatedButton(
            onPressed: () {
              /// TODO: 如果是「班基拉斯、沙基拉斯、又基拉斯」要將 _isLarvitar 設為 true
              ExpCalculatorPage.go(context);
            },
            child: const Text('提升等級'),
          ),
          Gap.xl,
          MySubHeader(
            titleText: 't_review'.xTr,
          ),
          Gap.xl,
          if (statistics == null)
            Text('t_none'.xTr)
          else ...[
            Text('能量積分: ${statistics.energyScore}\n'
                '總評價: ${statistics.rank}'),
          ],
          Gap.xl,
          MySubHeader(
            titleText: 't_help_ability'.xTr,
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_fruit'.xTr,
            child: Text(
              basicProfile.fruit.nameI18nKey.xTr,
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_ingredients'.xTr,
            child: Text(
              '${basicProfile.ingredient1.nameI18nKey} x${basicProfile.ingredientCount1}\n'
                  '${widget.profile.ingredient2.nameI18nKey} x${widget.profile.ingredientCount2}\n'
                  '${widget.profile.ingredient3.nameI18nKey} x${widget.profile.ingredientCount3}\n',
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: '幫忙間隔'.xTr,
            child: Text(
              '${basicProfile.helpInterval}\n',
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: '持有上限'.xTr,
            child: Text(
              '${widget.profile.basicProfile.maxCarry} 個\n', // TODO:
            ),
          ),
          Gap.xl,
          MySubHeader(
            titleText: '${'t_main_skill'.xTr}${'t_slash'.xTr}${'t_sub_skills'.xTr}',
          ),
          Gap.xl,
          Text(
            widget.profile.basicProfile.mainSkill.nameI18nKey.xTr,
          ),
          Gap.xl,
          Text(
              widget.profile.subSkills.mapIndexed((index, subSkill) => 'Lv. ${SubSkill.levelList[index]} ${subSkill.nameI18nKey.xTr}').join('\n')
          ),
          MySubHeader(
            titleText: 't_analysis'.xTr,
          ),
          Gap.xl,
          if (statistics == null)
            Center(child: Text('t_none'.xTr),)
          else ...[


            Text(
                '幫忙均能/次: ${statistics.helpPerAvgEnergy.toStringAsFixed(2)}\n'
                    '數量: ${statistics.fruitCount}\n'
                    '幫忙間隔: ${statistics.helpInterval}\n'
                    '樹果能量: ${statistics.fruitEnergy}\n'
                    '食材1能量: ${statistics.ingredientEnergy1}\n'
                    '食材2能量: ${statistics.ingredientEnergy2}\n'
                    '食材3能量: ${statistics.ingredientEnergy3}\n'
                    '食材均能: ${statistics.ingredientEnergyAvg}\n'
                    '幫手獎勵: ${statistics.helperBonus}\n'
                    '食材機率: ${statistics.ingredientRate}\n'
                    '技能等級: ${statistics.skillLevel}\n'
                    '主技能速度參數: ${statistics.mainSkillSpeedParameter}\n'
                    '持有上限溢出數: ${statistics.maxOverflowHoldCount}\n'
                    '持有上限溢出能量: ${statistics.overflowHoldEnergy}\n'
                    '性格速度: ${statistics.characterSpeed}\n'
                    '活力加速: ${statistics.accelerateVitality}\n'
                    '睡眠EXP獎勵: ${statistics.sleepExpBonus}\n'
                    '夢之碎片獎勵: ${statistics.dreamChipsBonus}\n'
                    '主技能能量: ${statistics.mainSkillTotalEnergy}\n'
                    '主技活力加速: ${statistics.mainSkillAccelerateVitality}\n',
            ),
            Text(
              '總幫忙速度加成: S(${statistics.totalHelpSpeedS}), M(${statistics.totalHelpSpeedM})',
            ),
          ],
          MySubHeader(
            titleText: 't_others'.xTr,
            color: dangerColor,
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





