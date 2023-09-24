import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/pages/sub_skill_picker/sub_skill_picker_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MyPageRoute route = ('/', (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        children: [
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
              context.nav.push(
                SubSkillPickerPage.route, arguments: SubSkillPickerPageArgs(),
              );
            },
            child: const Text('SubSkill Picker'),
          ),
          TextButton(
            onPressed: () {
            },
            child: const Text(''),
          ),
          TextButton(
            onPressed: () {
            },
            child: const Text(''),
          ),
          TextButton(
            onPressed: () {
            },
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
