import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';

class PokemonTeamsPage extends StatefulWidget {
  const PokemonTeamsPage({super.key});

  static MyPageRoute<void> route = ('/PokemonTeamsPage',
      (dynamic args) => const PokemonTeamsPage());

  static go(BuildContext context) {
    context.nav.push(PokemonTeamsPage.route);
  }

  @override
  State<PokemonTeamsPage> createState() => _PokemonTeamsPageState();
}

class _PokemonTeamsPageState extends State<PokemonTeamsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_form_team'.xTr,
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            PokemonBoxPage.pick(context);
          },
          child: const Text('Click'),
        ),
      ),
    );
  }
}
