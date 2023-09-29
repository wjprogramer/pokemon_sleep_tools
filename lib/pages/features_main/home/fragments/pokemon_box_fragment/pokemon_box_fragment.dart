import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_teams/pokemon_teams_page.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
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
        MainMenuSubtitle(
          paddingTop: 0,
          icon: const Iconify(Carbon.sub_volume, size: 16),
          title: Text(
            '常用'.xTr,
          ),
        ),
        MyOutlinedButton(
          color: color1,
          onPressed: () {
            PokemonTeamsPage.go(context);
          },
          iconBuilder: (color, size) {
            return Iconify(Bi.boxes, color: color, size: size,);
          },
          builder: MyOutlinedButton.builderUnboundWidth,
          child: Text('t_form_team'.xTr),
        ),
        Gap.md,
        MyOutlinedButton(
          color: color1,
          onPressed: () {
            PokemonBoxPage.go(context);
          },
          iconBuilder: (color, size) {
            return Iconify(Bi.box_seam, color: color, size: size,);
          },
          builder: MyOutlinedButton.builderUnboundWidth,
          child: Text('t_pokemon_box'.xTr),
        ),
        if (kDebugMode) ...[
          MainMenuSubtitle(
            icon: const Icon(Icons.bug_report_outlined, size: 16,),
            title: Text(
              't_developing'.xTr,
            ),
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
