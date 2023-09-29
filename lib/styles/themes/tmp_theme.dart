import 'package:flutter/material.dart';

ThemeData generateTempTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
  );

  return ThemeData.from(
    colorScheme: colorScheme,
    useMaterial3: true,
  ).copyWith(
  );
}