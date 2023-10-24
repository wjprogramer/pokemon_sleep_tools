import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/field_menu_icon.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/labels/dish_label.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/labels/field_label.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/labels/ingredient_label.dart';

/// 處理自製 Icon, Images
class DevIconsCustomPage extends StatefulWidget {
  const DevIconsCustomPage._();

  static const MyPageRoute route = ('/DevIconsCustomPage', _builder);
  static Widget _builder(dynamic args) {
    return const DevIconsCustomPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DevIconsCustomPage> createState() => _DevIconsCustomPageState();
}

class _DevIconsCustomPageState extends State<DevIconsCustomPage> {

  final _dish = Dish.d1004;

  // field
  var _fieldChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '自製 Icon/Label/Image'.xTr,
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.hV,
        ),
        children: [
          const MySubHeader(titleText: 'Dish',),
          Gap.sm,
          Wrap(
            children: [
              DishLabel(
                onTap: () => _goDishPage(_dish),
                dish: _dish,
              ),
            ],
          ),
          const MySubHeader(titleText: 'Field'),
          _wrap(
            children: [
              const MySubHeader2(titleText: 'Label'),
              const FieldLabel(field: PokemonField.f1),
              FieldLabel(
                field: PokemonField.f2,
                checked: _fieldChecked,
                onTap: () {
                  setState(() {
                    _fieldChecked = !_fieldChecked;
                  });
                },
              ),
              const MySubHeader2(titleText: 'Label All'),
              ...PokemonField.values.map((e) => FieldLabel(field: e)),
              const MySubHeader2(titleText: 'Menu Icon'),
              const FieldMenuIcon(),
            ],
          ),
          const MySubHeader(titleText: 'Ingredient'),
          _wrap(
            children: [
              const MySubHeader2(titleText: 'Usage'),
              const MySubHeader2(titleText: 'All'),
              ...Ingredient.values.map((e) => IngredientLabel(sameIngredient: false, ingredient: e)),
            ],
          ),
          const MySubHeader(titleText: 'Pokemon'),
          const MySubHeader2(titleText: 'Sleep Type'),
          const MySubHeader2(titleText: 'Specialty'),
          const MySubHeader2(titleText: ''),
          const MySubHeader2(titleText: ''),
          const MySubHeader(titleText: ''),

          const XpIcon(),
          const PokemonRecordedIcon(),
          const PokemonRankTitleIcon(rank: RankTitle.t2,),
          const LevelIcon(),
          const PokemonTypeImage(pokemonType: PokemonType.t1,),
        ],
      ),
    );
  }

  Widget _wrap({ required List<Widget> children }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: children,
    );
  }

  void _goDishPage(Dish dish) {
    DishPage.go(context, dish);
  }

}


