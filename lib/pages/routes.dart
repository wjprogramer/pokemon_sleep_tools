import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';

typedef MyRouteBuilder<T extends Object?> = Widget Function(T? args);

typedef MyPageRoute<T extends Object?> = (String, MyRouteBuilder);

Map<String, MyRouteBuilder> generateRoutes() {
  final routes = <MyPageRoute>[
    // dev
    MyStorybookPage.route,
    // main
    HomePage.route,
    PokemonBoxPage.route,
  ];

  return routes.toMap(
        (e) => e.name,
        (e) => e.builder,
  );
}

extension MyPageRouteX<T> on MyPageRoute<T> {
  String get name => this.$1;
  MyRouteBuilder get builder => this.$2;
}
