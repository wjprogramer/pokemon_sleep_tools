import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonProfileStatistics {
  PokemonProfileStatistics._(this.profile);

  factory PokemonProfileStatistics.from(PokemonProfile profile) {
    return PokemonProfileStatistics._(profile);
  }

  void init() {
    final xFruitCount = _calcFruitCount();
    fruitCount = xFruitCount;
    final xFruitEnergy = xFruitCount * basicProfile.fruit.energyIn60;
    fruitEnergy = xFruitEnergy;
    final xMainSkillEnergy = _getMainSkillEnergy();

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
    final xMainSkillSpeedParameter = _calcMainSkillSpeedParameter();
    mainSkillSpeedParameter = xMainSkillSpeedParameter;

    double calcMainSkillAccelerateVitality() {
      if (_isMainSkillIn(['活力填充S', '活力療癒S', '活力全體療癒S'])) {
        return (0.015 * xMainSkillEnergy) * (1 + xMainSkillSpeedParameter);
      }

      return 0.0;
    }

    final xHelpPerAvgEnergy = (xIngredientEnergyAvg * xIngredientRate + xFruitEnergy * (5 - xIngredientRate)) / 5;
    helpPerAvgEnergy = xHelpPerAvgEnergy;
    final xHelperBonus = _calcHelperBonus();
    helperBonus = xHelperBonus;
    final xSleepExpBonus = _calcSleepExpBonus();
    sleepExpBonus = xSleepExpBonus;
    final xAccelerateVitality = _calcAccelerateVitality();
    accelerateVitality = xAccelerateVitality;
    final xSkillLevel = _calcSkillLevel();
    skillLevel = xSkillLevel;
    final xMainSkillAccelerateVitality = calcMainSkillAccelerateVitality();
    mainSkillAccelerateVitality = xMainSkillAccelerateVitality;

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
    /// FIXME: xHelpInterval.clamp(1, double.infinity) 須修正，研究為何等於0
    final xHelpInterval = calcHelpInterval().clamp(1.0, double.infinity);
    helpInterval = xHelpInterval;

    double calcMaxOverflowHoldCount() {
      var res = 0.0;

      final x = ((ingredientCount1 + ingredientCount2 + ingredientCount3) * xIngredientRate) / 3 +
          ((5 - xIngredientRate) * xFruitCount);
      final y = (30600 / xHelpInterval).round();
      res += x * y;

      res -= (
          basicProfile.boxCount +
              6 * _getSubSkillsCountMatch(SubSkill.holdMaxS) +
              12 * _getSubSkillsCountMatch(SubSkill.holdMaxM) +
              18 * _getSubSkillsCountMatch(SubSkill.holdMaxL)
      );

      return res;
    }

    final xMaxOverflowHoldCount = calcMaxOverflowHoldCount();
    maxOverflowHoldCount = xMaxOverflowHoldCount;

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

    double calcMainSkillTotalEnergy() {
      if (_isMainSkillIn(['活力填充S', '活力療癒S', '活力全體療癒S'])) {
        return 0;
      }
      return xMainSkillEnergy * (1 + xMainSkillSpeedParameter);
    }

    final xDreamChipsBonus = _calcDreamChipsBonus();
    dreamChipsBonus = xDreamChipsBonus;
    final xOverflowHoldEnergy = calcOverflowHoldEnergy();
    overflowHoldEnergy = xOverflowHoldEnergy;

    final xMainSkillTotalEnergy = calcMainSkillTotalEnergy().round();
    mainSkillTotalEnergy = xMainSkillTotalEnergy;

    final xEnergyScore = (60000 / xHelpInterval) * helpPerAvgEnergy +
        xMainSkillTotalEnergy - xOverflowHoldEnergy + xSleepExpBonus + xDreamChipsBonus;
    energyScore = xEnergyScore.round();



    rank = xEnergyScore < 6000 ? 'E'
        : xEnergyScore < 7000 ? 'D'
        : xEnergyScore < 8000 ? 'C'
        : xEnergyScore < 9000 ? 'B'
        : xEnergyScore < 10000 ? 'A'
        : xEnergyScore < 12000 ? 'S'
        : xEnergyScore < 14000 ? 'SS'
        : 'SSS';

    if (basicProfile.mainSkill == MainSkill.dreamChipS || basicProfile.mainSkill == MainSkill.energyFillSn) {
      rank = '夢$rank';
    }

    rank;
  }

  int fruitCount = 0;
  double helpInterval = 0;
  double ingredientRate = 0;
  int ingredientEnergy1 = 0;
  int ingredientEnergy2 = 0;
  int ingredientEnergy3 = 0;
  int ingredientEnergyAvg = 0;
  double helpPerAvgEnergy = 0.0;
  int fruitEnergy = 0;
  int helperBonus = 0;
  double totalHelpSpeedS = 0;
  double totalHelpSpeedM = 0;
  double characterSpeed = 0;
  int skillLevel = 0;
  double mainSkillSpeedParameter = 0;
  int sleepExpBonus = 0;
  double accelerateVitality = 0;
  int dreamChipsBonus = 0;
  int mainSkillTotalEnergy = 0;
  double mainSkillAccelerateVitality = 0;
  double maxOverflowHoldCount = 0;
  double overflowHoldEnergy = 0;
  int energyScore = 0;
  String rank = '';

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
      1 + _getSubSkillsCountMatch(SubSkill.berryCountS) +
          _getOneIfSpecialtyIs(PokemonSpecialty.t3);

  int _calcHelperBonus() =>
      15 * _getSubSkillsCountMatch(SubSkill.helperBonus);

  double _calcTotalHelpSpeedS() =>
      0.07 * _getSubSkillsCountMatch(SubSkill.helpSpeedS);

  double _calcTotalHelpSpeedM() =>
      0.14 * _getSubSkillsCountMatch(SubSkill.helpSpeedM);

  double _calcIngredientRate() =>
      1.0 + 0.18 * _getSubSkillsCountMatch(SubSkill.ingredientRateS)
          + 0.36 * _getSubSkillsCountMatch(SubSkill.ingredientRateM)
          + 0.2 * _getOneIf(character.positive == '食材發現')
          - 0.2 * _getOneIf(character.negative == '食材發現');

  int _calcSkillLevel() =>
      _getSubSkillsCountMatch(SubSkill.skillLevelS)
          + 2 * _getSubSkillsCountMatch(SubSkill.skillLevelM);

  double _calcMainSkillSpeedParameter() =>
      0.0 + 0.2 * _getOneIf(character.positive == '主技能')
          - 0.2 * _getOneIf(character.negative == '主技能')
          + 0.18 * _getSubSkillsCountMatch(SubSkill.skillRateS)
          + 0.36 * _getSubSkillsCountMatch(SubSkill.skillRateM);

  /// 性格速度
  double _calcCharacterSpeed() => 0.1 * _getOneIf(character.positive == '幫忙速度')
      - 0.1 * _getOneIf(character.negative == '幫忙速度');

  /// 活力加速
  /// FIXME: 需確認 1.12? 1.02? (試算表公式是用 0.02)
  double _calcAccelerateVitality() => 0.02 * _getSubSkillsCountMatch(SubSkill.energyRecoverBonus)
      + 0.1 * _getOneIf(character.positive == '活力回復')
      - 0.1 * _getOneIf(character.negative == '活力回復');

  /// 睡眠EXP獎勵
  int _calcSleepExpBonus() =>
      1000 * _getSubSkillsCountMatch(SubSkill.sleepExpBonus);

  /// 夢之碎片獎勵
  int _calcDreamChipsBonus() =>
      500 * _getSubSkillsCountMatch(SubSkill.dreamChipBonus);

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
      if (basicProfile.mainSkill.nameI18nKey == skillName) {
        return true;
      }
    }
    return false;
  }

  int _getSubSkillsCountMatch(SubSkill targetValue) => subSkills
      .where((skill) => skill == targetValue)
      .length;

  int _getOneIfSpecialtyIs(PokemonSpecialty specialty) =>
      basicProfile.specialty == specialty ? 1 : 0;

  int _getOneIf(bool value) => value ? 1 : 0;
  // endregion

}