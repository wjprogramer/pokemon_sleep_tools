import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/navigator/extension.dart';

extension NavigatorContextX on BuildContext {
  MyContextNavigator get nav => (this, MyNavigator._instance);
}

class MyNavigator {
  MyNavigator._();

  static MyNavigator? _xInstance;
  static MyNavigator get _instance {
    _xInstance ??= MyNavigator._();
    return _xInstance!;
  }
}