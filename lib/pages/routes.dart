import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';

typedef MyRouteBuilder<T extends Object?> = Widget Function(T? args);

typedef MyPageRoute<T extends Object?> = (String, MyRouteBuilder);

Map<String, MyRouteBuilder> generateRoutes() {
  final routes = <MyPageRoute>[
    // dev
    MyStorybook.route,
    // main
    HomePage.route,
  ];

  return routes.toMap(
        (e) => e.$1,
        (e) => e.$2,
  );
}