import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

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
    return const Scaffold();
  }
}
