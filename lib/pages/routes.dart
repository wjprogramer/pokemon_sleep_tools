import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/features_common/not_found_route/not_found_route_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_icons/dev_icons_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/bag/bag_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/character_illustrated_book/characters_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator/exp_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator_result/exp_caculator_result_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredients_illustrated_book/ingredients_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skills_illustrated_book/main_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/maps/maps_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_menu/pokemon_food_menu_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_recipes/pokemon_food_recipes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_illustrated_book/pokemon_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_teams/pokemon_teams_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/research_notes/research_notes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_illustrated_book/sleep_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/splash/splash_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skills_illustrated_book/sub_skills_illustrated_book_page.dart';

typedef MyRouteBuilder<T extends Object?> = Widget Function(dynamic args);

typedef MyPageRoute<T extends Object?> = (String, MyRouteBuilder<T>);

typedef MyRoutesMapping = Map<String, MyRouteBuilder>;
// Map<Type, Map<String, MyRouteBuilder>>

MyRoutesMapping generateRoutes() {
  final routes = <MyPageRoute>[
    // common
    NotFoundRoutePage.route,
    // dev
    DevIconsPage.route,
    DevPokemonBoxPage.route,
    MyStorybookPage.route,
    // main
    BagPage.route,
    CharactersIllustratedBookPage.route,
    ExpCalculatorPage.route,
    ExpCalculatorResultPage.route,
    HomePage.route,
    IngredientsIllustratedBookPage.route,
    MainSkillsCharacterIllustratedBookPage.route,
    MapsPage.route,
    PokemonBasicProfilePicker.route,
    ...PokemonMaintainProfilePage.routes,
    PokemonBoxPage.route,
    PokemonFoodMenuPage.route,
    PokemonFoodRecipesPage.route,
    PokemonIllustratedBookPage.route,
    PokemonSliderDetailsPage.route,
    PokemonTeamsPage.route,
    ResearchNotesPage.route,
    SleepIllustratedBookPage.route,
    SplashPage.route,
    SubSkillPickerPage.route,
    SubSkillsCharacterIllustratedBookPage.route,
  ];

  // final Map<Type, Map<String, MyRouteBuilder>> x = {
  //   Null: {}
  // };

  // for (final route in routes) {
  //   x[route.getArgsType] = (x[route.getArgsType] ?? {});
  //   x[route.getArgsType]![route.name] = route.builder as MyRouteBuilder;
  // }

  return routes.toMap(
        (e) => e.name,
        (e) => e.builder,
  );
}

extension MyRouteBuilderX<T> on MyRouteBuilder<T> {
  Type get getArgsType => T;
}

extension MyPageRouteX<T> on MyPageRoute<T> {
  String get name => this.$1;
  MyRouteBuilder<T> get builder => this.$2;
  Type get getArgsType => builder.getArgsType;

  // MapEntry get mapEntry => MapEntry($1, $2);
}
