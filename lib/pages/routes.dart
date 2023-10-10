import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/features_common/data_sources/data_sources_page.dart';
import 'package:pokemon_sleep_tools/pages/features_common/not_found_route/not_found_route_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_icons/dev_icons_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_evolutions/dev_pokemon_evolutions_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/about/about_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/bag/bag_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/character_illustrated_book/characters_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_maker/dish_maker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_calculator/exp_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator_result/exp_caculator_result_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruit/fruit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruits/fruits_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredients_illustrated_book/ingredients_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skill/main_skill_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skills_illustrated_book/main_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/map/map_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/maps/maps_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_menu/pokemon_food_menu_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_recipes/pokemon_food_recipes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_illustrated_book/pokemon_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_teams/pokemon_teams_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pot/pot_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/research_notes/research_notes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_face/sleep_face_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_faces_illustrated_book/sleep_faces_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/splash/splash_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skills_illustrated_book/sub_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/team_analysis/team_analysis_page.dart';

typedef MyRouteBuilder<T extends Object?> = Widget Function(dynamic args);

typedef MyPageRoute<T extends Object?> = (String, MyRouteBuilder<T>);

typedef MyRoutesMapping = Map<String, MyRouteBuilder>;
// Map<Type, Map<String, MyRouteBuilder>>

MyRoutesMapping generateRoutes() {
  final routes = <MyPageRoute>[
    // common
    DataSourcesPage.route,
    NotFoundRoutePage.route,
    // dev
    DevIconsPage.route,
    DevPokemonBoxPage.route,
    DevPokemonEvolutionsPage.route,
    MyStorybookPage.route,
    // main
    AboutPage.route,
    BagPage.route,
    CharactersIllustratedBookPage.route,
    DishPage.route,
    DishMakerPage.route,
    ExpCalculatorPage.route,
    ExpCalculatorResultPage.route,
    FruitPage.route,
    FruitsPage.route,
    HomePage.route,
    IngredientPage.route,
    IngredientsIllustratedBookPage.route,
    MainSkillPage.route,
    MainSkillsIllustratedBookPage.route,
    MapPage.route,
    MapsPage.route,
    PokemonBasicProfilePage.route,
    PokemonBasicProfilePicker.route,
    ...PokemonMaintainProfilePage.routes,
    PokemonBoxPage.route,
    PokemonFoodMenuPage.route,
    PokemonFoodRecipesPage.route,
    PokemonIllustratedBookPage.route,
    PokemonSliderDetailsPage.route,
    PokemonTeamsPage.route,
    PotPage.route,
    ResearchNotesPage.route,
    SleepFacePage.route,
    SleepFacesIllustratedBookPage.route,
    SplashPage.route,
    SubSkillPickerPage.route,
    SubSkillsCharacterIllustratedBookPage.route,
    TeamAnalysisPage.route,
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
