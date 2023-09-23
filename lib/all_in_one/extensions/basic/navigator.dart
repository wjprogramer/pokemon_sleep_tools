import 'package:flutter/widgets.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

extension NavigatorContextX on BuildContext {
  Future<R?> go<T extends Object?, R extends Object?>(MyPageRoute<T> route, {
    T? arguments,
  }) async {
    return Navigator.of(this).pushNamed<R>(
      route.$1,
      arguments: arguments,
    );
  }
}