import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_icons/dev_icons_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/bag/bag_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/character_illustrated_book/characters_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredients_illustrated_book/ingredients_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skills_illustrated_book/main_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/maps/maps_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_menu/pokemon_food_menu_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/research_notes/research_notes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_illustrated_book/sleep_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skills_illustrated_book/sub_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/main/gap.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  double _menuButtonWidth = 100;
  double _menuButtonSpacing = 0;

  // TODO: 語言切換、地圖、圖鑑、
  @override
  Widget build(BuildContext context) {
    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _menuButtonWidth = menuItemWidthResults.childWidth;
    _menuButtonSpacing = menuItemWidthResults.spacing;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING,
      ),
      children: [
        MainMenuSubtitle(
          paddingTop: 0,
          icon: const Iconify(Carbon.sub_volume, size: 16),
          title: Text(
            '常用'.xTr,
          ),
        ),
        Wrap(
          spacing: _menuButtonSpacing,
          runSpacing: _menuButtonSpacing,
          children: _wrapMenuItems(
            children: [
              MyOutlinedButton(
                color: potColor,
                onPressed: () {
                  PokemonFoodMenuPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Iconify(Mdi.pot_steam, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_food'.xTr),
              ),
            ],
          ),
        ),
        MainMenuSubtitle(
          icon: const Iconify(Bx.grid_alt, size: 16,),
          title: Text(
            't_main_menu'.xTr,
          ),
        ),
        Wrap(
          spacing: _menuButtonSpacing,
          runSpacing: _menuButtonSpacing,
          children: _wrapMenuItems(
            children: [
              MyOutlinedButton(
                color: color1,
                onPressed: () {
                  SleepIllustratedBookPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.camera_alt_outlined, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_sleep_illustrated_book'.xTr),
              ),
              MyOutlinedButton(
                color: orangeColorLight,
                onPressed: () {
                  BagPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.shopping_bag_outlined, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_bag'.xTr),
              ),
              MyOutlinedButton(
                color: orangeColor,
                onPressed: () {
                  ResearchNotesPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.note_alt_outlined, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_research_notes'.xTr),
              ),
              MyOutlinedButton(
                color: primaryColor,
                onPressed: () {
                  MapsPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.map, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_map'.xTr),
              ),
            ],
          ),
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
          children: _wrapMenuItems(
            children: [
              MyOutlinedButton(
                color: tmpColorSkill,
                onPressed: () {
                  MainSkillsIllustratedBookPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.thunderstorm, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_main_skills'.xTr),
              ),
              MyOutlinedButton(
                color: tmpColorSkill,
                onPressed: () {
                  SubSkillsCharacterIllustratedBookPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.thunderstorm_outlined, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_sub_skills'.xTr),
              ),
              MyOutlinedButton(
                color: tmpColorCharacter,
                onPressed: () {
                  CharactersIllustratedBookPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.face, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_character'.xTr),
              ),
              MyOutlinedButton(
                color: color1,
                onPressed: () {
                  IngredientsIllustratedBookPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Iconify(Bi.apple, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_ingredients'.xTr),
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
          Wrap(
            spacing: _menuButtonSpacing,
            runSpacing: _menuButtonSpacing,
            children: _wrapMenuItems(
              children: [
                MyElevatedButton(
                  onPressed: () {
                    context.nav.push(MyStorybookPage.route);
                  },
                  child: const Text('Storybook'),
                ),
                MyElevatedButton(
                  onPressed: () {
                    context.nav.push(DevIconsPage.route);
                  },
                  child: const Text('Icons'),
                ),
                MyElevatedButton(
                  onPressed: () {
                    final teamRepo = getIt<PokemonTeamRepository>();
                    teamRepo.findAll();
                  },
                  child: const Text('Temp'),
                ),
                MyElevatedButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
                MyElevatedButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
                MyElevatedButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
              ],
            ),
          ),
          Gap.xl,
          const Wrap(
            children: [
              Iconify(AntDesign.function_outlined, color: Colors.blue),
              Iconify(AntDesign.fund_filled, color: Colors.blue),
              Iconify(AntDesign.fund_outlined, color: Colors.blue),
              Iconify(AntDesign.fund_projection_screen_outlined, color: Colors.blue),
              Iconify(AntDesign.fund_twotone, color: Colors.blue),
              Iconify(AntDesign.fund_view_outlined, color: Colors.blue),
              Iconify(AntDesign.funnel_plot_filled, color: Colors.blue),
              Iconify(AntDesign.funnel_plot_outlined, color: Colors.blue),
              Iconify(AntDesign.funnel_plot_twotone, color: Colors.blue),
              Iconify(AntDesign.gateway_outlined, color: Colors.blue),
              Iconify(AntDesign.gif_outlined, color: Colors.blue),
              Iconify(AntDesign.gift_filled, color: Colors.blue),
              Iconify(AntDesign.gift_outlined, color: Colors.blue),
              Iconify(AntDesign.gift_twotone, color: Colors.blue),

              Iconify(Charm.candy, color: Colors.blue),
              Iconify(Arcticons.candy_crush_saga, color: Colors.blue),

              Iconify(AntDesign.gold_filled, color: Colors.blue),
              Iconify(Bi.box_arrow_down, color: Colors.blue),
              Iconify(Bi.box_arrow_down_left, color: Colors.blue),
              Iconify(Bi.box_arrow_down_right, color: Colors.blue),
              Iconify(Bi.box_arrow_in_down, color: Colors.blue),
              Iconify(Bi.box_arrow_in_down_left, color: Colors.blue),
              Iconify(Bi.box_arrow_in_down_right, color: Colors.blue),
              Iconify(Bi.box_arrow_in_left, color: Colors.blue),
              Iconify(Bi.box_arrow_in_right, color: Colors.blue),
              Iconify(Bi.box_arrow_in_up, color: Colors.blue),
              Iconify(Bi.box_arrow_in_up_left, color: Colors.blue),
              Iconify(Bi.box_arrow_in_up_right, color: Colors.blue),
              Iconify(Bi.box_arrow_left, color: Colors.blue),
              Iconify(Bi.box_arrow_right, color: Colors.blue),
              Iconify(Bi.box_arrow_up, color: Colors.blue),
              Iconify(Bi.box_arrow_up_left, color: Colors.blue),
              Iconify(Bi.box_arrow_up_right, color: Colors.blue),
              Iconify(Bi.box2, color: Colors.blue),
              Iconify(Bi.box2_fill, color: Colors.blue),
              Iconify(Bi.box2_heart, color: Colors.blue),
              Iconify(Bi.box2_heart_fill, color: Colors.blue),
              Iconify(Carbon.apple, color: Colors.blue), // 食材
              Iconify(Carbon.circle_packing, color: Colors.blue), // 寶可夢球？
              Iconify(Cib.drone, color: Colors.blue), // 寶可夢球?
              Iconify(FluentMdl2.webcam_2_off, color: Colors.blue), // 寶可夢球!
              Iconify(Carbon.model, color: Colors.blue), // 鑽石
              Iconify(Tabler.zzz_off, color: Colors.blue),
              Iconify(Pajamas.food, color: Colors.blue),
              Iconify(Ep.food, color: Colors.blue),
              Iconify(Uil.food, color: Colors.blue),
              Iconify(Cil.dinner, color: Colors.blue),
              Iconify(Vs.cutlery, color: Colors.blue),
              Iconify(Fa.cutlery, color: Colors.blue),
              Iconify(Fe.cutlery, color: Colors.blue),
              Iconify(Jam.cutlery, color: Colors.blue),
              Iconify(Mdi.cutlery_fork_knife, color: Colors.blue),
              Iconify(Mdi.cutlery_clean, color: Colors.blue),
              Iconify(Mdi.pot, color: Colors.blue),
              Iconify(Mdi.pot_light, color: Colors.blue),
              Iconify(Mdi.pot_mix, color: Colors.blue),

               // 寶可夢盒 （單個代表「寶可夢」）
              Iconify(Cib.asana, color: Colors.blue), // 寶可夢盒
              Iconify(Bi.box, color: Colors.blue),
              Iconify(Bi.box_fill, color: Colors.blue),
              Iconify(Bi.box_seam_fill, color: Colors.blue),

            ],
          ),
        ],
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
