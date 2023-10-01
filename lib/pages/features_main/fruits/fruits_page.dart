import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruit/fruit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class FruitsPage extends StatefulWidget {
  const FruitsPage._();

  static const MyPageRoute route = ('/FruitsPage', _builder);
  static Widget _builder(dynamic args) {
    return const FruitsPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<FruitsPage> createState() => _FruitsPageState();
}

class _FruitsPageState extends State<FruitsPage> {

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
        titleText: ''.xTr,
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
              children: Fruit.values.map(_buildItem).toList(),
            ),
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildItem(Fruit fruit) {
    return InkWell(
      onTap: () {
        FruitPage.go(context, fruit);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              fruit.nameI18nKey.xTr,
              style: _theme.textTheme.bodyLarge,
            ),
            Row(
              children: [
                
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


