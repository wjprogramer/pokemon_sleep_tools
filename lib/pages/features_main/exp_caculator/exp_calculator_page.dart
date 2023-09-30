import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

class ExpCalculatorPage extends StatefulWidget {
  const ExpCalculatorPage._();

  static const MyPageRoute route = ('/ExpCalculatorPage', _builder);
  static Widget _builder(dynamic args) {
    return const ExpCalculatorPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<ExpCalculatorPage> createState() => _ExpCalculatorPageState();
}

/// 要加上糖果介紹
/// 一般糖果為 +25
/// 萬能糖果 S => 換成三顆
class _ExpCalculatorPageState extends State<ExpCalculatorPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  var _bagCandiesCount = 0;
  var _remainExpToNextLevel = 0;
  var _currLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_exp_and_candies'.xTr,
      ),
      body: buildListView(children: _buildListItems()),
    );
  }

  List<Widget> _buildListItems() {
    't_other_pokemon'.xTr;
    't_special_exp_format_hint'.xTr;
    return [
      ...Hp.list(
        children: [
          Text('t_pokemon'.xTr),
        ],
      ),

    ];
  }
}


