import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

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

  // UI
  late ThemeData _theme;
  double _itemWidth = 100;
  double _itemsSpacing = 0;

  @override
  Widget build(BuildContext context) {
    _theme = ThemeData();

    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _itemWidth = menuItemWidthResults.childWidth;
    _itemsSpacing = menuItemWidthResults.spacing;

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_ingredients'.xTr,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          Wrap(
            spacing: _itemsSpacing,
            runSpacing: _itemsSpacing,
            children: _wrapItems(
              children: Ingredient.values.map(_buildItem).toList(),
            ),
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildItem(Ingredient ingredient) {
    return InkWell(
      onTap: () {
        IngredientPage.go(context, ingredient);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (MyEnv.USE_DEBUG_IMAGE)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IngredientImage(
                      ingredient: ingredient,
                      width: 25,
                    ),
                  ),
                Expanded(
                  child: Text(
                    ingredient.nameI18nKey.xTr,
                    style: _theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                EnergyIcon(
                  size: 16,
                ),
                Gap.sm,
                Text(Display.numInt(ingredient.energy)),
                Gap.md,
                DreamChipIcon(
                  size: 16,
                ),
                Gap.sm,
                Text(Display.numInt(ingredient.dreamChips)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _wrapItems({ required List<Widget> children }) {
    return children
        .map((e) => _wrapMenuItemContainer(child: e))
        .toList();
  }

  Widget _wrapMenuItemContainer({ required Widget child }) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: _itemWidth,
      ),
      child: child,
    );
  }
}


