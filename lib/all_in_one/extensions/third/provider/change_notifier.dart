import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

extension ChangeNotifierX on ChangeNotifier {
  MyDisposable xAddListener(VoidCallback listener) {
    addListener(listener);
    return () {
      removeListener(listener);
    };
  }
}