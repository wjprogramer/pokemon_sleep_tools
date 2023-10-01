import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class PokemonFoodRecipesPage extends StatefulWidget {
  const PokemonFoodRecipesPage._();

  static const MyPageRoute route = ('/PokemonFoodRecipesPage', _builder);
  static Widget _builder(dynamic args) {
    return const PokemonFoodRecipesPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PokemonFoodRecipesPage> createState() => _PokemonFoodRecipesPageState();
}

class _PokemonFoodRecipesPageState extends State<PokemonFoodRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_recipes'.xTr,
      ),
      body: ListView(
        children: const [
          // TODO:
          Text(
            '食譜一覽:\n'
                '\n'
                '太陽之力番茄咖哩\n'
                '單純白醬濃湯\n'
                '日照炸肉排咖哩\n'
                '寶寶甜蜜咖哩\n'
                '\n'
                '\n'
                '\n',
          ),
        ],
      ),
    );
  }
}
