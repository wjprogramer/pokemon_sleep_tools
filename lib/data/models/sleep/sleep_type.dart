import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 睡眠類型
enum SleepType {
  /// 深深入眠
  st0(0, 't_sleep_type_0', sleepType3Color, sleepType3BgColor, sleepType3FgColor),
  /// 安然入睡
  st1(1, 't_sleep_type_1', sleepType2Color, sleepType2BgColor, sleepType2FgColor),
  /// 淺淺入夢
  st4(4, 't_sleep_type_4', sleepType1Color, sleepType1BgColor, sleepType1FgColor),
  /// 沒有特徵
  st99(99, 't_sleep_type_99', greyColor2, greyColor2, blackColor);

  const SleepType(this.id, this.nameI18nKey, this.color, this.bgColor, this.fgColor);

  final int id;
  final String nameI18nKey;
  final Color color;
  final Color bgColor;
  final Color fgColor;
}

