import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 睡眠類型
enum SleepType {
  st0(0, '深深入眠', sleepType3Color, sleepType3BgColor, sleepType3FgColor),
  st1(1, '安然入睡', sleepType2Color, sleepType2BgColor, sleepType2FgColor),
  st4(4, '淺淺入夢', sleepType1Color, sleepType1BgColor, sleepType1FgColor),
  st99(99, '沒有特徵', greyColor2, greyColor2, blackColor);

  const SleepType(this.id, this.nameI18nKey, this.color, this.bgColor, this.fgColor);

  final int id;
  final String nameI18nKey;
  final Color color;
  final Color bgColor;
  final Color fgColor;
}

