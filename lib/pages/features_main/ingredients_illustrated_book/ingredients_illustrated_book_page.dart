import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class IngredientsIllustratedBookPage extends StatefulWidget {
  const IngredientsIllustratedBookPage._();

  static const MyPageRoute route = ('/IngredientsIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const IngredientsIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<IngredientsIllustratedBookPage> createState() => _IngredientsIllustratedBookPageState();
}

class _IngredientsIllustratedBookPageState extends State<IngredientsIllustratedBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_ingredients'.xTr,
      ),
    );
  }
}


