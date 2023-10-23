import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

enum RankTitle {
  t1(1, 't_rank_title_1'),
  t2(2, 't_rank_title_2'),
  t3(3, 't_rank_title_3'),
  t4(4, 't_rank_title_4');

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