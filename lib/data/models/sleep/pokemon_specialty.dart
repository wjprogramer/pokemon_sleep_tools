import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 專長
enum PokemonSpecialty {
  t1(1, '技能型', '技能', specialty3Color),
  t2(2, '食材型', '食材', specialty2Color),
  t3(3, '樹果型', '樹果', specialty1Color);

  const PokemonSpecialty(this.id, this.nameI18nKey, this.shortNameI18nKey, this.color);

  final int id;

  final String nameI18nKey;
  final String shortNameI18nKey;
  final Color color;
}