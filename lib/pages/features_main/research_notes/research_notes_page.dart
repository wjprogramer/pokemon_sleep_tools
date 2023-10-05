import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class ResearchNotesPage extends StatefulWidget {
  const ResearchNotesPage._();

  static const MyPageRoute route = ('/ResearchNotesPage', _builder);
  static Widget _builder(dynamic args) {
    return const ResearchNotesPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<ResearchNotesPage> createState() => _ResearchNotesPageState();
}

class _ResearchNotesPageState extends State<ResearchNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
    );
  }
}


