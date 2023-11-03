/// Step 2. (Optional) 考量多隻
class StatisticsResultWithHelpers {

}

// // 出場平均估分
// final _helperAvgScore = 226.0;
// final _helperAvgScoreLv50 = 815.0;
// final _helperAvgScoreLv100 = 2333.0;
//
// // 幫手計算估分
// final gy4 = _helperAvgScoreLv50 * 5 * 0.05;
// final ha4 = _helperAvgScoreLv100 * 5 * 0.05;
// final o4 = _helperAvgScore * 5 * 0.05 * (useHelper ? 1 : 0);
// // endregion



// // (加成後) 自身收益/h
// final totalSelfBenefitPerHour = (() {
//   final xxy = basicProfile.mainSkill == MainSkill.vitalityAllS ||
//       basicProfile.mainSkill == MainSkill.vitalityS;
//
//   return _tc(() => fruitEnergyPerHour
//       + totalIngredientEnergyPerHour
//       + mainSkillBenefitPerHour * (xxy ? 0 : 1)
//       + (profile.hasSubSkillAtLevel(SubSkill.helperBonus, level) ? o4 / 5 : 0)
//   );
// })();

// final xy = switch (type) {
//   _StatisticsLevelType.levelCustom => o4,
//   _StatisticsLevelType.level100 => gy4,
//   _StatisticsLevelType.level50 => ha4,
// };

// // 理想總收益/h
// final idealTotalBenefit = _tc(() =>
// fruitEnergyPerHour
//     + totalIngredientEnergyPerHour
//     + mainSkillBenefitPerHour
//     + (profile.hasSubSkillAtLevel(SubSkill.helperBonus, level) ? xy : 0)
// );

// // 輔助隊友收益/h
// final helpTeammateBenefitPerHour = idealTotalBenefit - totalSelfBenefitPerHour;
//
// // 性格技能影響
// final diffEffectTotalBenefit = pureTotalBenefitPerHour == 0
//     ? 0.0
//     : (idealTotalBenefit - pureTotalBenefitPerHour) / pureTotalBenefitPerHour;