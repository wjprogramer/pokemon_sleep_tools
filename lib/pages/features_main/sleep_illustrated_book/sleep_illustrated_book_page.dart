import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

class SleepIllustratedBookPage extends StatefulWidget {
  const SleepIllustratedBookPage._();

  static const MyPageRoute route = ('/SleepIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const SleepIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<SleepIllustratedBookPage> createState() => _SleepIllustratedBookPageState();
}

class _SleepIllustratedBookPageState extends State<SleepIllustratedBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_sleep_illustrated_book'.xTr,
      ),
    );
  }
}


