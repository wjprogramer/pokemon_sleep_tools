import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemon_sleep_tools/all_in_one/navigator/navigator.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

typedef MyContextNavigator = (BuildContext, MyNavigator);

extension MyContextNavigatorX on MyContextNavigator {
  BuildContext get _context => this.$1;

  NavigatorState get _navigator => Navigator.of(_context);

  Future<R?> push<T extends Object?, R extends Object?>(MyPageRoute<T> route, {
    T? arguments,
  }) async {
    return _navigator.pushNamed<R>(
      route.name,
      arguments: arguments,
    );
  }

  Future<R?> replaceWithoutAnimation<T extends Object?, R extends Object?>(MyPageRoute<T> route, {
    T? arguments,
  }) async {
    return _navigator.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, animation1, animation2) => route.builder(arguments),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}