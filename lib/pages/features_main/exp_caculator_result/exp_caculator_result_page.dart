import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

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

  var _initialized = false;

  /// 精簡模式，顯示較少資料
  var _simpleMode = true;

  final _levels = [10, 25, 30, 50, 60, 75, 100];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      try {

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
    // if (!_initialized) {
    //   return const LoadingView();
    // }

    return Scaffold(
      appBar: buildAppBar(
        titleText: _titleText,
      ),
      body: buildListView(
        children: _buildListItems(context),
      ),
    );
  }

  List<Widget> _buildListItems(BuildContext context) {
    _levels;
    ;

    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('LV'),),
            DataColumn(label: Text('EXP')),
            DataColumn(label: Text('一般糖果')),
            DataColumn(label: Text('萬能糖果S')),
            DataColumn(label: Text('萬能糖果M')),
            DataColumn(label: Text('萬能糖果L')),
          ],
          rows: [
            ..._levels.map((level) {
              final totalExp = ExpSleepUtility.getAccumulateExp(level);
              final normalCandyNeedCount = (totalExp / 25.0).ceil();
              final candySCount = (normalCandyNeedCount / 3.0).ceil();
              final candyMCount = (normalCandyNeedCount / 20.0).ceil();
              final candyLCount = (normalCandyNeedCount / 100.0).ceil();

              return DataRow(
                cells: [
                  DataCell(Text(level.toString())),
                  DataCell(Text(totalExp.toString())),
                  DataCell(Text(Display.numInt(normalCandyNeedCount))),
                  DataCell(Text(Display.numInt(candySCount))),
                  DataCell(Text(Display.numInt(candyMCount))),
                  DataCell(Text(Display.numInt(candyLCount))),
                ],
              );
            }),
          ],
        ),
      ),
    ];
  }
}




