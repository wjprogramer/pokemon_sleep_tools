import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

enum RankTitle {
  t1(1, '普通'),
  t2(2, '超級'),
  t3(3, '高級'),
  t4(4, '大師');

  const RankTitle(this.id, this.nameI18nKey);

  final int id;
  final String nameI18nKey;

  Color get bgColor {
    return switch (this) {
      RankTitle.t1 => rankTitle1Color,
      RankTitle.t2 => rankTitle2Color1,
      RankTitle.t3 => rankTitle3Color2,
      RankTitle.t4 => rankTitle4Color1,
    };
  }
}