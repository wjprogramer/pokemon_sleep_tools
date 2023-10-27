import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_icons/dev_icons_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_icons_custom/dev_icons_custom_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_evolutions/dev_pokemon_evolutions_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_vitality_chart/dev_vitality_chart_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_vitality_chart_2/dev_vitality_chart_page_2.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/bag/bag_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/character_list/characters_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruits/fruits_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredients_illustrated_book/ingredients_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skills_illustrated_book/main_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/maps/maps_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_menu/pokemon_food_menu_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/research_notes/research_notes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_faces_illustrated_book/sleep_faces_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skills_illustrated_book/sub_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

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
            't_commonly_used'.xTr,
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
                  SleepFacesIllustratedBookPage.go(context);
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
            't_other_illustrated_books'.xTr,
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
                color: color1,
                onPressed: () {
                  IngredientsIllustratedBookPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Iconify(GameIcons.sliced_mushroom, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_ingredients'.xTr),
              ),
              MyOutlinedButton(
                color: color1,
                onPressed: () {
                  FruitsPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Iconify(Bi.apple, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_fruits'.xTr),
                // t_ingredients
              ),
              MyOutlinedButton(
                color: tmpColorCharacter,
                onPressed: () {
                  CharacterListPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.face, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('t_character'.xTr),
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
                  child: const Text('套件Icons'),
                ),
                MyElevatedButton(
                  onPressed: () {
                    final teamRepo = getIt<PokemonTeamRepository>();
                    teamRepo.findAll();
                  },
                  child: const Text('Temp'),
                ),
                MyElevatedButton(
                  onPressed: () async {
                    DevPokemonEvolutionsPage.go(context);
                  },
                  child: const Text('進化'),
                ),
                MyElevatedButton(
                  onPressed: () {
                    DevVitalityChartPage.go(context);
                  },
                  child: const Text('活力曲線 v1'),
                ),
                MyElevatedButton(
                  onPressed: () {
                    DevVitalityChartPage2.go(context);
                  },
                  child: const Text('活力曲線 v2'),
                ),
                MyElevatedButton(
                  onPressed: () {
                    DevIconsCustomPage.go(context);
                  },
                  child: const Text(
                    'Icon/Label/Image\n(Custom)',
                    textAlign: TextAlign.center,
                  ),
                ),
                MyElevatedButton(
                  onPressed: () {
                    // PokemonProfileStatistics2().tempTest();
                  },
                  child: const Text('tmp'),
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
              Iconify(Codicon.book, color: Colors.blue),
              Iconify(Bi.book, color: Colors.blue),
              Iconify(Bi.book_fill, color: Colors.blue),
              Iconify(Bi.book_half, color: Colors.blue),

              Iconify(Codicon.versions, color: Colors.blue),
              Iconify(Carbon.version, color: Colors.blue),
              Iconify(SystemUicons.version, color: Colors.blue),
              Iconify(SystemUicons.versions, color: Colors.blue),
              Iconify(Bxs.tag, color: Colors.blue),
              Iconify(Bxs.tag_alt, color: Colors.blue),
              Iconify(Bxs.tag_x, color: Colors.blue),
              Iconify(Fa6Solid.tag, color: Colors.blue),
              Iconify(Fa6Solid.tags, color: Colors.blue),

              Iconify(Carbon.increase_level, color: Colors.blue),
              Iconify(Carbon.skill_level, color: Colors.blue),
              Iconify(Carbon.skill_level_advanced, color: Colors.blue),
              Iconify(Carbon.skill_level_basic, color: Colors.blue),
              Iconify(Carbon.skill_level_intermediate, color: Colors.blue),
              Iconify(Cil.level_up, color: Colors.blue),
              Iconify(Fa.level_up, color: Colors.blue),
              Iconify(Icons8.level_up, color: Colors.blue),
              Iconify(GameIcons.level_end_flag, color: Colors.blue), // 馬里歐終點

              Iconify(Ls.star, color: Colors.blue),
              Iconify(Charm.north_star, color: Colors.blue),
              Iconify(Charm.star, color: Colors.blue),
              Iconify(Cil.star, color: Colors.blue),
              Iconify(El.star, color: Colors.blue),
              Iconify(Gg.shape_rhombus, color: Colors.blue),
              Iconify(Mdi.rhombus, color: Colors.blue),
              Iconify(Mdi.rhombus_medium, color: Colors.blue),
              Iconify(Mdi.rhombus_medium_outline, color: Colors.blue),
              Iconify(Mdi.rhombus_outline, color: Colors.blue),
              Iconify(Mdi.rhombus_split, color: Colors.blue),
              Iconify(Mdi.rhombus_split_outline, color: Colors.blue),

              Iconify(Fontisto.island, color: Colors.blue),
              Iconify(Arcticons.island, color: Colors.blue),
              Iconify(EmojioneMonotone.desert_island, color: Colors.blue),

              Iconify(GameIcons.grass_mushroom, color: Colors.blue),
              Iconify(GameIcons.mushroom, color: Colors.blue),
              Iconify(GameIcons.mushroom_cloud, color: Colors.blue),
              Iconify(GameIcons.mushroom_gills, color: Colors.blue),
              Iconify(GameIcons.mushroom_house, color: Colors.blue),
              Iconify(GameIcons.mushrooms, color: Colors.blue),
              Iconify(GameIcons.mushrooms_cluster, color: Colors.blue),

              Iconify(GameIcons.spotted_mushroom, color: Colors.blue),
              Iconify(GameIcons.super_mushroom, color: Colors.blue),
              Iconify(GameIcons.trunk_mushroom, color: Colors.blue),

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
              Iconify(Cil.dinner, color: Colors.blue),
              Iconify(Mdi.pot, color: Colors.blue),
              Iconify(Mdi.pot_light, color: Colors.blue),
              Iconify(Mdi.pot_mix, color: Colors.blue),

              Iconify(Cib.asana, color: Colors.blue), // 寶可夢盒
              Iconify(Bi.box, color: Colors.blue),
              Iconify(Bi.box_fill, color: Colors.blue),
              Iconify(Bi.box_seam_fill, color: Colors.blue),

              Iconify(Pajamas.food, color: Colors.blue),
              Iconify(Ep.food, color: Colors.blue),
              Iconify(Uil.food, color: Colors.blue),
              Iconify(Vs.cutlery, color: Colors.blue),
              Iconify(Fa.cutlery, color: Colors.blue),
              Iconify(Fe.cutlery, color: Colors.blue),
              Iconify(Jam.cutlery, color: Colors.blue),
              Iconify(Mdi.cutlery_clean, color: Colors.blue),

            ],
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
