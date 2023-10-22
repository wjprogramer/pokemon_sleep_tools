import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruit/fruit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruits_energy/fruits_energy_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

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
        titleText: 't_fruits'.xTr,
        actions: [
          IconButton(
            onPressed: () {
              DialogUtility.text(
                context,
                title: Text('t_fruits'.xTr),
                content: Text('給卡比獸吃，用以增加能量'.xTr),
                barrierDismissible: true,
              );
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView(
        children: [
          ...Hp.list(
            children: [
              MySubHeader(titleText: '一覽',),
              Gap.md,
              Wrap(
                spacing: _itemsSpacing,
                runSpacing: _itemsSpacing,
                children: _wrapItems(
                  children: Fruit.values.map(_buildItem).toList(),
                ),
              ),
              MySubHeader(
                titleText: '進階',
                color: advancedColor,
              ),
            ],
          ),
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text('樹果能量一覽'.xTr),
                onTap: () {
                  FruitsEnergyPage.go(context);
                },
              ),
            ],
          ),
          Gap.md,
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildItem(Fruit fruit) {
    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: fruit.pokemonType.color.withOpacity(.7),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (MyEnv.USE_DEBUG_IMAGE)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: SizedBox(
                    width: 28,
                    child: FruitImage(
                      fruit: fruit,
                    ),
                  ),
                ),
              RichText(
                text: TextSpan(
                  text: fruit.nameI18nKey.xTr,
                  style: _theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    // TODO: chip, color
                    if (!MyEnv.USE_DEBUG_IMAGE)
                      TextSpan(
                        text: ' (${fruit.attr})',
                        style: _theme.textTheme.bodySmall?.copyWith(
                          color: greyColor2,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Gap.sm,
          Row(
            children: [
              EnergyIcon(
                size: 16,
              ),
              Gap.sm,
              Text(
                '${Display.numInt(fruit.energyIn1)} ~ ${Display.numInt(fruit.energyIn60)}',
                style: _theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );

    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: IgnorePointer(
            child: content,
          ),
        ),
        if (MyEnv.USE_DEBUG_IMAGE)
          Positioned(
            right: -15,
            bottom: -15,
            child: Opacity(
              opacity: 0.3,
              child: PokemonTypeImage(
                pokemonType: fruit.pokemonType,
                width: 80,
              ),
            ),
          ),
        InkWell(
          onTap: () {
            FruitPage.go(context, fruit);
          },
          child: content,
        ),
      ],
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


