import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 專長
enum PokemonSpecialty {
  /// 技能型
  t1(1, 't_specialty_type_3', 't_specialty_3', specialty3Color),
  /// 食材型
  t2(2, 't_specialty_type_2', 't_specialty_2', specialty2Color),
  /// 樹果型
  t3(3, 't_specialty_type_1', 't_specialty_1', specialty1Color);

  const PokemonSpecialty(this.id, this.nameI18nKey, this.shortNameI18nKey, this.color);

  final int id;

  final String nameI18nKey;
  final String shortNameI18nKey;
  final Color color;
}