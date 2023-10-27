import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// 食材掉落率
/// https://forum.gamer.com.tw/C.php?bsn=36685&snA=1396&tnum=8
/// https://docs.google.com/spreadsheets/d/1JkV2QxGGFDBzUfDxfOhTD3hrJJzu9qCS4A6c_HicIDc/edit#gid=1070055809

class _Args {
  const _Args(this.profile);

  final PokemonProfile profile;
}

class DevPokemonStatics2Page extends StatefulWidget {
  const DevPokemonStatics2Page._(this._args);

  static const MyPageRoute route = ('/DevPokemonStatics2Page', _builder);
  static Widget _builder(dynamic args) {
    return DevPokemonStatics2Page._(args);
  }

  static void go(BuildContext context, PokemonProfile profile) {
    context.nav.push(
      route,
      arguments: _Args(profile),
    );
  }

  final _Args _args;

  @override
  State<DevPokemonStatics2Page> createState() => _DevPokemonStatics2PageState();
}

class _DevPokemonStatics2PageState extends State<DevPokemonStatics2Page> {
  PokemonProfile get _profile => widget._args.profile;
  late PokemonProfileStatistics2 _statistics2;
  var _statisticsResults = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _statistics2 = PokemonProfileStatistics2(_profile);

    scheduleMicrotask(() {
      _statisticsResults = _statistics2.calcForDev();

      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_statistics2.isInitialized) {
      return const LoadingView();
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: '計算'.xTr,
      ),
      body: buildListView(
        children: [
          ..._statisticsResults
              .map((e) => _buildItem(e))
              .whereNotNull()
              .expand((e) => e),
          Gap.trailing,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _statisticsResults = _statistics2.calcForDev();
          setState(() { });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<Widget>? _buildItem(dynamic value) {
    if (value is Map) {
      if (value['type'] == 'table') {
        final cells = value['cells'] as List;

        return [
          if (value['title'] != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 4,
              ),
              child: Hp(
                child: MySubHeader(titleText: value['title']),
              ),
            ),
          if (value['subtitle'] != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 4,
              ),
              child: Hp(
                child: MySubHeader2(titleText: value['subtitle']),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.hV,
            ),
            child: DataTable(
              columns: (cells[0] as List).map((cell) => DataColumn(
                label: Text(
                  cell,
                ),
              )).toList(),
              rows: cells.sublist(1).map((rowCells) => DataRow(
                cells: (rowCells as List).map((cell) => DataCell(Text(cell))).toList(),
              )).toList(),
            ),
          ),
        ];
      }
    }
    return null;
  }

}


