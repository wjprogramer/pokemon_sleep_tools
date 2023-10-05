import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/navigator/navigator.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

typedef MyContextNavigator = (BuildContext, MyNavigator);

extension MyContextNavigatorX on MyContextNavigator {
  BuildContext get _context => this.$1;

  NavigatorState get _navigator => Navigator.of(_context);

  /// TODO: 目前的型態檢查不優，即使放字串、數字，也不用有 error
  Future<R?> push<T extends Object?, R extends Object?>(MyPageRoute<T> route, {
    T? arguments,
  }) async {
    return _navigator.pushNamed<R>(
      route.name,
      arguments: arguments,
    );
  }

  Future<T?> pushWidget<T extends Object?>(Widget page) async {
    return _navigator.push<T>(
      MaterialPageRoute(
        builder: (context) => page,
      ),
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

  void pop<T extends Object?>([ T? result ]) {
    _navigator.pop(result);
  }
}