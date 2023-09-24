import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:provider/provider.dart';

class PokemonBoxPage extends StatefulWidget {
  const PokemonBoxPage({super.key});

  static MyPageRoute route = ('/PokemonBoxPage', (_) => const PokemonBoxPage());

  @override
  State<PokemonBoxPage> createState() => _PokemonBoxPageState();
}

class _PokemonBoxPageState extends State<PokemonBoxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            final mainViewModel = context.read<MainViewModel>();
            final payload = CreatePokemonProfilePayload(
              basicProfileId: 18,
              character: PokemonCharacter.restrained,
              subSkills: [
                SubSkill.s6,
                SubSkill.s4,
                SubSkill.s13,
                SubSkill.s17,
                SubSkill.s12,
              ],
              ingredient2: Ingredient.i11,
              ingredientCount2: 2,
              ingredient3: Ingredient.i11,
              ingredientCount3: 3,
            );

            mainViewModel.create(payload);
          },
          child: Text('Hi'),
        ),
      ),
    );
  }
}
