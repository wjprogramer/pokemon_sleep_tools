/// Step 1. 不考慮其他多隻寶可夢情境
class StatisticsResultBase {
  StatisticsResultBase({
    required this.fruitEnergy,
    required this.fruitBonusEnergy,
    required this.fruitEnergyAfterSpecialtyAndSubSkill,
    required this.fruitEnergyAfterSnorlaxFavorite,
    required this.helpSpeedSM,
    required this.ingredientSM,
    required this.skillRateSM,
    required this.ingredientRate,
    required this.fruitRate,
    required this.finalMainSkillLevel,
    required this.helpIntervalWithLevel,
    required this.helpIntervalWithLevelCharacterSkill,
    required this.finalHelpInterval,
    required this.pureHelpIntervalWithLevelVitality,
    required this.fruitCountPerHour,
    required this.pureFruitCountPerHour,
    required this.ingredientCountPerHour,
    required this.pureIngredientCountPerHour,
    required this.ingredientCount1PerHour,
    required this.pureIngredientCount1PerHour,
    required this.ingredientCount2PerHour,
    required this.pureIngredientCount2PerHour,
    required this.ingredientCount3PerHour,
    required this.pureIngredientCount3PerHour,
    required this.totalIngredientCountPerHour,
    required this.pureTotalIngredientCountPerHour,
    required this.fruitEnergyPerHour,
    required this.totalIngredientEnergyPerHour,
    required this.pureFruitEnergyPerHour,
    required this.pureIngredientEnergyPerHour,
    required this.skillActivateCountPerDay,
    required this.pureSkillActivateCountPerHour,
    required this.ingredientShardsPerHour,
    required this.mainSkillBenefitPerHour,
    required this.pureMainSkillBenefitPerHour,
    required this.totalBenefitPerHour,
    required this.pureTotalBenefitPerHour,
    required this.idealTotalBenefit,
    required this.helpTeammateBenefitPerHour,
    required this.diffEffectTotalBenefit,
    required this.rank,
  });

  final int fruitEnergy;
  final num fruitBonusEnergy;
  final num fruitEnergyAfterSpecialtyAndSubSkill;
  final num fruitEnergyAfterSnorlaxFavorite;
  final double helpSpeedSM;
  final double ingredientSM;
  final double skillRateSM;
  final double ingredientRate;
  final double fruitRate;
  final int finalMainSkillLevel;
  final double helpIntervalWithLevel;
  final double helpIntervalWithLevelCharacterSkill;
  final double finalHelpInterval;
  final double pureHelpIntervalWithLevelVitality;
  final double fruitCountPerHour;
  final double pureFruitCountPerHour;
  final double ingredientCountPerHour;
  final double pureIngredientCountPerHour;
  final double ingredientCount1PerHour;
  final double pureIngredientCount1PerHour;
  final double ingredientCount2PerHour;
  final double pureIngredientCount2PerHour;
  final double ingredientCount3PerHour;
  final double pureIngredientCount3PerHour;
  final double totalIngredientCountPerHour;
  final double pureTotalIngredientCountPerHour;
  final double fruitEnergyPerHour;
  final double totalIngredientEnergyPerHour;
  final double pureFruitEnergyPerHour;
  final double pureIngredientEnergyPerHour;
  final double skillActivateCountPerDay;
  final double pureSkillActivateCountPerHour;
  final double ingredientShardsPerHour;
  final double mainSkillBenefitPerHour;
  final double pureMainSkillBenefitPerHour;
  final double totalBenefitPerHour;
  final double pureTotalBenefitPerHour;
  final double idealTotalBenefit;
  final double helpTeammateBenefitPerHour;
  final double diffEffectTotalBenefit;
  final String rank;
}