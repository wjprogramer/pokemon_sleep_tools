import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MyPageRoute route = ('/', (_) => const HomePage());

  PokemonProfileRepository get _pokemonProfileRepository => getIt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
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
              context.nav.push(PokemonBoxPage.route);
            },
            child: const Text('Pokemon Box'),
          ),
          TextButton(
            onPressed: () {
              SubSkillPickerPage.go(context);
            },
            child: const Text('SubSkill Picker'),
          ),
          TextButton(
            onPressed: () {
              PokemonBasicProfilePicker.go(context);
            },
            child: const Text('Pokemon Basic Profile Picker'),
          ),
          TextButton(
            onPressed: () {
              PokemonMaintainProfilePage.goCreate(context);
            },
            child: const Text('Create Pokemon Profile'),
          ),
          TextButton(
            onPressed: () {
              context.nav.push(DevPokemonBoxPage.route);
            },
            child: const Text('Dev / Pokemon Box'),
          ),
          TextButton(
            onPressed: () {
              // debugPrint(_pokemonProfileRepository.getDemoProfile().info());
              debugPrint(_pokemonProfileRepository.getDemoProfile().getConstructorCode());
            },
            child: const Text('Dev / Single Pokemon Profile'),
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
      ),
    );
  }
}
