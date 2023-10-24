import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// [description] 中的數值會根據技能等級以及 [basicValues] 的數值做變動
enum MainSkill {
  energyFillS(1, 't_main_skill_1', '使卡比獸的能量增加400', 1),
  energyFillM(2, 't_main_skill_2', '使卡比獸的能量增加880', 1),
  energyFillSn(5, 't_main_skill_5', '使卡比獸的能量增加200 到 800', 1),
  dreamChipS(3, 't_main_skill_3', '獲得88個夢之碎片', 2),
  dreamChipSn(6, 't_main_skill_6', '獲得 44 到 176 個夢想碎片', 2),
  vitalityS(4, 't_main_skill_4', '隨機讓1隻自己以外的寶可夢回復活力14點', 3),
  vitalityAllS(8, 't_main_skill_8', '讓幫手隊伍的寶可夢回復活力5點', 3),
  vitalityFillS(7, 't_main_skill_7', '讓自己恢復12點活力', 3),
  helpSupportS(9, 't_main_skill_9', '幫手寶可夢中的某1隻會立刻完成 4 次幫忙', 4),
  ingredientS(10, 't_main_skill_10', '隨機獲得食材6個', 4),
  cuisineS(11, 't_main_skill_11', '增加下一次料理時的鍋子容量，讓鍋子能多放7個食材', 4),
  finger(12, 't_main_skill_13', '從全部的主技能中隨機發動1種', 2);

  const MainSkill(this.id, this.nameI18nKey, this.description, this.type);

  final int id;
  final String nameI18nKey;
  final String description;

  /// 個人的分類
  final int type;

  Color get color {
    return switch(type) {
      1 => color2,
      2 => orangeColorLight,
      3 => greenLightColor,
      4 => pinkColor2,
      _ => greyColor2,
    };
  }

}

extension MainSkillX on MainSkill {
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

  /// Return Lv. 1 to Lv. 6 basic value list
  /// 已經和 [此網站](https://pks.raenonx.cc/info/mainskill) 雙重比對過
  List<double> get basicValues {
    switch (this) {
      case MainSkill.energyFillS: return [400, 569, 785, 1083, 1496, 2066, ];
      case MainSkill.energyFillM: return [880, 1251, 1726, 2383, 3290, 4546, ];
      case MainSkill.dreamChipS: return [88, 125, 173, 274, 395, 568, ];
      case MainSkill.vitalityS: return [14, 17, 23, 29, 38, 51, ]; // TODO: 和不同網站數值有出入
      /*
        活力療癒S
        隨機讓隊伍的1隻寶可夢回復活力 {#1}
        (單位為隨機隊內 1 名的活力回復量)
        (註解的資料來源為 https://pks.raenonx.cc/info/mainskill)

        Lv 1: 14
        Lv 2: 17
        Lv 3: 22
        Lv 4: 28
        Lv 5: 38
        Lv 6: 50
      */
      case MainSkill.energyFillSn: return [500, 711.5, 981.5, 1354, 1870, 2582.5, ]; // TODO: 和不同網站計算不一樣
      /*
        能量填充S (#1 ~ #2)
        卡比獸的能量增加 {#1} ～ {#2}
        TODO: (此數值為區間，需研究原本參考網站的數值邏輯)
        (註解的資料來源為 https://pks.raenonx.cc/info/mainskill)

        Lv 1: 200 ~ 800
        Lv 2: 285 ~ 1138
        Lv 3: 393 ~ 1570
        Lv 4: 542 ~ 2166
        Lv 5: 748 ~ 2992
        Lv 6: 1033 ~ 4132
       */
      case MainSkill.dreamChipSn: return [110, 156.5, 216.5, 342.5, 494, 710, ]; // TODO: 和不同網站計算不一樣
      /*
        夢之碎片獲取S (#1 ~ #2)
        獲得 {#1} ～ {#2} 個夢之碎片。
        TODO: (此數值為區間，需研究原本參考網站的數值邏輯)
        (註解的資料來源為 https://pks.raenonx.cc/info/mainskill)

        Lv. 1:  44 ~ 176
        Lv. 2:  63 ~ 250
        Lv. 3:  87 ~ 346
        Lv. 4:  137 ~ 548
        Lv. 5:  198 ~ 790
        Lv. 6:  284 ~ 1136
       */
      case MainSkill.vitalityFillS: return [12, 16, 21, 27 /* 26 */, 34 /* 33 */, 43, ]; // TODO: 註解的值和不同網站數值有出入
      case MainSkill.vitalityAllS: return [5, 7, 9, 11, 15, 18, ];
      case MainSkill.helpSupportS: return [4, 5, 6, 7, 8, 9, ];
      case MainSkill.ingredientS: return [6, 8, 11, 14, 17, 21, ];
      case MainSkill.cuisineS: return [7, 10, 12, 17, 22, 27, ];
      case MainSkill.finger: return [0, 0, 0, 0, 0, 0, ];
    }
  }

  /// TODO: 這邊好像有部分主觀計算，可以讓使用者自行設定權重?
  List<double> calcEnergyList() {
    switch (this) {
      case MainSkill.energyFillS: return MainSkill.energyFillS.basicValues;
      case MainSkill.energyFillM: return MainSkill.energyFillM.basicValues;
      case MainSkill.dreamChipS: return MainSkill.dreamChipS.basicValues.map((e) => e * 25).toList();
      case MainSkill.vitalityS: return MainSkill.vitalityS.basicValues.map((e) => e / 2).toList();
      case MainSkill.energyFillSn: return MainSkill.energyFillSn.basicValues;
      case MainSkill.dreamChipSn: return MainSkill.dreamChipSn.basicValues.map((e) => e * 25).toList();
      case MainSkill.vitalityFillS: return MainSkill.vitalityFillS.basicValues.map((e) => e / 2).toList();
      case MainSkill.vitalityAllS: return MainSkill.vitalityAllS.basicValues.map((e) => e * 5 / 3).toList();
      case MainSkill.helpSupportS: return MainSkill.helpSupportS.basicValues.map((e) => e * 222.6).toList();
      case MainSkill.ingredientS: return MainSkill.ingredientS.basicValues.map((e) => e * 110).toList();
      case MainSkill.cuisineS: return MainSkill.cuisineS.basicValues.map((e) => e * 110).toList();
      case MainSkill.finger:
        final v1 = MainSkill.energyFillS.calcEnergyList();
        final v2 = MainSkill.energyFillM.calcEnergyList();
        final v5 = MainSkill.energyFillSn.calcEnergyList();
        final v9 = MainSkill.helpSupportS.calcEnergyList();
        final v10 = MainSkill.ingredientS.calcEnergyList();
        final v11 = MainSkill.cuisineS.calcEnergyList();

        return List.generate(6, (i) =>
        (v1[i] + v2[i] + v5[i] + v9[i] + v10[i] + v11[i]) / 6);
    }
  }
}
