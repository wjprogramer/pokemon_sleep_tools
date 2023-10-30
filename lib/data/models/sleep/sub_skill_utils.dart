import 'dart:ui';

import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

extension SubSkillX on SubSkill {
  Color get bgColor {
    switch (rarity) {
      case 1: return greyColor;
      case 2: return blueColor;
      case 3: return yellowColor;
    }
    return greyColor;
  }
}