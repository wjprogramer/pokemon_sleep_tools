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

class _IngredientPageArgs {
  _IngredientPageArgs(this.ingredient);

  final Ingredient ingredient;
}

class IngredientPage extends StatefulWidget {
  const IngredientPage._(this._args);

  static const MyPageRoute route = ('/IngredientPage', _builder);
  static Widget _builder(dynamic args) {
    return IngredientPage._(args);
  }

  static void go(BuildContext context, Ingredient ingredient) {
    context.nav.push(
      route,
      arguments: _IngredientPageArgs(ingredient),
    );
  }

  final _IngredientPageArgs _args;

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  Ingredient get _ingredient => widget._args.ingredient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: _ingredient.nameI18nKey.xTr,
      ),
    );
  }
}


