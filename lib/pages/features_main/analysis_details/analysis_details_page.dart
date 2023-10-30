import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/search_list_tile.dart';
import 'package:provider/provider.dart';

class _Args {
  _Args(this.profileId);

  final int profileId;
}

/// 詳細計算過程、驗算用
class AnalysisDetailsPage extends StatefulWidget {
  const AnalysisDetailsPage._(this._args);

  static const MyPageRoute route = ('/AnalysisDetailsPage', _builder);
  static Widget _builder(dynamic args) {
    return AnalysisDetailsPage._(args);
  }

  // @deprecated
  // static void go(BuildContext context, int profileId) {
  //   context.nav.push(
  //     route,
  //     arguments: _Args(profileId),
  //   );
  // }

  final _Args _args;

  @override
  State<AnalysisDetailsPage> createState() => _AnalysisDetailsPageState();
}

class _AnalysisDetailsPageState extends State<AnalysisDetailsPage> {
  MainViewModel get _mainViewModel => context.read<MainViewModel>();

  _Args get _args => widget._args;
  int get _profileId => _args.profileId;

  // UI
  var _multipleColumn = false;
  // var _commentTextStyle = const TextStyle();

  // Page
  final _disposers = <MyDisposable>[];
  var _isInitialized = false;

  // Data
  PokemonProfile? _profile;
  // PokemonProfileStatistics? _statistics;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      final mainViewModel = _mainViewModel;
      final profiles = await mainViewModel.loadProfiles();
      _profile = profiles.firstWhereOrNull((e) => e.id == _profileId);

      if (_profile != null) {
        _startAnalysis(_profile!);
      }

      _disposers.addAll([
        mainViewModel.xAddListener(_listenMainViewModel),
      ]);

      _isInitialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  void _listenMainViewModel() {
    final profile = _mainViewModel.profiles.firstWhereOrNull((e) => e.id == _profileId);
    _isInitialized = false;
    _profile = profile;

    if (profile == null) {
      // _statistics = null;
      setState(() { });
      return;
    }

    _startAnalysis(profile);
  }

