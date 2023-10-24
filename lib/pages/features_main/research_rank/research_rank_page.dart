import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// TODO:
/// 1. 資料 https://wikiwiki.jp/poke_sleep/%E3%83%AA%E3%82%B5%E3%83%BC%E3%83%81%E3%83%A9%E3%83%B3%E3%82%AF
/// 2. 結合套件 sticky_headers 和 [MultiplicationTable]
class ResearchRankPage extends StatefulWidget {
  const ResearchRankPage._();

  static const MyPageRoute route = ('/ResearchRankPage', _builder);
  static Widget _builder(dynamic args) {
    return const ResearchRankPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<ResearchRankPage> createState() => _ResearchRankPageState();
}

class _ResearchRankPageState extends State<ResearchRankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
    );
  }
}


