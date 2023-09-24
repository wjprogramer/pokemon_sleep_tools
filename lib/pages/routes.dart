import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/splash/splash_page.dart';
import 'package:pokemon_sleep_tools/pages/sub_skill_picker/sub_skill_picker_page.dart';

typedef MyRouteBuilder<T extends Object?> = Widget Function(dynamic args);

typedef MyPageRoute<T extends Object?> = (String, MyRouteBuilder<T>);

// typedef X<T> = Function(T);

Map<String, MyRouteBuilder<Object?>> generateRoutes() {
  // final xx = <X<int>>[
  //       (num _) {},
  //       (int _) {},
  // ];

  final routes = <MyPageRoute>[
    // dev
    MyStorybookPage.route,
    // main
    HomePage.route,
    PokemonBoxPage.route,
    SplashPage.route,
    SubSkillPickerPage.route,
  ];

  return routes.toMap(
        (e) => e.name,
        (e) => e.builder,
  );
}

extension MyPageRouteX<T extends Object?> on MyPageRoute<T> {
  String get name => this.$1;
  MyRouteBuilder<T> get builder => this.$2;

  // MapEntry get mapEntry => MapEntry($1, $2);
}
