import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 睡眠類型
enum SleepType {
  st0(0, '深深入眠', sleepType3Color),
  st1(1, '安然入睡', sleepType2Color),
  st4(4, '淺淺入夢', sleepType1Color),
  st99(99, '沒有特徵', greyColor2);

  const SleepType(this.id, this.nameI18nKey, this.color);

  final int id;
  final String nameI18nKey;
  final Color color;
}

