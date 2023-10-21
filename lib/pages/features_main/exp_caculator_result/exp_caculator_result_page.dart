import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class _ExpCalculatorResultPageArgs {
  _ExpCalculatorResultPageArgs({
    required this.isLarvitar,
    required this.currLevel,
    required this.character,
    required this.remainExpToNextLevel,
    required this.bagCandiesCount,
  });

  final bool isLarvitar;
  final int currLevel;
  final PokemonCharacter? character;
  final int remainExpToNextLevel;
  final int bagCandiesCount;
}

class ExpCalculatorResultPage extends StatefulWidget {
  const ExpCalculatorResultPage._(_ExpCalculatorResultPageArgs args): _args = args;

  static const MyPageRoute route = ('/ExpCalculatorResultPage', _builder);
  static Widget _builder(dynamic args) {
    return ExpCalculatorResultPage._(args);
  }

  static void go(BuildContext context, {
    required bool isLarvitar,
    required int currLevel,
    required PokemonCharacter? character,
    required int remainExpToNextLevel,
    required int bagCandiesCount,
  }) {
    context.nav.push(
      route,
      arguments: _ExpCalculatorResultPageArgs(
        isLarvitar: isLarvitar,
        currLevel: currLevel,
        character: character,
        remainExpToNextLevel: remainExpToNextLevel,
        bagCandiesCount: bagCandiesCount,
      ),
    );
  }

  final _ExpCalculatorResultPageArgs _args;

  @override
  State<ExpCalculatorResultPage> createState() => _ExpCalculatorResultPageState();
}

/// TODO: Error handling
class _ExpCalculatorResultPageState extends State<ExpCalculatorResultPage> {
  _ExpCalculatorResultPageArgs get _args => widget._args;

  String get _titleText => 't_exp_and_candies'.xTr;

  late ThemeData _theme;
  var _initialized = false;

  /// 精簡模式，顯示較少資料
  var _simpleMode = true;

  var _shortLevels = [10, 25, 30, 50, 60, 75, 100];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      try {
        int? lastNeedDeletedLevelIndex;
        for (int i = 0; i < _shortLevels.length; i++) {
          if (_args.currLevel >= _shortLevels[i]) {
            lastNeedDeletedLevelIndex = i;
          } else {
            break;
          }
        }
        if (lastNeedDeletedLevelIndex != null) {
          _shortLevels = _shortLevels.sublist(lastNeedDeletedLevelIndex + 1);
        }

      } catch (e) {
        // TODO:
      } finally {
        _initialized = true;
      }

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    if (!_initialized) {
      return const LoadingView();
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: _titleText,
      ),
      body: buildListView(
        children: _buildListItems(context),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<Widget> _buildListItems(BuildContext context) {
    final currLevelNeedExp = ExpSleepUtility.getNeedExp(_args.currLevel, isLarvitarAndParent: _args.isLarvitar);
    final currSingleLevelAccumulateExp = currLevelNeedExp - _args.remainExpToNextLevel;
    final character = _args.character;
    var candyExpEffect = 1.0;
    var candyExp = 25 * candyExpEffect;

    // TODO: 需詳細確認數字
    // https://pks.raenonx.cc/info/nature 顯示 1.18 and 0.82，
    // 但實際算，好像是用 1.2 and 0.8 ?
    if (character?.positive == 'EXP') {
      candyExpEffect = 1.2; // TODO: 1.18 or 1.2?
    } else if (character?.negative == 'EXP') {
      candyExpEffect = 0.8; // TODO: 0.82 or 0.8?
    }

    final currAccumulateExp = ExpSleepUtility.getAccumulateExp(_args.currLevel, isLarvitarAndParent: _args.isLarvitar) + currSingleLevelAccumulateExp;
    final levels = _getLevels();

    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('LV'),),
            DataColumn(label: Text('EXP')),
            DataColumn(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('一般糖果'),
                  Gap.sm,
                  Tooltip(
                    message: '每個寶可夢都有對應的糖果',
                    child: Icon(
                      Icons.info_outline,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
            DataColumn(label: _candy('S'), tooltip: '萬能糖果 S'),
            DataColumn(label: _candy('M'), tooltip: '萬能糖果 M'),
            DataColumn(label: _candy('L'), tooltip: '萬能糖果 L'),
          ],
          rows: [
            ...levels.map((level) {
              final totalExp = ExpSleepUtility.getAccumulateExp(level, isLarvitarAndParent: _args.isLarvitar) - currAccumulateExp;
              final normalCandyNeedCount = (totalExp / candyExp).ceil();
              final candySCount = (normalCandyNeedCount / 3.0).ceil();
              final candyMCount = (normalCandyNeedCount / 20.0).ceil();
              final candyLCount = (normalCandyNeedCount / 100.0).ceil();
              final bagCandiesCount = _args.bagCandiesCount;

              final values = [
                normalCandyNeedCount,
                candySCount,
                candyMCount,
                candyLCount,
              ];

              final enoughCount = bagCandiesCount >= normalCandyNeedCount;
              final highlightColor = _simpleMode ? false
                  : level % 10 == 0 ? true
                  : false;

              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      level.toString(),
                      style: TextStyle(
                        color: highlightColor ? positiveColor : null,
                        fontWeight: highlightColor ? FontWeight.bold : null,
                      ),
                    )
                  ),
                  DataCell(Text(Display.numInt(totalExp))),
                  ...values.map((e) => DataCell(
                    Row(
                      children: [
                        Text(
                          Display.numInt(e),
                          style: TextStyle(
                            color: enoughCount ? primaryColor : null,
                            fontWeight: enoughCount ? FontWeight.bold : null,
                          ),
                        ),
                        if (enoughCount)
                          Padding(
                            padding: const EdgeInsets.only(left: Gap.mdV),
                            child: Icon(Icons.check, color: primaryColor.withOpacity(.7)),
                          )
                      ],
                    ),
                  ))
                ],
              );
            }),
          ],
        ),
      ),
      Gap.trailing,
    ];
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: Divider.createBorderSide(context),
          )
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16,
        ),
        child: Row(
          children: [
            // 't_simple': '簡易',
            // 't_details': '詳細',
            MyElevatedButton(
              onPressed: () {
                _simpleMode = !_simpleMode;
                setState(() { });
              },
              child: Row(
                children: [
                  Builder(
                    builder: (context) {
                      final iconTheme = IconTheme.of(context);

                      return Iconify(
                        _simpleMode
                            ? AntDesign.fullscreen_exit_outlined
                            : AntDesign.fullscreen_outlined,
                        color: iconTheme.color,
                        size: 18,
                      );
                    }
                  ),
                  Gap.md,
                  Text(
                    _simpleMode ? 't_simple'.xTr : 't_details'.xTr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _getLevels() {
    if (_simpleMode) {
      return _shortLevels;
    }

    final start = (_args.currLevel + 1).clamp(1, 100);
    const end = MAX_POKEMON_LEVEL;
    final length = end - start + 1;

    return List.generate(length, (index) => start + index);
  }

  Widget _candy(String rank) {
    final text = '萬能糖果$rank';
    if (!MyEnv.USE_DEBUG_IMAGE) {
      return Text(text);
    }

    return Row(
      children: [
        Image.asset(
          AssetsPath.generic('candy'),
          width: 24,
        ),
        Gap.md,
        Text(rank),
      ],
    );
  }

}




