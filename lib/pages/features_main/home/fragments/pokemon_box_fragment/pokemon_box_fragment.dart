import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_teams/pokemon_teams_page.dart';
import 'package:pokemon_sleep_tools/widgets/main/gap.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';

class PokemonBoxFragment extends StatelessWidget {
  const PokemonBoxFragment({super.key});

  PokemonProfileRepository get _pokemonProfileRepository => getIt();

  @override
  Widget build(BuildContext context) {
    // TODO:
    // 常用
    // 編組隊伍
    // 寶可夢盒子

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING
      ),
      children: [
        const Text(
          '常用',
        ),
        MyElevatedButton(
          onPressed: () {
            PokemonTeamsPage.go(context);
          },
          child: const Text('Pokemon Teams'),
        ),
        MyElevatedButton(
          onPressed: () {
            PokemonBoxPage.go(context);
          },
          child: const Text('Pokemon Box'),
        ),
        if (kDebugMode) ...[
          Gap.xl,
          const Text(
            '開發中',
          ),
          MyElevatedButton(
            onPressed: () {
              context.nav.push(DevPokemonBoxPage.route);
            },
            child: const Text('Dev / Pokemon Box'),
          ),
          MyElevatedButton(
            onPressed: () async {
              // debugPrint(_pokemonProfileRepository.getDemoProfile().info());
              debugPrint((await _pokemonProfileRepository.getDemoProfile()).getConstructorCode());
            },
            child: const Text('Dev / Single Pokemon Profile'),
          ),
        ],
        Gap.trailing,
      ],
    );
  }
}
