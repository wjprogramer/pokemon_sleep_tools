import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class _PageArgs {

}

class SleepFacePage extends StatefulWidget {
  const SleepFacePage._(this._args);

  static const MyPageRoute route = ('/SleepFacePage', _builder);
  static Widget _builder(dynamic args) {
    return SleepFacePage._(args);
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  final _PageArgs _args;

  @override
  State<SleepFacePage> createState() => _SleepFacePageState();
}

class _SleepFacePageState extends State<SleepFacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
    );
  }
}


