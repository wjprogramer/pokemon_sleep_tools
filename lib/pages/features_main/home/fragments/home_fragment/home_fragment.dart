import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  PokemonProfileRepository get _pokemonProfileRepository => getIt();

  // TODO: 語言切換、地圖、圖鑑、

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            't_pokemon'.xTr,
            textAlign: TextAlign.center,
          ),
        ),
        TextButton(
          onPressed: () {
            context.nav.push(MyStorybookPage.route);
          },
          child: const Text('Storybook'),
        ),
        TextButton(
          onPressed: () {
            SubSkillPickerPage.go(context);
          },
          child: const Text('SubSkill Picker'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(''),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(''),
        ),
      ],
    );
  }
}
