enum MainSkill {
  energyFillS(1, '能量填充S', '使卡比獸的能量增加400'),
  energyFillM(2, '能量填充M', '使卡比獸的能量增加880'),
  energyFillSn(5, '能量填充Sn', '使卡比獸的能量增加200 到 800'),
  dreamChipS(3, '夢之碎片獲取S', '獲得88個夢之碎片'),
  dreamChipSn(6, '夢之碎片獲取Sn', '獲得 44 到 176 個夢想碎片'),
  vitalityS(4, '活力療癒S', '隨機讓1隻自己以外的寶可夢回復活力14點'),
  vitalityAllS(8, '活力全體療癒S', '讓幫手隊伍的寶可夢回復活力5點'),
  vitalityFillS(7, '活力填充S', '讓自己恢復12點活力'),
  helpSupportS(9, '幫手支援S', '幫手寶可夢中的某1隻會立刻完成 4 次幫忙'),
  ingredientS(10, '食材獲取S', '隨機獲得食材6個'),
  cuisineS(11, '料理強化S', '增加下一次料理時的鍋子容量，讓鍋子能多放7個食材'),
  finger(12, '揮指', '從全部的主技能中隨機發動1種');

  const MainSkill(this.id, this.name, this.subName);

  final int id;
  final String name;
  final String subName;
}

extension MainSkillX on MainSkill {
  /// Return Lv. 1 to Lv. 6 basic energy list
  List<double> get basicValues {
    switch (this) {
      case MainSkill.energyFillS: return [400, 569, 785, 1083, 1496, 2066, ];
      case MainSkill.energyFillM: return [880, 1251, 1726, 2383, 3290, 4546, ];
      case MainSkill.dreamChipS: return [88, 125, 173, 274, 395, 568, ];
      case MainSkill.vitalityS: return [14, 17, 23, 29, 38, 51, ];
      case MainSkill.energyFillSn: return [500, 711.5, 981.5, 1354, 1870, 2582.5, ];
      case MainSkill.dreamChipSn: return [110, 156.5, 216.5, 342.5, 494, 710, ];
      case MainSkill.vitalityFillS: return [12, 16, 21, 27, 34, 43, ];
      case MainSkill.vitalityAllS: return [5, 7, 9, 11, 15, 18, ];
      case MainSkill.helpSupportS: return [4, 5, 6, 7, 8, 9, ];
      case MainSkill.ingredientS: return [6, 8, 11, 14, 17, 21, ];
      case MainSkill.cuisineS: return [7, 10, 12, 17, 22, 27, ];
      case MainSkill.finger: return [0, 0, 0, 0, 0, 0, ];
    }
  }

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