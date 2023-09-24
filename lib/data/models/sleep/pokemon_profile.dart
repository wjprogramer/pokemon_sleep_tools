import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonProfile {
  PokemonProfile({
    required this.basicProfileId,
    required this.character,
    required this.subSkillLv10,
    required this.subSkillLv25,
    required this.subSkillLv50,
    required this.subSkillLv75,
    required this.subSkillLv100,
    required this.ingredient2,
    required this.ingredientCount2,
    required this.ingredient3,
    required this.ingredientCount3,
  });

  // TODO:
  int id = -1;
  final int basicProfileId;
  late PokemonBasicProfile basicProfile;
  final PokemonCharacter character;

  final SubSkill subSkillLv10;
  final SubSkill subSkillLv25;
  final SubSkill subSkillLv50;
  final SubSkill subSkillLv75;
  final SubSkill subSkillLv100;

  Ingredient get ingredient1 => basicProfile.ingredient1;
  int get ingredientCount1 => basicProfile.ingredientCount1;
  final Ingredient ingredient2;
  final int ingredientCount2;
  final Ingredient ingredient3;
  final int ingredientCount3;

  List<SubSkill> get subSkills => [
    subSkillLv10,
    subSkillLv25,
    subSkillLv50,
    subSkillLv75,
    subSkillLv100,
  ];

  String info() {
    final fruitCount = calcFruitCount();
    final fruitEnergy = fruitCount * basicProfile.fruit.energyIn60;

    final ingredientEnergy1 = ingredient1.energy * ingredientCount1;
    final ingredientEnergy2 = ingredient2.energy * ingredientCount2;
    final ingredientEnergy3 = ingredient3.energy * ingredientCount3;
    final ingredientEnergyAvg = ((ingredientEnergy1 + ingredientEnergy2 + ingredientEnergy3) / 3).round();

    var result = '${basicProfile.nameI18nKey}\n'
        '性格: ${character.name}\n'
        '副技能:\n'
        '    Lv 10: ${subSkillLv10.name}\n'
        '    Lv 25: ${subSkillLv25.name}\n'
        '    Lv 50: ${subSkillLv50.name}\n'
        '    Lv 75: ${subSkillLv75.name}\n'
        '    Lv 100: ${subSkillLv100.name} \n'
        '食材:\n'
        '    ${ingredient1.nameI18nKey} ($ingredientCount1)\n'
        '    ${ingredient2.nameI18nKey} ($ingredientCount2)\n'
        '    ${ingredient3.nameI18nKey} ($ingredientCount3)\n'
        '類型: ${basicProfile.sleepType.name} (${basicProfile.fruit.nameI18nKey}) \n'
        '數量: $fruitCount\n'
        '幫忙均能/次: ${calcHelpPerAvgEnergy()}\n'
        '類型: ${basicProfile.sleepType.name}\n'
        '樹果: ${basicProfile.fruit.nameI18nKey}\n'
        '數量: $fruitCount\n'
        '幫忙間隔: ${calcHelpInterval()}\n'
        '樹果能量: $fruitEnergy\n'
        '食材1能量: $ingredientEnergy1\n'
        '食材2能量: $ingredientEnergy2\n'
        '食材3能量: $ingredientEnergy3\n'
        '食材均能: $ingredientEnergyAvg\n'
        '幫手獎勵: ${calcHelperBonus()}\n'
        '幫忙速度S: ${calcTotalHelpSpeedS()}\n'
        '幫忙速度M: ${calcTotalHelpSpeedM()}\n'
        '食材機率: ${calcIngredientRate()}\n'
        '技能等級: ${calcSkillLevel()}\n'
        '主技能速度參數: ${calcMainSkillSpeedParameter()}\n'
        '持有上限溢出數: ${calcMaxOverflowHoldCount()}\n'
        '持有上限溢出能量: ${calcOverflowHoldEnergy()}\n'
        '性格速度: ${calcCharacterSpeed()}\n'
        '活力加速: ${calcAccelerateVitality()}\n'
        '睡眠EXP獎勵: ${calcSleepExpBonus()}\n'
        '夢之碎片獎勵: ${calcDreamChipsBonus()}\n'
        '主技能: ${basicProfile.mainSkill.name}\n'
        '主技能能量: ${calcMainSkillTotalEnergy()}\n'
        '主技活力加速: ${calcMainSkillAccelerateVitality()}\n'
    ;

    return result;
  }

  int calcHelperBonus() =>
      15 * _getSubSkillsCountWhereValue(SubSkill.s2);

  double calcTotalHelpSpeedS() =>
      0.07 * _getSubSkillsCountWhereValue(SubSkill.s4);

  double calcTotalHelpSpeedM() =>
      0.14 * _getSubSkillsCountWhereValue(SubSkill.s3);

  int calcFruitCount() {
    var res = 1;

    if (basicProfile.sleepType == PokemonSleepType.t3) {
      res++;
    }
    res += _getSubSkillsCountWhereValue(SubSkill.s1);

    return res;
  }

  double calcIngredientRate() {
    var res = 1.0;

    if (character.positive == '食材發現') {
      res += 0.2;
    }
    if (character.negative == '食材發現') {
      res -= 0.2;
    }
    res += 0.18 * _getSubSkillsCountWhereValue(SubSkill.s6);
    res += 0.36 * _getSubSkillsCountWhereValue(SubSkill.s5);

    return res;
  }

  int calcSkillLevel() {
    return _getSubSkillsCountWhereValue(SubSkill.s8) +
        2 * _getSubSkillsCountWhereValue(SubSkill.s7);
  }

  double calcMainSkillSpeedParameter() {
    var res = 0.0;

    if (character.positive == '主技能') {
      res += 0.2;
    }
    if (character.negative == '主技能') {
      res -= 0.2;
    }
    res += 0.18 * _getSubSkillsCountWhereValue(SubSkill.s10);
    res += 0.36 * _getSubSkillsCountWhereValue(SubSkill.s9);

    return res;
  }

  /// 持有上限溢出數
  double calcMaxOverflowHoldCount() {
    var res = 0.0;
    final ingredientRate = calcIngredientRate();

    final x = ((ingredientCount1 + ingredientCount2 + ingredientCount3) * ingredientRate) / 3 +
        ((5 - ingredientRate) * calcFruitCount());
    final y = (30600 / calcHelpInterval()).round();
    res += x * y;

    res -= (
        basicProfile.boxCount +
            6 * _getSubSkillsCountWhereValue(SubSkill.s13) +
            12 * _getSubSkillsCountWhereValue(SubSkill.s12) +
            18 * _getSubSkillsCountWhereValue(SubSkill.s11)
    );

    return res;
  }

  /// 持有上限溢出能量
  double calcOverflowHoldEnergy() {
    var res = 0.0;

    final maxOverflowHoldCount = calcMaxOverflowHoldCount();
    final helpPerAvgEnergy = calcHelpPerAvgEnergy();
    final ingredientRate = calcIngredientRate();

    if (maxOverflowHoldCount * helpPerAvgEnergy > 0) {
      res = maxOverflowHoldCount * (ingredientRate / 5);
    }

    // (AE3/T3+AF3/V3+AG3/X3)
    res *= (ingredient1.energy + ingredient2.energy + ingredient3.energy) / 3;

    res /= 3.0;

    return res.roundToDouble();
  }

  /// 幫忙間隔
  double calcHelpInterval() {
    final x = calcHelperBonus() +
        calcTotalHelpSpeedS() +
        calcTotalHelpSpeedM() +
        calcCharacterSpeed() +
        calcAccelerateVitality() +
        calcMainSkillAccelerateVitality();
    final y = 1 - (x + 59 * 0.002);
    final z = basicProfile.helpInterval * y;

    return z.clamp(0, double.infinity);
  }

  /// 幫忙均能/次
  double calcHelpPerAvgEnergy() {
    final ingredientEnergy1 = ingredient1.energy * ingredientCount1;
    final ingredientEnergy2 = ingredient2.energy * ingredientCount2;
    final ingredientEnergy3 = ingredient3.energy * ingredientCount3;
    final ingredientEnergyAvg = ((ingredientEnergy1 + ingredientEnergy2 + ingredientEnergy3) / 3).round();

    final fruitCount = calcFruitCount();
    final fruitEnergy = fruitCount * basicProfile.fruit.energyIn60;

    final ingredientRate = calcIngredientRate();

    return (ingredientEnergyAvg * ingredientRate + fruitEnergy * (5 - ingredientRate)) / 5;
  }

  /// 性格速度
  double calcCharacterSpeed() {
    var res = 0.0;

    if (character.positive == '幫忙速度') {
      res += 0.1;
    }
    if (character.negative == '幫忙速度') {
      res -= 0.1;
    }

    return res;
  }

  /// 活力加速
  double calcAccelerateVitality() {
    var res = 0.0;

    if (character.positive == '活力回復') {
      res += 0.1;
    }
    if (character.negative == '活力回復') {
      res -= 0.1;
    }
    /// FIXME: 需確認 1.12? 1.02? (試算表公式是用 0.02)
    res += 0.02 * _getSubSkillsCountWhereValue(SubSkill.s14);

    return res;
  }

  /// 睡眠EXP獎勵
  int calcSleepExpBonus() {
    return 1000 * _getSubSkillsCountWhereValue(SubSkill.s15);
  }

  /// 夢之碎片獎勵
  int calcDreamChipsBonus() {
    return 500 * _getSubSkillsCountWhereValue(SubSkill.s17);
  }

  double calcMainSkillAccelerateVitality() {
    var res = 0.0;
    final valueIndex = basicProfile.evolutionMaxCount +
        calcSkillLevel() - 1;
    final skillName = basicProfile.mainSkill.name;

    if (skillName == '活力填充S' || skillName == '活力療癒S' || skillName == '活力全體療癒S') {
      res += (0.015 * basicProfile.mainSkill.calcEnergyList()[valueIndex]) *
          (1 + calcMainSkillSpeedParameter());
    }

    return res;
  }

  int calcMainSkillTotalEnergy() {
    final mainSkill = basicProfile.mainSkill;
    final skillName = mainSkill.name;
    if (skillName == '活力填充S' || skillName == '活力療癒S' || skillName == '活力全體療癒S') {
      return 0;
    }

    final valueIndex = basicProfile.evolutionMaxCount +
        calcSkillLevel() - 1;
    final basicEnergy = basicProfile.mainSkill.calcEnergyList()[valueIndex];
    var res = basicEnergy;

    res *= 1 + calcMainSkillSpeedParameter();

    return res.round();
  }


  int _getSubSkillsCountWhereValue(SubSkill targetValue) {
    return subSkills
        .where((skill) => skill == targetValue)
        .length;
  }

}