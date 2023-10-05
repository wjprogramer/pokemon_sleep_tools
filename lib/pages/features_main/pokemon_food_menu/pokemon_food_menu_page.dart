import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_maker/dish_maker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_recipes/pokemon_food_recipes_page.dart';
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: HORIZON_PADDING),
        children: [
          MyElevatedButton(
            onPressed: () {
              PokemonFoodRecipesPage.go(context);
            },
            child: Text('t_recipes_view'.xTr),
          ),
          Gap.md,
          MyElevatedButton(
            onPressed: () {
              DishMakerPage.go(context);
            },
            child: Text('t_dish_maker'.xTr),
          ),
          Gap.md,
          MyElevatedButton(
            onPressed: () {
              PotPage.go(context);
            },
            child: Text('t_pot'.xTr),
          ),
          Gap.trailing,
        ],
      ),
    );
  }
}
