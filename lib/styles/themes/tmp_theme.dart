import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

ThemeData generateTempTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
  );

  final theme = ThemeData.from(
    colorScheme: colorScheme,
    useMaterial3: true,
  );

  final listTileTheme = theme.listTileTheme.copyWith(
    contentPadding: const EdgeInsets.fromLTRB(HORIZON_PADDING, 0, HORIZON_PADDING, 0)
  );

  return theme.copyWith(
    listTileTheme: listTileTheme,
  );
}