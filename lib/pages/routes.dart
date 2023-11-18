import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/features_common/change_lang/change_lang_page.dart';
import 'package:pokemon_sleep_tools/pages/features_common/change_logs/change_logs_page.dart';
import 'package:pokemon_sleep_tools/pages/features_common/data_sources/data_sources_page.dart';
import 'package:pokemon_sleep_tools/pages/features_common/not_found_route/not_found_route_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_icons/dev_icons_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_icons_custom/dev_icons_custom_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_basic_profile_ingredients_combination/dev_pokemon_basic_profile_ingredients_combination_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_box/dev_pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_data_sources/dev_pokemon_data_sources_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_evolutions/dev_pokemon_evolutions_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_statics_2/dev_pokemon_statics_2_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_two_direction_table/dev_two_direction_table_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_vitality_chart/dev_vitality_chart_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/vitality_chart/vitality_chart_page.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/about/about_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/analysis_details/analysis_details_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/bag/bag_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/character_list/characters_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_energy_calculator/dish_energy_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_info/dish_info_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_list/dish_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_maker/dish_maker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator_result/exp_caculator_result_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_calculator/exp_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/field_edit/field_edit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruit/fruit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruits/fruits_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruits_energy/fruits_energy_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient_list_rarity/ingredient_list_rarity_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient_picker/ingredient_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredients_illustrated_book/ingredients_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skill/main_skill_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skills_illustrated_book/main_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skills_with_pokemon_list/main_skills_with_pokemon_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/map/map_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/maps/maps_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_evolution_illustrated_book/pokemon_evolution_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_menu/pokemon_food_menu_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_illustrated_book/pokemon_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_teams/pokemon_teams_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pot/pot_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/research_notes/research_notes_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/research_rank/research_rank_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_face/sleep_face_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_faces_illustrated_book/sleep_faces_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/specialty_info/specialty_info_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/splash/splash_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skills_illustrated_book/sub_skills_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/team_analysis/team_analysis_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/vitality_info/vitality_info_page.dart';

typedef MyRouteBuilder<T extends Object?> = Widget Function(dynamic args);

typedef MyPageRoute<T extends Object?> = (String, MyRouteBuilder<T>);

typedef MyRoutesMapping = Map<String, MyRouteBuilder>;
// Map<Type, Map<String, MyRouteBuilder>>

MyRoutesMapping generateRoutes() {
  final routes = <MyPageRoute>[
    // common
    ChangeLangPage.route,
    ChangeLogsPage.route,
    DataSourcesPage.route,
    NotFoundRoutePage.route,
    // dev
    if (kDebugMode) ...[
      DevIconsPage.route,
      DevIconsCustomPage.route,
      DevPokemonBasicProfileIngredientsCombinationPage.route,
      DevPokemonBoxPage.route,
      DevPokemonEvolutionsPage.route,
      DevPokemonStatics2Page.route,
      DevTwoDirectionTablePage.route,
      DevVitalityChartPage.route,
      MyStorybookPage.route,
      DevPokemonDataSourcesPage.route,
    ],
    // main
    AboutPage.route,
    AnalysisDetailsPage.route,
    BagPage.route,
    CharacterListPage.route,
    DishPage.route,
    DishEnergyCalculatorPage.route,
    DishInfoPage.route,
    DishListPage.route,
    DishMakerPage.route,
    ExpCalculatorPage.route,
    ExpCalculatorResultPage.route,
    FieldEditPage.route,
    FruitPage.route,
    FruitsPage.route,
    FruitsEnergyPage.route,
    HomePage.route,
    IngredientPage.route,
    IngredientPickerPage.route,
    IngredientsIllustratedBookPage.route,
    IngredientListRarityPage.route,
    MainSkillPage.route,
    MainSkillsIllustratedBookPage.route,
    MainSkillsWithPokemonListPage.route,
    MapPage.route,
    MapsPage.route,
    PokemonBasicProfilePage.route,
    PokemonBasicProfilePicker.route,
    ...PokemonMaintainProfilePage.routes,
    PokemonBoxPage.route,
    PokemonEvolutionIllustratedBookPage.route,
    PokemonFoodMenuPage.route,
    PokemonIllustratedBookPage.route,
    PokemonSliderDetailsPage.route,
    PokemonTeamsPage.route,
    PotPage.route,
    ResearchNotesPage.route,
    ResearchRankPage.route,
    SleepFacePage.route,
    SleepFacesIllustratedBookPage.route,
    SpecialtyInfoPage.route,
    SplashPage.route,
    SubSkillPickerPage.route,
    SubSkillsCharacterIllustratedBookPage.route,
    TeamAnalysisPage.route,
    VitalityChartPage.route,
    VitalityInfoPage.route,
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