  void _startAnalysis(PokemonProfile profile) {
    scheduleMicrotask(() {
      // _statistics = PokemonProfileStatistics.from(profile)
      //   ..init();

      _isInitialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const LoadingView();
    }

    final screenSize = context.mediaQuery.size;
    _multipleColumn = screenSize.width >= COMMON_SIDE_WIDTH * 2;
    // final profile = _profile;
    // final statistics = _statistics;

    // if (profile == null || statistics == null) {
    //   // TODO: Error handling
    //   return const Scaffold();
    // }

    // _commentTextStyle = TextStyle(color: greyColor3);

    final appBar = buildAppBar(
      titleText: '詳細計算過程'.xTr,
    );

    if (_multipleColumn) {
      return Scaffold(
        appBar: appBar,
        body: const SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: _buildLeftItems(statistics, profile),
              //   ),
              // ),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: _buildRightItems(statistics, profile),
              //   ),
              // ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: buildListView(
        children: [
          // ..._fruitItems(statistics),
          // ..._ingredientsItems(statistics, profile),
          // ...Hp.list(
          //   children: [
          //     ..._skillItems(statistics, profile),
          //     ..._maxHoldItems(statistics, profile),
          //     ..._dreamChipsItems(statistics, profile),
          //     ..._sleepExpItems(statistics, profile),
          //     ..._helpItems(statistics, profile),
          //   ],
          // ),
          ..._dataSourceItems(),
          Gap.trailing,
        ],
      ),
    );
  }

  List<Widget> _dataSourceItems() {
    return [
      const Hp(
        child: MySubHeader(
          titleText: '資料來源',
          color: dataSourceSubHeaderColor,
        ),
      ),
      ...ListTile.divideTiles(
        context: context,
        tiles: [
          const SearchListTile(
            titleText: '【攻略】使用能量計算!!更科學的『寶可夢Sleep潛力計算機v4.0』五段評價系統!!',
            url: 'https://forum.gamer.com.tw/C.php?bsn=36685&snA=913',
            subTitleText: '主要參考計算方式',
          ),
        ],
      ),
    ];
  }

  // List<Widget> _buildLeftItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   return [
  //     ..._fruitItems(statistics),
  //     ..._ingredientsItems(statistics, profile),
  //     ...Hp.list(
  //       children: [
  //         ..._skillItems(statistics, profile),
  //         ..._helpItems(statistics, profile),
  //       ],
  //     ),
  //     Gap.trailing,
  //   ];
  // }
  //
  // List<Widget> _buildRightItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   return [
  //     ...Hp.list(
  //       children: [
  //         ..._vitalityItems(statistics, profile),
  //         ..._dreamChipsItems(statistics, profile),
  //         ..._sleepExpItems(statistics, profile),
  //         ..._maxHoldItems(statistics, profile),
  //       ],
  //     ),
  //     ..._dataSourceItems(),
  //     Gap.trailing,
  //   ];
  // }

  // List<Widget> _fruitItems(PokemonProfileStatistics statistics) {
  //   return Hp.list(
  //     children: [
  //       // LicenseSourceCard.t2(),
  //       MySubHeader(titleText: '樹果'),
  //       MySubHeader2(titleText: '樹果總數量'),
  //       _commonTable(
  //         [
  //           [
  //             _text(''),
  //             _text(''),
  //             _text('基礎值'),
  //             _text(''),
  //             _text(
  //               '「${SubSkill.berryCountS.nameI18nKey.xTr}」\n技能數量',
  //               tooltip: SubSkill.berryCountS.intro,
  //             ),
  //             _text(''),
  //             _text(
  //               '「${PokemonSpecialty.t3.nameI18nKey.xTr}」\n專長',
  //               // tooltip: '' // TODO: 補充資訊
  //             ),
  //           ],
  //           [
  //             _text('${statistics.fruitCount}'),
  //             _text('='),
  //             _text('1'),
  //             _text('+'),
  //             _text('${statistics.getSubSkillsCountMatch(SubSkill.berryCountS)}'),
  //             _text('+'),
  //             _text('${statistics.getOneIfSpecialtyIs(PokemonSpecialty.t3)}'),
  //           ],
  //         ],
  //       ),
  //       MySubHeader2(titleText: '樹果總能量'),
  //       _commonTable(
  //         [
  //           [
  //             _text(''),
  //             _text(''),
  //             _text('基礎值'),
  //             _text(''),
  //             _text(
  //               '「${SubSkill.berryCountS.nameI18nKey.xTr}」\n技能數量',
  //               tooltip: SubSkill.berryCountS.intro, // TODO: 補充資訊
  //             ),
  //           ],
  //           [
  //             _text('${statistics.fruitEnergy}'),
  //             _text('='),
  //             _text('${statistics.fruitCount}'),
  //             _text('x'),
  //             _text('${statistics.basicProfile.fruit.energyIn60}'),
  //           ],
  //         ],
  //       ),
  //     ],
  //   ).toList();
  // }
  //
  // List<Widget> _helpIntervalItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   final x = statistics.helperBonus +
  //       statistics.totalHelpSpeedM +
  //       statistics.totalHelpSpeedS +
  //       statistics.characterSpeed +
  //       statistics.accelerateVitality +
  //       statistics.mainSkillAccelerateVitality;
  //   final y = 1 - (x + 59 * 0.002);
  //
  //   return [
  //     MySubHeader2(titleText: '幫忙間隔'),
  //     Text(
  //       '這計算結果有時候會變成0導致後續出錯，需研究原因（目前先暫時讓結果為 0 的時候，強制轉為 1）',
  //       style: _commentTextStyle,
  //     ),
  //     // _text(Display.numDouble(statistics.helpInterval)),
  //     _commonTable([
  //       [
  //         _text('x'),
  //         _text(''),
  //         _text('幫手獎勵'),
  //         _text(''),
  //         _text(
  //           '${SubSkill.helpSpeedM.nameI18nKey.xTr}\n總加成',
  //           tooltip: '(副技能) ${SubSkill.helpSpeedM.intro}',
  //         ),
  //         _text(''),
  //         _text(
  //           '${SubSkill.helpSpeedS.nameI18nKey.xTr}\n總加成',
  //           tooltip: '(副技能) ${SubSkill.helpSpeedS.intro}',
  //         ),
  //         _text(''),
  //         _text('性格速度'),
  //         _text(''),
  //         _text('活力加速'),
  //         _text(''),
  //         _text('主技活力加速'),
  //       ],
  //       [
  //         _text(Display.numDouble(x)),
  //         _text('='),
  //         _text(Display.numDouble(statistics.helperBonus)),
  //         _text('+'),
  //         _text(Display.numDouble(statistics.totalHelpSpeedM)),
  //         _text('+'),
  //         _text(Display.numDouble(statistics.totalHelpSpeedS)),
  //         _text('+'),
  //         _text(Display.numDouble(statistics.characterSpeed)),
  //         _text('+'),
  //         _text(Display.numDouble(statistics.accelerateVitality)),
  //         _text('+'),
  //         _text(Display.numDouble(statistics.mainSkillAccelerateVitality)),
  //       ],
  //     ]),
  //     _commonTable([
  //       [
  //         _text('y'),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text('x'),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //       ],
  //       [
  //         _text(Display.numDouble(y)),
  //         _text('='),
  //         _text('1'),
  //         _text('-'),
  //         _text('(${Display.numDouble(x)}'),
  //         _text('+'),
  //         _text('59'),
  //         _text('x'),
  //         _text('0.002)'),
  //       ],
  //     ]),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text('加成前幫忙間隔'),
  //         _text(''),
  //         _text('y'),
  //       ],
  //       [
  //         _text(Display.numDouble(statistics.helpInterval)),
  //         _text('='),
  //         _text('${profile.basicProfile.maxHelpInterval}'),
  //         _text('x'),
  //         _text(Display.numDouble(y)),
  //       ],
  //     ]),
  //   ];
  // }
  //
  // List<Widget> _helpItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   return [
  //     MySubHeader(
  //       titleText: '幫忙',
  //     ),
  //     MySubHeader2(titleText: '幫忙速度'),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(
  //           '${SubSkill.helpSpeedM.nameI18nKey.xTr}\n數量',
  //           tooltip: SubSkill.helpSpeedM.intro,
  //         ),
  //         _text(''),
  //         _text(
  //           '${SubSkill.helpSpeedS.nameI18nKey.xTr}\n數量',
  //           tooltip: SubSkill.helpSpeedS.intro,
  //         ),
  //       ],
  //       [
  //         _text(Display.numDouble(statistics.totalHelpSpeedM + statistics.totalHelpSpeedS)),
  //         _text('='),
  //         _text('0.14x${Display.numDouble(statistics.totalHelpSpeedM)}'),
  //         _text('+'),
  //         _text('0.07x${Display.numDouble(statistics.totalHelpSpeedS)}'),
  //       ],
  //     ]),
  //     MySubHeader2(titleText: '幫手獎勵'),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(
  //           '「${SubSkill.helperBonus.nameI18nKey.xTr}」\n副技能數量',
  //           tooltip: SubSkill.helperBonus.intro,
  //         ),
  //       ],
  //       [
  //         _text(Display.numDouble(statistics.helperBonus)),
  //         _text('='),
  //         _text('15'),
  //         _text('x'),
  //         _text(Display.numInt(statistics.getSubSkillsCountMatch(SubSkill.helperBonus))),
  //       ],
  //     ]),
  //     MySubHeader2(titleText: '幫忙均能'),
  //     Text('等同食材均能', style: _commentTextStyle,),
  //     _commonTable([
  //       [
  //         _text(Display.numDouble(statistics.ingredientEnergyAvg)),
  //       ],
  //     ]),
  //     MySubHeader2(titleText: '性格速度'),
  //     Text(
  //       '性格對幫忙速度影響',
  //       style: _commentTextStyle,
  //     ),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(
  //           '「幫忙速度」\n性格特色',
  //         ),
  //       ],
  //       [
  //         _text(Display.numDouble(statistics.characterSpeed)),
  //         _text('='),
  //         _text('0.1'),
  //         _text('x'),
  //         _text(Display.numInt(
  //             statistics.getOneIf(statistics.character.positive == '幫忙速度')
  //                 - statistics.getOneIf(statistics.character.negative == '幫忙速度')
  //         )),
  //       ]
  //     ]),
  //     ..._helpIntervalItems(statistics, profile),
  //   ];
  // }
  //
  // List<Widget> _sleepExpItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   return [
  //     MySubHeader(
  //       titleText: '睡眠EXP',
  //     ),
  //     MySubHeader2(titleText: '睡眠EXP獎勵'),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(
  //           SubSkill.sleepExpBonus.nameI18nKey.xTr,
  //           tooltip: SubSkill.sleepExpBonus.intro,
  //         ),
  //       ],
  //       [
  //         _text(Display.numInt(statistics.sleepExpBonus)),
  //         _text('='),
  //         _text('1000'),
  //         _text('x'),
  //         _text('${statistics.getSubSkillsCountMatch(SubSkill.sleepExpBonus)}'),
  //       ],
  //     ]),
  //   ];
  // }
  //
  // List<Widget> _dreamChipsItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   return [
  //     MySubHeader(
  //       titleText: '夢之碎片',
  //     ),
  //     MySubHeader2(titleText: '夢之碎片獎勵'),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text(
  //           '${SubSkill.dreamChipBonus.nameI18nKey.xTr}\n數量',
  //           tooltip: SubSkill.dreamChipBonus.intro,
  //         ),
  //       ],
  //       [
  //         _text(Display.numInt(statistics.dreamChipsBonus)),
  //         _text('='),
  //         _text('500'),
  //         _text('x'),
  //         _text('${statistics.getSubSkillsCountMatch(SubSkill.dreamChipBonus)}'),
  //       ],
  //     ]),
  //   ];
  // }
  //
  // List<Widget> _vitalityItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   return [
  //     MySubHeader(
  //       titleText: '活力',
  //     ),
  //     MySubHeader2(titleText: '活力加速'),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(
  //           SubSkill.energyRecoverBonus.nameI18nKey.xTr,
  //           tooltip: SubSkill.energyRecoverBonus.intro,
  //         ),
  //         _text(''),
  //         _text('性格影響'),
  //       ],
  //       [
  //         _text(Display.numInt(statistics.accelerateVitality)),
  //         _text('='),
  //         _text('0.02 x ${Display.numInt(statistics.getSubSkillsCountMatch(SubSkill.energyRecoverBonus))}'),
  //         _text('+'),
  //         _text('0.1 x ${Display.numDouble((statistics.getOneIf(statistics.character.positive == '活力回復') - statistics.getOneIf(statistics.character.negative == '活力回復')))}'),
  //       ],
  //     ]),
  //   ];
  // }
  //
  // List<Widget> _maxHoldItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   final a1 = (statistics.ingredientCount1 + statistics.ingredientCount2 + statistics.ingredientCount3) * statistics.ingredientRate / 3;
  //   final a2 = (5 - statistics.ingredientRate) * statistics.fruitCount;
  //
  //   return [
  //     MySubHeader(
  //       titleText: '持有上限',
  //     ),
  //     MySubHeader2(titleText: '持有上限溢出數'),
  //     _commonTable([
  //       [
  //         _text('x'),
  //         _text(''),
  //         _text('食材1~3\n數量'),
  //         _text(''),
  //         _text('食材機率'),
  //         _text(''),
  //         _text(''),
  //       ],
  //       [
  //         _text(Display.numDouble(a1)),
  //         _text('='),
  //         _text('(${statistics.ingredientCount1}+${statistics.ingredientCount2}+${statistics.ingredientCount3})'),
  //         _text('x'),
  //         _text('${statistics.ingredientRate}'),
  //         _text('/'),
  //         _text('3'),
  //       ],
  //     ]),
  //     _commonTable([
  //       [
  //         _text('y'),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text('食材機率'),
  //         _text(''),
  //         _text('樹果數量'),
  //       ],
  //       [
  //         _text(Display.numDouble(a2)),
  //         _text('='),
  //         _text('(5'),
  //         _text('-'),
  //         _text('${statistics.ingredientRate})'),
  //         _text('x'),
  //         _text('${statistics.fruitCount}'),
  //       ],
  //     ]),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text('x'),
  //         _text(''),
  //         _text('y'),
  //         _text(''),
  //         _text(''),
  //         _text(''),
  //         _text('幫忙間隔'),
  //         _text(''),
  //         _text(
  //           '格子數',
  //         ),
  //         _text(''),
  //         _text(
  //           SubSkill.holdMaxS.nameI18nKey.xTr,
  //           tooltip: SubSkill.holdMaxS.intro,
  //         ),
  //         _text(''),
  //         _text(
  //           SubSkill.holdMaxM.nameI18nKey.xTr,
  //           tooltip: SubSkill.holdMaxM.intro,
  //         ),
  //         _text(''),
  //         _text(
  //           SubSkill.holdMaxL.nameI18nKey.xTr,
  //           tooltip: SubSkill.holdMaxL.intro,
  //         ),
  //       ],
  //       [
  //         _text(Display.numDouble(statistics.maxOverflowHoldCount)),
  //         _text('='),
  //         _text('(${Display.numDouble(a1)}'),
  //         _text('+'),
  //         _text('${Display.numDouble(a2)})'),
  //         _text('x'),
  //         _text('(30600'),
  //         _text('/'),
  //         _text('${Display.numDouble(statistics.helpInterval)})'),
  //         _text('-'),
  //         _text(Display.numInt(statistics.basicProfile.boxCount)),
  //         _text('-'),
  //         _text('(6x${Display.numInt(statistics.getSubSkillsCountMatch(SubSkill.holdMaxS))})'),
  //         _text('-'),
  //         _text('(12x${Display.numInt(statistics.getSubSkillsCountMatch(SubSkill.holdMaxM))})'),
  //         _text('-'),
  //         _text('(18x${Display.numInt(statistics.getSubSkillsCountMatch(SubSkill.holdMaxL))})'),
  //       ],
  //     ]),
  //     MySubHeader2(titleText: '持有上限溢出能量'),
  //     _commonTable([
  //       [
  //         _text(Display.numInt(statistics.overflowHoldEnergy)),
  //       ]
  //     ]),
  //   ];
  // }
  //
  // List<Widget> _skillItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   final disableMainSkillEnergy = statistics.isMainSkillIn({
  //     MainSkill.vitalityFillS, MainSkill.vitalityS, MainSkill.vitalityAllS,
  //   });
  //   final mainSkillEnergy = statistics.getMainSkillEnergy();
  //
  //   return [
  //     MySubHeader(
  //       titleText: '技能',
  //     ),
  //     MySubHeader2(titleText: '額外提升等級',),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(
  //           '${SubSkill.skillLevelS.nameI18nKey.xTr}\n個數',
  //           tooltip: SubSkill.skillLevelS.intro,
  //         ),
  //         _text(''),
  //         _text(
  //           '${SubSkill.skillLevelM.nameI18nKey.xTr}\n個數',
  //           tooltip: SubSkill.skillLevelM.intro,
  //         ),
  //       ],
  //       [
  //         _text(Display.numInt(
  //           statistics.skillLevel,
  //         )),
  //         _text('='),
  //         _text(
  //           Display.numInt(statistics.getSubSkillsCountMatch(SubSkill.skillLevelS)),
  //         ),
  //         _text('+'),
  //         _text(
  //           Display.numInt(statistics.getSubSkillsCountMatch(SubSkill.skillLevelM)),
  //         ),
  //       ]
  //     ]),
  //     MySubHeader2(titleText: '主技能速度參數'),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(
  //           '性格影響\n(主技能)',
  //           // tooltip: '', // TODO:
  //         ),
  //         _text(''),
  //         _text(
  //           '${SubSkill.skillRateS.nameI18nKey.xTr}\n個數',
  //           tooltip: SubSkill.skillRateS.intro,
  //         ),
  //         _text(''),
  //         _text(
  //           '${SubSkill.skillRateM.nameI18nKey.xTr}\n個數',
  //           tooltip: SubSkill.skillRateS.intro,
  //         ),
  //       ],
  //       [
  //         _text(Display.numDouble(statistics.mainSkillSpeedParameter)),
  //         _text('='),
  //         _text(
  //           '(0.2x${Display.numDouble(
  //               statistics.getOneIf(statistics.character.positive == '主技能')
  //                   - statistics.getOneIf(statistics.character.negative == '主技能')
  //           )})',
  //         ),
  //         _text('+'),
  //         _text('(0.18x${statistics.getSubSkillsCountMatch(SubSkill.skillRateS)})'),
  //         _text('+'),
  //         _text('(0.36x${statistics.getSubSkillsCountMatch(SubSkill.skillRateM)})'),
  //       ],
  //     ]),
  //     MySubHeader2(titleText: '主技能能量 (加成後)'),
  //     Gap.sm,
  //     Row(
  //       children: [
  //         // Icon(
  //         //   disableMainSkillEnergy ? Icons.cancel : Icons.check_circle,
  //         //   color: disableMainSkillEnergy ? dangerColor : greenColor,
  //         // ),
  //         // Gap.sm,
  //         Expanded(
  //           child: Text.rich(
  //             TextSpan(
  //               text: '如果主技能是「${[MainSkill.vitalityFillS, MainSkill.vitalityS, MainSkill.vitalityAllS].map((mainSkill) => mainSkill.nameI18nKey.xTr).join('t_separator'.xTr)}」，',
  //               children: [
  //                 TextSpan(
  //                   text: '結果為 0',
  //                   style: TextStyle(
  //                     color: disableMainSkillEnergy ? darkDangerColor : null,
  //                     fontWeight: disableMainSkillEnergy ? FontWeight.bold : null,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             style: _commentTextStyle,
  //           ),
  //         ),
  //       ],
  //     ),
  //     Gap.xs,
  //     Text(
  //       '目前主技能: ${statistics.basicProfile.mainSkill.nameI18nKey.xTr}',
  //       style: _commentTextStyle,
  //     ),
  //     Gap.md,
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text('主技能\n能量'),
  //         _text(''),
  //         _text('基礎值'),
  //         _text(''),
  //         _text('主技能\n速度參數'),
  //       ],
  //       [
  //         _text(
  //           Display.numDouble(statistics.mainSkillTotalEnergy),
  //           style: TextStyle(
  //             color: disableMainSkillEnergy ? darkDangerColor : null,
  //             fontWeight: disableMainSkillEnergy ? FontWeight.bold : null,
  //           ),
  //         ),
  //         _text('='),
  //         _text(Display.numDouble(mainSkillEnergy)),
  //         _text('x'),
  //         _text('(1'),
  //         _text('+'),
  //         _text('${Display.numDouble(statistics.mainSkillSpeedParameter)})'),
  //       ],
  //     ]),
  //     MySubHeader2(titleText: '主技能活力加速'),
  //     Row(
  //       children: [
  //         // Icon(
  //         //   disableMainSkillEnergy ? Icons.cancel : Icons.check_circle,
  //         //   color: disableMainSkillEnergy ? dangerColor : greenColor,
  //         // ),
  //         // Gap.sm,
  //         Expanded(
  //           child: Text.rich(
  //             TextSpan(
  //               text: '如果主技能不是「${[MainSkill.vitalityFillS, MainSkill.vitalityS, MainSkill.vitalityAllS].map((mainSkill) => mainSkill.nameI18nKey.xTr).join('t_separator'.xTr)}」，',
  //               children: [
  //                 TextSpan(
  //                   text: '結果為 0',
  //                   style: TextStyle(
  //                     color: !disableMainSkillEnergy ? darkDangerColor : null,
  //                     fontWeight: !disableMainSkillEnergy ? FontWeight.bold : null,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             style: _commentTextStyle,
  //           ),
  //         ),
  //       ],
  //     ),
  //     Gap.xs,
  //     Text(
  //       '目前主技能: ${statistics.basicProfile.mainSkill.nameI18nKey.xTr}',
  //       style: _commentTextStyle,
  //     ),
  //     _commonTable([
  //       [
  //         _text(''),
  //         _text(''),
  //         _text(
  //           '自訂權重?',
  //           style: TextStyle(color: positiveColor),
  //         ),
  //         _text(''),
  //         _text('主技能\n能量'),
  //         _text(''),
  //         _text('基礎值'),
  //         _text(''),
  //         _text('主技能\n速度參數'),
  //       ],
  //       [
  //         _text(
  //           Display.numDouble(statistics.mainSkillAccelerateVitality),
  //           style: TextStyle(color: !disableMainSkillEnergy ? darkDangerColor : null),
  //         ),
  //         _text('='),
  //         _text('(0.015'),
  //         _text('x'),
  //         _text('${Display.numDouble(mainSkillEnergy)})'),
  //         _text('x'),
  //         _text('(1'),
  //         _text('+'),
  //         _text('${Display.numDouble(statistics.mainSkillSpeedParameter)})'),
  //       ],
  //     ]),
  //   ];
  // }
  //
  // List<Widget> _ingredientsItems(PokemonProfileStatistics statistics, PokemonProfile profile) {
  //   return Hp.list(
  //     children: [
  //       MySubHeader(titleText: '食材'),
  //       // ..._buildCalcSingleIngredientEnergy(
  //       //   number: 1,
  //       //   ingredient: statistics.ingredient1,
  //       //   count: statistics.ingredientCount1,
  //       //   resultFromStatistics: statistics.ingredientEnergy1,
  //       // ),
  //       // ..._buildCalcSingleIngredientEnergy(
  //       //   number: 2,
  //       //   ingredient: statistics.ingredient2,
  //       //   count: statistics.ingredientCount2,
  //       //   resultFromStatistics: statistics.ingredientEnergy2,
  //       // ),
  //       // ..._buildCalcSingleIngredientEnergy(
  //       //   number: 3,
  //       //   ingredient: statistics.ingredient3,
  //       //   count: statistics.ingredientCount3,
  //       //   resultFromStatistics: statistics.ingredientEnergy3,
  //       // ),
  //       MySubHeader2(titleText: '食材總能量'),
  //       Text(
  //         '食材能量 = 單一食材能量 x 數量',
  //         style: _commentTextStyle,
  //       ),
  //       _commonTable(
  //           [
  //             [
  //               _text(''),
  //               _text(''),
  //               _text('能量'),
  //               _text(''),
  //               _text('數量'),
  //               _text(''),
  //               _text('能量'),
  //               _text(''),
  //               _text('數量'),
  //               _text(''),
  //               _text('能量'),
  //               _text(''),
  //               _text('數量'),
  //             ],
  //             [
  //               _text(Display.numInt(statistics.ingredientEnergySum)),
  //               _text('='),
  //               _text(Display.numInt(profile.ingredient1.energy)),
  //               _text('x'),
  //               _text(Display.numInt(profile.ingredientCount1)),
  //               _text('+'),
  //               _text(Display.numInt(profile.ingredient2.energy)),
  //               _text('x'),
  //               _text(Display.numInt(profile.ingredientCount2)),
  //               _text('+'),
  //               _text(Display.numInt(profile.ingredient3.energy)),
  //               _text('x'),
  //               _text(Display.numInt(profile.ingredientCount3)),
  //             ],
  //             [
  //               _text(''),
  //               _text(''),
  //               _text('(${Display.numInt(statistics.ingredientEnergy1)})'),
  //               _text(''),
  //               _text(''),
  //               _text(''),
  //               _text('(${Display.numInt(statistics.ingredientEnergy2)})'),
  //               _text(''),
  //               _text(''),
  //               _text(''),
  //               _text('(${Display.numInt(statistics.ingredientEnergy3)})'),
  //               _text(''),
  //               _text(''),
  //             ]
  //           ]
  //       ),
  //       MySubHeader2(titleText: '食材均能'),
  //       _commonTable(
  //         [
  //           [
  //             _text(''),
  //             _text(''),
  //             _text('食材\n總能量'),
  //             _text(''),
  //             _text('食材\n1~3'),
  //           ],
  //           [
  //             _text(Display.numInt(statistics.ingredientEnergyAvg)),
  //             _text('='),
  //             _text(Display.numInt(statistics.ingredientEnergySum)),
  //             _text('/'),
  //             _text('3'),
  //           ],
  //         ],
  //       ),
  //       MySubHeader2(titleText: '食材機率'),
  //       _commonTable([
  //         [
  //           _text(''),
  //           _text(''),
  //           _text('基礎'),
  //           _text(''),
  //           _text(
  //             SubSkill.ingredientRateS.nameI18nKey.xTr,
  //             tooltip: SubSkill.ingredientRateS.intro,
  //           ),
  //           _text(''),
  //           _text(
  //             SubSkill.ingredientRateM.nameI18nKey.xTr,
  //             tooltip: SubSkill.ingredientRateM.intro,
  //           ),
  //           _text(''),
  //           _text('性格影響\n(食材發現)'),
  //         ],
  //         [
  //           _text(Display.numDouble(statistics.ingredientRate)),
  //           _text('='),
  //           _text('1'),
  //           _text('+'),
  //           _text(
  //             '(0.18*${statistics.getSubSkillsCountMatch(SubSkill.ingredientRateS)})',
  //             tooltip: '0.18 * 擁有「${SubSkill.ingredientRateS.nameI18nKey.xTr}」數量',
  //           ),
  //           _text('+'),
  //           _text(
  //             '(0.36*${statistics.getSubSkillsCountMatch(SubSkill.ingredientRateM)})',
  //             tooltip: '0.36 * 擁有「${SubSkill.ingredientRateM.nameI18nKey.xTr}」數量',
  //           ),
  //           _text('+'),
  //           _text(Display.numDouble(
  //             0.2 * (
  //                 statistics.getOneIf(profile.character.positive == '食材發現')
  //                     - statistics.getOneIf(profile.character.negative == '食材發現')
  //             ),
  //           )),
  //         ],
  //       ]),
  //     ],
  //   ).toList();
  // }
  //
  // Widget _commonTable(List<List<Widget>> cells) {
  //   if (cells.isEmpty) {
  //     return Container();
  //   }
  //
  //   DataRow buildRow(List<Widget> rowItems) {
  //     return DataRow(
  //       cells: rowItems.map((e) => DataCell(e)).toList(),
  //     );
  //   }
  //
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: DataTable(
  //       columnSpacing: 12,
  //       columns: cells.take(1)
  //           .expand((e) => e)
  //           .map((e) => DataColumn(label: e))
  //           .toList(),
  //       rows: cells.sublist(1)
  //           .map((e) => buildRow(e))
  //           .toList(),
  //     ),
  //   );
  // }
  //
  // /// common table text
  // Widget _text(String text, {
  //   String? tooltip,
  //   TextStyle? style,
  // }) {
  //   Widget result = Text(
  //     text,
  //     textAlign: TextAlign.center,
  //     style: style,
  //   );
  //
  //   if (tooltip != null) {
  //     result = Tooltip(
  //       message: tooltip,
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           result,
  //           Padding(
  //             padding: const EdgeInsets.only(left: 2),
  //             child: Icon(
  //               Icons.info_outline,
  //               size: 12,
  //               color: greyColor3,
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   return Center(
  //     child: result,
  //   );
  // }
  //
  // List<Widget> _buildCalcSingleIngredientEnergy({
  //   required int number,
  //   required Ingredient ingredient,
  //   required int count,
  //   required int resultFromStatistics,
  // }) {
  //   return [
  //     MySubHeader2(titleText: '食材$number能量'),
  //     _commonTable(
  //       [
  //         [
  //           _text(''),
  //           _text(''),
  //           _text('單一食材能量'),
  //           _text(''),
  //           _text('數量'),
  //         ],
  //         [
  //           _text(Display.numInt(resultFromStatistics)),
  //           _text('='),
  //           _text(Display.numInt(ingredient.energy)),
  //           _text('x'),
  //           _text(Display.numInt(count)),
  //         ],
  //       ]
  //     ),
  //   ];
  // }

}


