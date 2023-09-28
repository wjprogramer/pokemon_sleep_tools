import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_menu/pokemon_food_menu_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_recipes/pokemon_food_recipes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_teams/pokemon_teams_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/splash/splash_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';

typedef MyRouteBuilder<T extends Object?> = Widget Function(dynamic args);

typedef MyPageRoute<T extends Object?> = (String, MyRouteBuilder<T>);

typedef MyRoutesMapping = Map<String, MyRouteBuilder>;
// Map<Type, Map<String, MyRouteBuilder>>

MyRoutesMapping generateRoutes() {
  final routes = <MyPageRoute>[
    // common
    // dev
    DevPokemonBoxPage.route,
    MyStorybookPage.route,
    // main
    HomePage.route,
    PokemonBasicProfilePicker.route,
    ...PokemonMaintainProfilePage.routes,
    PokemonBoxPage.route,
    PokemonFoodMenuPage.route,
    PokemonFoodRecipesPage.route,
    PokemonSliderDetailsPage.route,
    PokemonTeamsPage.route,
    SplashPage.route,
    SubSkillPickerPage.route,
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
