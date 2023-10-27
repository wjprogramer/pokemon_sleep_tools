import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

// TODO: 未完成
class _Args {
  const _Args(this.initIngredient);

  final Ingredient? initIngredient;
}

class IngredientPickerPage extends StatefulWidget {
  const IngredientPickerPage._(this._args);

  static const MyPageRoute route = ('/IngredientPickerPage', _builder);
  static Widget _builder(dynamic args) {
    return IngredientPickerPage._(args);
  }

  static Future<Ingredient?> pick(BuildContext context, {
    Ingredient? initValue,
  }) async {
    final res = await context.nav.push(
      route,
      arguments: _Args(initValue),
    );
    return res is Ingredient ? res : null;
  }

  void _pop(BuildContext context, [ Ingredient? ingredient ]) {
    context.nav.pop(ingredient);
  }

  final _Args _args;

  @override
  State<IngredientPickerPage> createState() => _IngredientPickerPageState();
}

class _IngredientPickerPageState extends State<IngredientPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '選擇食材'.xTr,
      ),
      body: buildListView(
        children: [
          ...ListTile.divideTiles(
            context: context,
            tiles: [],
          ),
        ],
      ),
    );
  }
}


