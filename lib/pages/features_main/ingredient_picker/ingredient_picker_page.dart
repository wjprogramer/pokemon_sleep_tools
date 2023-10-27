import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images_private/ingredient_image.dart';

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
            tiles: [
              for (final ingredient in Ingredient.values)
                ListTile(
                  leading: !MyEnv.USE_DEBUG_IMAGE ? null : IngredientImage(
                    ingredient: ingredient,
                    width: 24,
                    disableTooltip: true,
                  ),
                  title: Text(
                    ingredient.nameI18nKey.xTr,
                  ),
                  onTap: () {
                    widget._pop(context, ingredient);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}


