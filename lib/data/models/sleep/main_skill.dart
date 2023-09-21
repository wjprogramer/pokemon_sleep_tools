enum MainSkill {
  m1(1, '能量填充S', '使卡比獸的能量增加400'),
  m2(2, '能量填充M', '使卡比獸的能量增加880'),
  m3(3, '夢之碎片獲取S', '獲得88個夢之碎片'),
  m4(4, '活力療癒S', '隨機讓1隻自己以外的寶可夢回復活力14點'),
  m5(5, '能量填充Sn', '使卡比獸的能量增加200 到 800'),
  m6(6, '夢之碎片獲取Sn', '獲得 44 到 176 個夢想碎片'),
  m7(7, '活力填充S', '讓自己恢復12點活力'),
  m8(8, '活力全體療癒S', '讓幫手隊伍的寶可夢回復活力5點'),
  m9(9, '幫手支援S', '幫手寶可夢中的某1隻會立刻完成 4 次幫忙'),
  m10(10, '食材獲取S', '隨機獲得食材6個'),
  m11(11, '料理強化S', '增加下一次料理時的鍋子容量，讓鍋子能多放7個食材'),
  m12(12, '揮指', '從全部的主技能中隨機發動1種');

  const MainSkill(this.id, this.name, this.subName);

  final int id;
  final String name;
  final String subName;
}

extension MainSkillX on MainSkill {
  List<double> get values {
    switch (this) {
      case MainSkill.m1: return [400, 569, 785, 1083, 1496, 2066, ];
      case MainSkill.m2: return [880, 1251, 1726, 2383, 3290, 4546, ];
      case MainSkill.m3: return [88, 125, 173, 274, 395, 568, ];
      case MainSkill.m4: return [14, 17, 23, 29, 38, 51, ];
      case MainSkill.m5: return [500, 711.5, 981.5, 1354, 1870, 2582.5, ];
      case MainSkill.m6: return [110, 156.5, 216.5, 342.5, 494, 710, ];
      case MainSkill.m7: return [12, 16, 21, 27, 34, 43, ];
      case MainSkill.m8: return [5, 7, 9, 11, 15, 18, ];
      case MainSkill.m9: return [4, 5, 6, 7, 8, 9, ];
      case MainSkill.m10: return [6, 8, 11, 14, 17, 21, ];
      case MainSkill.m11: return [7, 10, 12, 17, 22, 27, ];
      case MainSkill.m12: return [0, 0, 0, 0, 0, 0, ];
    }
  }
}