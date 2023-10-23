import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/app/app.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class ChangeLangPage extends StatefulWidget {
  const ChangeLangPage._();

  static const MyPageRoute route = ('/ChangeLangPage', _builder);
  static Widget _builder(dynamic args) {
    return const ChangeLangPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<ChangeLangPage> createState() => _ChangeLangPageState();
}

class _ChangeLangPageState extends State<ChangeLangPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
      body: ListView(
        children: [
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              ...SupportLang.values.map((lang) => ListTile(
                onTap: () {
                  MyApp.of(context).setLang(lang);
                },
                title: Text(lang.displayName),
              )),
            ],
          ),
        ],
      ),
    );
  }
}


