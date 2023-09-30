import 'package:flutter/material.dart';

extension ColorX on Color {
  /// [ref](https://stackoverflow.com/questions/59909746/how-to-check-brightness-of-a-background-color-to-decide-text-color-written-on-it)
  Color get fgColor => computeLuminance() >= 0.5 ? Colors.black : Colors.white;
}