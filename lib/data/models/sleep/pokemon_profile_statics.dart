import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonProfileStatistics {
  PokemonProfileStatistics._(this.profile);

  factory PokemonProfileStatistics.from(PokemonProfile profile) {
    return PokemonProfileStatistics._(profile);
  }

  void init() {
    final xFruitCount = _calcFruitCount();
    final xFruitEnergy = xFruitCount * basicProfile.fruit.energyIn60;
    fruitEnergy = xFruitEnergy;

    final xIngredientEnergy1 = ingredient1.energy * ingredientCount1;
    ingredientEnergy1 = xIngredientEnergy1;
    final xIngredientEnergy2 = ingredient2.energy * ingredientCount2;
    ingredientEnergy2 = xIngredientEnergy2;
    final xIngredientEnergy3 = ingredient3.energy * ingredientCount3;
    ingredientEnergy3 = xIngredientEnergy3;
    final ingredientEnergySum = xIngredientEnergy1 + xIngredientEnergy2 + xIngredientEnergy3;
    final xIngredientEnergyAvg = (ingredientEnergySum / 3).round();
    ingredientEnergyAvg = xIngredientEnergyAvg;

    final xIngredientRate = _calcIngredientRate();
    ingredientRate = xIngredientRate;

    final xTotalHelpSpeedS = _calcTotalHelpSpeedS();
    totalHelpSpeedS = xTotalHelpSpeedS;
    final xTotalHelpSpeedM = _calcTotalHelpSpeedM();
    totalHelpSpeedM = xTotalHelpSpeedM;
    final xCharacterSpeed = _calcCharacterSpeed();
    characterSpeed = xCharacterSpeed;

    final xHelpPerAvgEnergy = (xIngredientEnergyAvg * xIngredientRate + xFruitEnergy * (5 - xIngredientRate)) / 5;
    helpPerAvgEnergy = xHelpPerAvgEnergy;
    final xHelperBonus = _calcHelperBonus();
    helperBonus = xHelperBonus;
    final xSleepExpBonus = _calcSleepExpBonus();
    final xAccelerateVitality = _calcAccelerateVitality();
    final xSkillLevel = _calcSkillLevel();
    final xMainSkillAccelerateVitality = _calcMainSkillAccelerateVitality();

    double calcHelpInterval() {
      final x = xHelperBonus +
          xTotalHelpSpeedS +
          xTotalHelpSpeedM +
          xCharacterSpeed +
          xAccelerateVitality +
          xMainSkillAccelerateVitality;
      final y = 1 - (x + 59 * 0.002);
      final z = basicProfile.helpInterval * y;

      return z.clamp(0, double.infinity);
    }
    final xHelpInterval = calcHelpInterval();

    double calcMaxOverflowHoldCount() {
      var res = 0.0;

      final x = ((ingredientCount1 + ingredientCount2 + ingredientCount3) * xIngredientRate) / 3 +
          ((5 - xIngredientRate) * _calcFruitCount());
      final y = (30600 / xHelpInterval).round();
      res += x * y;

      res -= (
          basicProfile.boxCount +
              6 * _getSubSkillsCountMatch(SubSkill.s13) +
              12 * _getSubSkillsCountMatch(SubSkill.s12) +
              18 * _getSubSkillsCountMatch(SubSkill.s11)
      );

      return res;
    }

    final xMaxOverflowHoldCount = calcMaxOverflowHoldCount();

    double calcOverflowHoldEnergy() {
      var overflowHoldEnergy = 0.0;

      if (xMaxOverflowHoldCount * xHelpPerAvgEnergy > 0) {
        overflowHoldEnergy = xMaxOverflowHoldCount * (xIngredientRate / 5);
      }
      overflowHoldEnergy *= (ingredient1.energy + ingredient2.energy + ingredient3.energy) / 3;
      // TODO: 有要除兩次3? 怪怪的
      overflowHoldEnergy /= 3.0;

      return overflowHoldEnergy.roundToDouble();
    }

    final xMainSkillSpeedParameter = _calcMainSkillSpeedParameter();

    final res = {
      '幫手獎勵': xHelperBonus,
      '幫忙速度S': xTotalHelpSpeedS,
      '幫忙速度M': xTotalHelpSpeedM,
      '食材機率': xIngredientRate,
      '技能等級': _calcSkillLevel(),
      '主技能速度參數': xMainSkillSpeedParameter,
      '持有上限溢出數': xMaxOverflowHoldCount,
      '持有上限溢出能量': calcOverflowHoldEnergy(),
      '性格速度': xCharacterSpeed,
      '活力加速': xAccelerateVitality,
      '睡眠EXP獎勵': xSleepExpBonus,
      '夢之碎片獎勵': _calcDreamChipsBonus(),
      '主技能': basicProfile.mainSkill.name,
      '主技能能量': _calcMainSkillTotalEnergy(),
      '主技活力加速': xMainSkillAccelerateVitality,
    };

    var result = '${basicProfile.nameI18nKey}\n'
        '性格: ${character.name}\n'
        '食材:\n'
        '    ${ingredient1.nameI18nKey} ($ingredientCount1)\n'
        '    ${ingredient2.nameI18nKey} ($ingredientCount2)\n'
        '    ${ingredient3.nameI18nKey} ($ingredientCount3)\n'
        '類型: ${basicProfile.sleepType.name} (${basicProfile.fruit.nameI18nKey}) \n'
        '數量: $xFruitCount\n'
        '幫忙均能/次: $xHelpPerAvgEnergy\n'
        '類型: ${basicProfile.sleepType.name}\n'
        '樹果: ${basicProfile.fruit.nameI18nKey}\n'
        '數量: $xFruitCount\n'
        '幫忙間隔: $xHelpInterval\n'
        '樹果能量: $xFruitEnergy\n'
        '食材均能: $xIngredientEnergyAvg\n';

  }

  double ingredientRate = 0;
  int ingredientEnergy1 = 0;
  int ingredientEnergy2 = 0;
  int ingredientEnergy3 = 0;
  int ingredientEnergyAvg = 0;
  int xIngredientEnergyAvg = 0;
  double helpPerAvgEnergy = 0.0;
  int fruitEnergy = 0;
  int helperBonus = 0;
  double totalHelpSpeedS = 0;
  double totalHelpSpeedM = 0;
  double characterSpeed = 0;

  final PokemonProfile profile;
  PokemonBasicProfile get basicProfile => profile.basicProfile;
  PokemonCharacter get character => profile.character;
  get subSkills => profile.subSkills;
  Ingredient get ingredient1 => profile.ingredient1;
  Ingredient get ingredient2 => profile.ingredient2;
  Ingredient get ingredient3 => profile.ingredient3;
  int get ingredientCount1 => profile.ingredientCount1;
  int get ingredientCount2 => profile.ingredientCount2;
  int get ingredientCount3 => profile.ingredientCount3;
  SubSkill get subSkillLv10 => profile.subSkillLv10;
  SubSkill get subSkillLv25 => profile.subSkillLv25;
  SubSkill get subSkillLv50 => profile.subSkillLv50;
  SubSkill get subSkillLv75 => profile.subSkillLv75;
  SubSkill get subSkillLv100 => profile.subSkillLv100;

  int _calcFruitCount() =>
      1 + _getSubSkillsCountMatch(SubSkill.s1) +
          _getOneIfSleepTypeIs(PokemonSleepType.t3);

  int _calcHelperBonus() =>
      15 * _getSubSkillsCountMatch(SubSkill.s2);

  double _calcTotalHelpSpeedS() =>
      0.07 * _getSubSkillsCountMatch(SubSkill.s4);

  double _calcTotalHelpSpeedM() =>
      0.14 * _getSubSkillsCountMatch(SubSkill.s3);

  double _calcIngredientRate() =>
      1.0 + 0.18 * _getSubSkillsCountMatch(SubSkill.s6)
          + 0.36 * _getSubSkillsCountMatch(SubSkill.s5)
          + 0.2 * _getOneIf(character.positive == '食材發現')
          - 0.2 * _getOneIf(character.negative == '食材發現');

  int _calcSkillLevel() =>
      _getSubSkillsCountMatch(SubSkill.s8)
          + 2 * _getSubSkillsCountMatch(SubSkill.s7);

  double _calcMainSkillSpeedParameter() =>
      0.0 + 0.2 * _getOneIf(character.positive == '主技能')
          - 0.2 * _getOneIf(character.negative == '主技能')
          + 0.18 * _getSubSkillsCountMatch(SubSkill.s10)
          + 0.36 * _getSubSkillsCountMatch(SubSkill.s9);

  /// 性格速度
  double _calcCharacterSpeed() => 0.1 * _getOneIf(character.positive == '幫忙速度')
      - 0.1 * _getOneIf(character.negative == '幫忙速度');

  /// 活力加速
  /// FIXME: 需確認 1.12? 1.02? (試算表公式是用 0.02)
  double _calcAccelerateVitality() => 0.02 * _getSubSkillsCountMatch(SubSkill.s14)
      + 0.1 * _getOneIf(character.positive == '活力回復')
      - 0.1 * _getOneIf(character.negative == '活力回復');

  /// 睡眠EXP獎勵
  int _calcSleepExpBonus() =>
      1000 * _getSubSkillsCountMatch(SubSkill.s15);

  /// 夢之碎片獎勵
  int _calcDreamChipsBonus() =>
      500 * _getSubSkillsCountMatch(SubSkill.s17);

  double _calcMainSkillAccelerateVitality() {
    var res = 0.0;

    if (_isMainSkillIn(['活力填充S', '活力療癒S', '活力全體療癒S'])) {
      res += (0.015 * _getMainSkillEnergy()) *
          (1 + _calcMainSkillSpeedParameter());
    }

    return res;
  }

  int _calcMainSkillTotalEnergy() {
    if (_isMainSkillIn(['活力填充S', '活力療癒S', '活力全體療癒S'])) {
      return 0;
    }

    final res = _getMainSkillEnergy() * (1 + _calcMainSkillSpeedParameter());
    return res.round();
  }

  // region Utils
  double _getMainSkillEnergy() {
    final valueIndex = _getMainSkillEnergyIndex();
    final basicEnergy = basicProfile.mainSkill.calcEnergyList()[valueIndex];
    return basicEnergy;
  }

  int _getMainSkillEnergyIndex() {
    return basicProfile.evolutionMaxCount + _calcSkillLevel() - 1;
  }

  bool _isMainSkillIn(List<String> skillNames) {
    for (final skillName in skillNames) {
      if (basicProfile.mainSkill.name == skillName) {
        return true;
      }
    }
    return false;
  }

  int _getSubSkillsCountMatch(SubSkill targetValue) => subSkills
      .where((skill) => skill == targetValue)
      .length;

  int _getOneIfSleepTypeIs(PokemonSleepType sleepType) =>
      basicProfile.sleepType == sleepType ? 1 : 0;

  int _getOneIf(bool value) => value ? 1 : 0;
  // endregion

}