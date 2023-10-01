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

class CharactersIllustratedBookPage extends StatefulWidget {
  const CharactersIllustratedBookPage._();

  static const MyPageRoute route = ('/CharactersIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const CharactersIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<CharactersIllustratedBookPage> createState() => _CharactersIllustratedBookPageState();
}

class _CharactersIllustratedBookPageState extends State<CharactersIllustratedBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_character'.xTr,
      ),
    );
  }
}


