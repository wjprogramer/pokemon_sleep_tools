import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class DevNewRankingPage extends StatefulWidget {
  const DevNewRankingPage._();

  static const MyPageRoute route = ('/DevNewRankingPage', _builder);
  static Widget _builder(dynamic args) {
    return const DevNewRankingPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DevNewRankingPage> createState() => _DevNewRankingPageState();
}

class _DevNewRankingPageState extends State<DevNewRankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
    );
  }
}


