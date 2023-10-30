import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/main_skill.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

extension MainSkillUtilsX on MainSkill {
  Color get color {
    return switch(type) {
      1 => color2,
      2 => orangeColorLight,
      3 => greenLightColor,
      4 => pinkColor2,
      _ => greyColor2,
    };
  }

  /// 1 <= [level] <= [MAX_MAIN_SKILL_LEVEL]
  String getDisplayTextByLevel(int level) {
    final baseMessage = switch (this) {
      MainSkill.energyFillS => '使卡比獸的能量增加 @value',
      MainSkill.energyFillM => '使卡比獸的能量增加 @value',
      MainSkill.energyFillSn => '使卡比獸的能量增加 @value',
      MainSkill.dreamChipS => '獲得 @value 個夢之碎片',
      MainSkill.dreamChipSn => '獲得 @value 個夢想碎片',
      MainSkill.vitalityS => '隨機讓1隻自己以外的寶可夢回復活力 @value 點',
      MainSkill.vitalityAllS => '讓幫手隊伍的寶可夢回復活力 @value 點',
      MainSkill.vitalityFillS => '讓自己恢復 @value 點活力',
      MainSkill.helpSupportS => '幫手寶可夢中的某 1 隻會立刻完成 @value 次幫忙',
      MainSkill.ingredientS => '隨機獲得食材 @value 個',
      MainSkill.cuisineS => '增加下一次料理時的鍋子容量，讓鍋子能多放 @value 個食材',
      MainSkill.finger => '從全部的主技能中隨機發動 @value 種',
    };
    var valueString = Display.numInt(basicValues[level - 1]);
    switch (this) {
      case MainSkill.finger:
        valueString = Display.numInt(1);
        break;
      case MainSkill.energyFillSn:
        final xxx = [
          (200, 800),
          (285, 1138),
          (393, 1570),
          (542, 2166),
          (748, 2992),
          (1033, 4132),
        ];
        valueString = '${Display.numInt(xxx[level - 1].$1)} ~ ${Display.numInt(xxx[level - 1].$2)}';
      default:
        break;
    }

    return baseMessage.trParams({
      'value': valueString,
    });
  }

}
