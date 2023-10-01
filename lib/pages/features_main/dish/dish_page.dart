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

class _DishPageArgs {
  _DishPageArgs(this.dish);

  final Dish dish;
}

class DishPage extends StatefulWidget {
  const DishPage._(this._args);

  static const MyPageRoute route = ('/DishPage', _builder);
  static Widget _builder(dynamic args) {
    return DishPage._(args);
  }

  static void go(BuildContext context, Dish dish) {
    context.nav.push(
      route,
      arguments: _DishPageArgs(dish),
    );
  }

  final _DishPageArgs _args;

  @override
  State<DishPage> createState() => _DishPageState();
}

class _DishPageState extends State<DishPage> {
  Dish get _dish => widget._args.dish;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: _dish.nameI18nKey.xTr,
      ),
    );
  }
}


