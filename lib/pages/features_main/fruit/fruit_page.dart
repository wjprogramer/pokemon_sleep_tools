import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class _FruitsPageArgs {
  _FruitsPageArgs(this.fruit);

  final Fruit fruit;
}

class FruitPage extends StatefulWidget {
  const FruitPage._(this._args);

  static const MyPageRoute route = ('/FruitPage', _builder);
  static Widget _builder(dynamic args) {
    return FruitPage._(args);
  }

  static void go(BuildContext context, Fruit fruit) {
    context.nav.push(
      route,
      arguments: _FruitsPageArgs(fruit),
    );
  }

  final _FruitsPageArgs _args;

  @override
  State<FruitPage> createState() => _FruitPageState();
}

class _FruitPageState extends State<FruitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
    );
  }
}


