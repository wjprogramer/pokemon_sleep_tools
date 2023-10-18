import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_energy_calculator/dish_energy_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_info/dish_info_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_list/dish_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pot/pot_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// TODO: 要依照篩選的鍋子容量顯示累進夢之碎片
class PokemonFoodMenuPage extends StatefulWidget {
  const PokemonFoodMenuPage._();

  static const MyPageRoute route = ('PokemonFoodMenuPage', _builder);
  static Widget _builder(dynamic args) {
    return const PokemonFoodMenuPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PokemonFoodMenuPage> createState() => _PokemonFoodMenuPageState();
}

class _PokemonFoodMenuPageState extends State<PokemonFoodMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_food'.xTr,
        actions: [
          IconButton(
            onPressed: () {
              DishInfoPage.go(context);
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: HORIZON_PADDING),
        children: [
          Text('常用'),
          Gap.md,
          MyElevatedButton(
            onPressed: () {
              DishListPage.go(context);
            },
            child: Text('t_recipes_view'.xTr),
          ),
          Gap.md,
          Text('t_others'.xTr),
          // Gap.md,
          // MyElevatedButton(
          //   onPressed: () {
          //     DishMakerPage.go(context);
          //   },
          //   child: Text('t_dish_maker'.xTr),
          // ),
          Gap.md,
          MyElevatedButton(
            onPressed: () {
              PotPage.go(context);
            },
            child: Text('t_pot'.xTr),
          ),
          Gap.md,
          MyElevatedButton(
            onPressed: () {
              DishEnergyCalculatorPage.go(context);
            },
            child: Text('料理能量計算器'.xTr),
          ),
          Gap.trailing,
        ],
      ),
    );
  }
}
