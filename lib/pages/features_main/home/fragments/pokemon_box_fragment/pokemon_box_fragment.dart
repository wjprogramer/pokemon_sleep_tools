import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator/exp_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_illustrated_book/pokemon_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_teams/pokemon_teams_page.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/team_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class PokemonBoxFragment extends StatefulWidget {
  const PokemonBoxFragment({super.key});

  @override
  State<PokemonBoxFragment> createState() => _PokemonBoxFragmentState();
}

class _PokemonBoxFragmentState extends State<PokemonBoxFragment> {
  PokemonProfileRepository get _pokemonProfileRepository => getIt();

  double _menuButtonWidth = 100;
  double _menuButtonSpacing = 0;

  @override
  Widget build(BuildContext context) {
    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _menuButtonWidth = menuItemWidthResults.childWidth;
    _menuButtonSpacing = menuItemWidthResults.spacing;

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
        MainMenuSubtitle(
          icon: const Iconify(Bx.grid_alt, size: 16,),
          title: Text(
            't_others'.xTr,
          ),
        ),
        Wrap(
          spacing: _menuButtonSpacing,
          runSpacing: _menuButtonSpacing,
          alignment: WrapAlignment.start, // default: WrapAlignment.start,
          runAlignment: WrapAlignment.start, // default: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start, // default: WrapCrossAlignment.start,
          verticalDirection: VerticalDirection.down, // default: VerticalDirection.down,
          children: _wrapMenuItems(
            children: [
              MyOutlinedButton(
                color: color1,
                onPressed: () {
                  PokemonIllustratedBookPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.camera_alt_outlined, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_pokemon_illustrated_book'.xTr),
              ),
              MyOutlinedButton(
                color: pinkColor,
                onPressed: () {
                  ExpCalculatorPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Iconify(Mdi.candy, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_exp_and_candies'.xTr),
              ),
            ],
          ),
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
            child: const Text('Pokemon Box'),
          ),
          MyElevatedButton(
            onPressed: () async {
              // debugPrint(_pokemonProfileRepository.getDemoProfile().info());
              debugPrint((await _pokemonProfileRepository.getDemoProfile()).getConstructorCode());

            },
            child: const Text('Single Pokemon Profile'),
          ),
          MyElevatedButton(
            onPressed: () async {
              final mainViewModel = context.read<MainViewModel>();
              final demoProfiles = await _pokemonProfileRepository.getDemoProfiles();

              for (final profile in demoProfiles) {
                final createdProfile = await mainViewModel.createProfile(CreatePokemonProfilePayload(
                  basicProfileId: profile.basicProfileId,
                  character: profile.character,
                  subSkills: profile.subSkills,
                  ingredient2: profile.ingredient2,
                  ingredientCount2: profile.ingredientCount2,
                  ingredient3: profile.ingredient3,
                  ingredientCount3: profile.ingredientCount3,
                ));
                final basic = createdProfile.basicProfile;
                debugPrint('pokemon created: ${basic.nameI18nKey} (${createdProfile.id})');
              }
              debugPrint('Done');
            },
            child: const Text('建立測試資料：寶可夢'),
          ),
        ],
        Gap.trailing,
      ],
    );
  }

  List<Widget> _wrapMenuItems({ required List<Widget> children }) {
    return children
        .map((e) => _wrapMenuItemContainer(child: e))
        .toList();
  }

  Widget _wrapMenuItemContainer({ required Widget child }) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: _menuButtonWidth,
      ),
      child: child,
    );
  }
}
