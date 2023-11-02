import 'package:pokemon_sleep_tools/data/models/models.dart';

class ProfileStatisticsResult {
  ProfileStatisticsResult(this.profile, this.rankLv50, this.rankLv100);

  final String rankLv50;
  final String rankLv100;
  final PokemonProfile profile;
}

enum _Type {
  dev,
  userView,
}

/// 運算公式來源：「https://bbs.nga.cn/read.php?tid=37305277」
///
/// 原來源問題
///
/// - 部分主技能發動次數欄位為 `次數/h`，但實際上是 `次數/d`
///
class PokemonProfileStatistics {
  PokemonProfileStatistics(this.profiles, {
    this.level = 25,
    this.isSnorlaxFavorite = false,
    this.useSnorlaxFavorite = false,
  });

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<ProfileStatisticsResult>? _results;
  List<ProfileStatisticsResult>? get results => _results;

  // Profile properties
  final List<PokemonProfile> profiles;

  /// 全部 profile 會用同樣等級
  final int level;

  /// 卡比獸喜愛的果子 (之後要根據實際島嶼計算)
  final bool isSnorlaxFavorite;

  /// 是否考慮卡比獸喜愛的果子
  ///
  /// 因為有沒有考慮、和是不是喜愛的果子 ([isSnorlaxFavorite]) 是不同事情，
  /// 怕未來會有計算上的考量差異，因此先區分兩者參數
  final bool useSnorlaxFavorite;

  // 其他
  // 計算基準（可由使用者設定）
  // D 活力檔位
  final _userVitality = 4;
  /// 主技能等級
  // FW
  final _mainSkillLv = 3;

  List<dynamic> calcForDev() {
    return [];
    // return _calc(_Type.dev);
  }

  List<ProfileStatisticsResult> calcForUser() {
    _results = _calc(_Type.userView);
    return _results as List<ProfileStatisticsResult>;
  }

  dynamic _calc(_Type type) {
    // NOTES:
    // - Lv 50 與 Lv 100 的狀況下都是假設進化到最終階段

    final statistics = profiles.map((profile) => _PokemonProfileStatisticsAtLevel(
      profile: profile,
      isSnorlaxFavorite: useSnorlaxFavorite && isSnorlaxFavorite,
      vitality: _userVitality,
      baseHelpInterval: level >= 50 ? profile.helpIntervalAtMaxStage : profile.helpInterval,
      mainSkillLv: _mainSkillLv,
      level: level,
    )).toList();

    // Step1
    final baseResults = statistics
        .map((statistic) => statistic.calc1())
        .toList();

    _isInitialized = true;

    return;
  }
  
}

enum StatisticsLevelType {
  levelCustom,
  level100,
  level50,
}

class _PokemonProfileStatisticsAtLevel {
  _PokemonProfileStatisticsAtLevel({
    required this.profile,
    required this.level,
    required this.isSnorlaxFavorite,
    required this.baseHelpInterval,
    required this.mainSkillLv,
    required this.vitality,
    this.useHelper = false,
  }): type = level > 99 ? StatisticsLevelType.level100
      : level > 49 ? StatisticsLevelType.level50
      : StatisticsLevelType.levelCustom;

  final PokemonProfile profile;
  final StatisticsLevelType type;
  final int level;
  final bool isSnorlaxFavorite;

  /// 帳面上的幫忙間隔
  final int baseHelpInterval;
  final int mainSkillLv;
  final int vitality;

  /// 是否需要考慮幫手
  final bool useHelper;

  // 在 sheet 上為常數
  // $AM$4
  static const _AM_4 = 0.2;
  // $AL$4
  static const _AL_4 = 0.25;

  /// 碎片估算係數 (使用者可自由設定)
  final _shardsCoefficient = 5;
  /// 食材估平均 (使用者可自由設定)
  final _ingredientAvg = 110.0;
  final _ingredientAvgLv50 = 135.0;
  final _ingredientAvgLv100 = 135.0;
  
  // region Getters
  PokemonBasicProfile get basicProfile => profile.basicProfile;
  // endregion

  StatisticsBaseResult calc1() {
    // region TODO: 改為計算
    /// (幫手計算) 出场平均估分，試算表上說
    /// 手動計算「选上你要上场的五只高分宝可梦「自身收益」平均数。」
    /// TODO: 在隊伍分析頁面中，使用自動計算

    // 出場平均估分
    final _helperAvgScore = 226.0;
    final _helperAvgScoreLv50 = 815.0;
    final _helperAvgScoreLv100 = 2333.0;

    // 幫手計算估分
    final gy4 = _helperAvgScoreLv50 * 5 * 0.05;
    final ha4 = _helperAvgScoreLv100 * 5 * 0.05;
    final o4 = _helperAvgScore * 5 * 0.05 * (useHelper ? 1 : 0);
    // endregion

    // 樹果能量/顆
    final fruitEnergy = _getSingleFruitEnergy(level);
    // 樹果能量/顆: +副技能加成
    final fruitBonusEnergy = _subSkillsContains(SubSkill.berryCountS, level) ? fruitEnergy : 0.0;
    // 樹果能量/顆: +專長、技能加成
    final fruitEnergyAfterSpecialtyAndSubSkill = fruitEnergy * (profile.isBerrySpecialty ? 2 : 1) + fruitBonusEnergy;
    // 樹果能量/顆: +卡比獸喜愛加成
    final fruitEnergyAfterSnorlaxFavorite = fruitEnergyAfterSpecialtyAndSubSkill * (isSnorlaxFavorite ? 2 : 1);

    // 副技能: 幫忙速度 S+M
    final helpSpeedSM = 1.0
        - (_subSkillsContains(SubSkill.helpSpeedS, level) ? 0.07: 0)
        - (_subSkillsContains(SubSkill.helpSpeedM, level) ? 0.14: 0);
    // 副技能: 食材機率 S+M
    final ingredientSM = 1.0
        + (_subSkillsContains(SubSkill.ingredientRateS, level) ? 0.18 : 0)
        + (_subSkillsContains(SubSkill.ingredientRateM, level) ? 0.36 : 0);
    // 副技能: 技能機率 S+M
    final skillRateSM = 1.0
        + (_subSkillsContains(SubSkill.skillRateM, level) ? 0.36 : 0)
        + (_subSkillsContains(SubSkill.skillRateS, level) ? 0.18 : 0);
    // 食材機率
    const baseIngredientRate = 0.2; // TODO: 感覺應該根據 BasicProfile 的食材機率
    final ingredientRate = _tc(() => baseIngredientRate * ingredientSM
        * (
            profile.character.positive == '食材發現' ? 1.2
                : profile.character.negative == '食材發現' ? 0.8
                : 1.0
        ),
    );
    // 樹果機率
    final fruitRate = 1 - ingredientRate;
    // 加成後的主技能等級
    final finalMainSkillLevel = mainSkillLv
        + (_subSkillsContains(SubSkill.skillLevelM, level) ? 2 : 0)
        + (_subSkillsContains(SubSkill.skillLevelS, level) ? 1 : 0)
        + (type == StatisticsLevelType.levelCustom ? 0 : (
            3 - _tc(() => profile.basicProfile.currentEvolutionStage, defaultValue: 3)
        ));

    // ## 幫忙間隔
    // 等級調整
    final helpIntervalWithLevel = _tc(() => baseHelpInterval - (baseHelpInterval * ((level - 1) * 0.002)));
    // 等級+性格+技能調整
    final helpIntervalWithLevelCharacterSkill = helpIntervalWithLevel * helpSpeedSM * (
        profile.character.positive == '幫忙速度' ? 0.9
            : profile.character.negative == '幫忙速度' ? 1.1
            : 1.0
    );
    // 等級+性格+技能+活力調整
    final finalHelpInterval = helpIntervalWithLevelCharacterSkill * _transUserVitality();
    // (白板) 等級+活力調整
    final pureHelpIntervalWithLevelVitality = helpIntervalWithLevel * _transUserVitality();

    // (加成後) 果實預期次數/h
    final fruitCountPerHour = _tc(() => 3600 / finalHelpInterval * fruitRate);
    // (白板計算) 果實預期次數/h
    final pureFruitCountPerHour = _tc(() => 3600 / pureHelpIntervalWithLevelVitality * fruitRate);

    // (加成後) 食材預期次數/h
    final ingredientCountPerHour = _tc(() => 3600/ finalHelpInterval * ingredientRate);
    // (白板計算) 食材預期次數/h
    final pureIngredientCountPerHour = _tc(() => 3600/ pureHelpIntervalWithLevelVitality * ingredientRate);

    final useIngredientCount = (level > 59 ? 3 : (level > 29 ? 2 : 1));
    // (加成後) 食材1個數/h
    final ingredientCount1PerHour =
        ingredientCountPerHour * (profile.isIngredientSpecialty ? 2 : 1)
            / useIngredientCount;
    // (白板) 食材1個數/h
    final pureIngredientCount1PerHour =
        pureIngredientCountPerHour * (profile.isIngredientSpecialty ? 2 : 1)
            / useIngredientCount;

    // (加成後) 食材2個數/h
    final ingredientCount2PerHour = level < 30 ? 0.0 : (
        ingredientCountPerHour * profile.ingredientCount2
            / useIngredientCount
    );
    // (白板) 食材2個數/h
    final pureIngredientCount2PerHour = level < 30 ? 0.0 : (
        pureIngredientCountPerHour * profile.ingredientCount2
            / useIngredientCount
    );

    // (加成後) 食材3個數/h
    final ingredientCount3PerHour = level < 60 ? 0.0 : (
        ingredientCountPerHour * profile.ingredientCount3
            / useIngredientCount
    );
    // (白板) 食材3個數/h
    final pureIngredientCount3PerHour = level < 60 ? 0.0 : (
        pureIngredientCountPerHour * profile.ingredientCount3
            / useIngredientCount
    );

    // (收益) 食材個/h
    final totalIngredientCountPerHour = ingredientCount1PerHour + ingredientCount2PerHour + ingredientCount3PerHour;
    // (白板收益) 食材個/h
    final pureTotalIngredientCountPerHour = pureIngredientCount1PerHour + pureIngredientCount2PerHour + pureIngredientCount3PerHour;

    // (收益) 樹果能量/h
    final fruitEnergyPerHour = fruitCountPerHour * fruitEnergyAfterSnorlaxFavorite;

    // (收益) 食材能量/h
    final totalIngredientEnergyPerHour =
        ingredientCount1PerHour * profile.ingredient1.energy
            + ingredientCount2PerHour * profile.ingredient2.energy
            + ingredientCount3PerHour * profile.ingredient3.energy;

    // (白板收益) 樹果能量/h
    final pureFruitEnergyPerHour = fruitEnergy
        * pureFruitCountPerHour
        * (profile.isBerrySpecialty ? 2 : 1)
        * (isSnorlaxFavorite ? 2 : 1);

    // (白板收益) 食材能量/h
    final pureIngredientEnergyPerHour =
        pureIngredientCount1PerHour * profile.ingredient1.energy
            + pureIngredientCount2PerHour * profile.ingredient2.energy
            + pureIngredientCount3PerHour * profile.ingredient3.energy;

    // (收益) 技能次數/d
    // 原有欄位是 V、CK、DI，確認了很多次，「當前等級」和「Lv50,Lv100」的算法不同
    //
    // 包含
    //
    // - 前者不參考活力
    // - 專長影響程度不同
    // - AM4 前者用乘法後者用加法
    final skillActivateCountPerDay = _tc(() {
      final xxx = profile.character.negative == '主技能' ? 0.8
          : profile.character.positive == '主技能' ? 1.2
          : 1;

      switch (type) {
        case StatisticsLevelType.levelCustom:
          return skillRateSM * 3600 / helpIntervalWithLevelCharacterSkill * xxx
              + (profile.isSkillSpecialty ? 0.5 : 0)
              + _AL_4 * (finalMainSkillLevel - 1)
              + (profile.basicProfile.currentEvolutionStage - 2) * _AM_4;
        case StatisticsLevelType.level100:
        case StatisticsLevelType.level50:
          return skillRateSM * 3600 / helpIntervalWithLevelCharacterSkill * _transUserVitality() * xxx
              + (profile.isSkillSpecialty ? 0.2 : 0)
              + _AL_4 * (finalMainSkillLevel - 1)
              + _AM_4;
      }
    });

    // (白板收益) 次數/h
    final pureSkillActivateCountPerHour = _tc(() {
      switch (type) {
        case StatisticsLevelType.levelCustom:
          return 3600 / helpIntervalWithLevel
              + (profile.isSkillSpecialty ? 0.2 : 0.0)
              + 0.25 // 不知道哪裡來的數字，原表單沒有給固定欄列
                  * (mainSkillLv - 1)
              + _AM_4 * (profile.basicProfile.currentEvolutionStage - 2);
        case StatisticsLevelType.level100:
        case StatisticsLevelType.level50:
        return 3600 / pureHelpIntervalWithLevelVitality * _transUserVitality()
            + (profile.isSkillSpecialty ? 0.2 : 0)
            + _AL_4 * (mainSkillLv + 3 - _tc(() => profile.basicProfile.currentEvolutionStage, defaultValue: 3)  - 1 + _AM_4);
      }
    });

    // (加成後) 主技能效益/h
    final mainSkillBenefitPerHour = (() {
      return _tc(() {
        final xx = _calcMainSkillEnergyList(profile.basicProfile.mainSkill, helperAvgScore: 0)[finalMainSkillLevel.toInt() - 1];

        return profile.basicProfile.mainSkill == MainSkill.vitalityFillS
            ? xx * (fruitEnergyPerHour + totalIngredientEnergyPerHour)
            : xx;
      }) * skillActivateCountPerDay;
    })();

    // (白板) 主技能效益/h
    final pureMainSkillBenefitPerHour = (() {
      final xx = _calcMainSkillEnergyList(basicProfile.mainSkill, helperAvgScore: 0);
      
      switch (type) {
        case StatisticsLevelType.levelCustom:
          return _tc(() {
            final yy = xx[mainSkillLv - 1];

            return basicProfile.mainSkill == MainSkill.vitalityFillS
                ? yy * (pureFruitEnergyPerHour + pureIngredientEnergyPerHour)
                : yy;
          }) * pureSkillActivateCountPerHour;
        case StatisticsLevelType.level50:
          return _tc(() {
            final yy = xx[(mainSkillLv + 3 - basicProfile.currentEvolutionStage).toInt() - 1];

            return basicProfile.mainSkill == MainSkill.vitalityFillS
                ? yy * (pureFruitEnergyPerHour + pureIngredientEnergyPerHour)
                : yy;
          }) * pureSkillActivateCountPerHour;
        case StatisticsLevelType.level100:
          return _tc(() {
            final yy = xx[(mainSkillLv + 3 - basicProfile.currentEvolutionStage).toInt() - 1];

            return basicProfile.mainSkill == MainSkill.vitalityFillS
                ? yy * (pureFruitEnergyPerHour + pureIngredientEnergyPerHour)
                : yy;
          }) * pureSkillActivateCountPerHour;
      }
    })();

    // (加成後) 自身收益/h
    final totalSelfBenefitPerHour = (() {
      final xxy = basicProfile.mainSkill == MainSkill.vitalityAllS ||
          basicProfile.mainSkill == MainSkill.vitalityS;

      return _tc(() => fruitEnergyPerHour
          + totalIngredientEnergyPerHour
          + mainSkillBenefitPerHour * (xxy ? 0 : 1)
          + (profile.hasSubSkillAtLevel(SubSkill.helperBonus, level) ? o4 / 5 : 0)
      );
    })();
    
    // 食材換算成碎片/h
    final ingredientShardsPerHour = ingredientCount1PerHour * _getIngredientPrice(profile.ingredient1)
        + ingredientCount2PerHour * _getIngredientPrice(profile.ingredient2)
        + ingredientCount3PerHour * _getIngredientPrice(profile.ingredient3);

    // 白板收益/h
    final pureTotalBenefitPerHour = pureFruitEnergyPerHour
        + pureIngredientEnergyPerHour
        + pureMainSkillBenefitPerHour;

    final xy = switch (type) {
      StatisticsLevelType.levelCustom => o4,
      StatisticsLevelType.level100 => gy4,
      StatisticsLevelType.level50 => ha4,
    };

    // 理想總收益/h
    final idealTotalBenefit = _tc(() =>
    fruitEnergyPerHour
        + totalIngredientEnergyPerHour
        + mainSkillBenefitPerHour
        + (profile.hasSubSkillAtLevel(SubSkill.helperBonus, level) ? xy : 0)
    );

    // 輔助隊友收益/h
    final helpTeammateBenefitPerHour = idealTotalBenefit - totalSelfBenefitPerHour;

    // 性格技能影響
    final diffEffectTotalBenefit = pureTotalBenefitPerHour == 0
        ? 0.0
        : (idealTotalBenefit - pureTotalBenefitPerHour) / pureTotalBenefitPerHour;

    // 評級, Rank
    String rank;
    if (pureTotalBenefitPerHour == 0) {
      rank = '-';
    } else {
      if (level < 50) {
        rank = pureTotalBenefitPerHour >= 0.3 ? 'S' :
        pureTotalBenefitPerHour >= 0.24 ? 'A' :
        pureTotalBenefitPerHour >= 0.18 ? 'B' :
        pureTotalBenefitPerHour >= 0.12 ? 'C' :
        pureTotalBenefitPerHour >= 0.06 ? 'D' :
        pureTotalBenefitPerHour >= 0 ? 'E' :
        pureTotalBenefitPerHour < 0 ? 'F' : '-';
      } else if (level < 100) {
        rank = pureTotalBenefitPerHour >= 1 ? 'S' :
        pureTotalBenefitPerHour >= 0.8 ? 'A' :
        pureTotalBenefitPerHour >= 0.6 ? 'B' :
        pureTotalBenefitPerHour >= 0.4 ? 'C' :
        pureTotalBenefitPerHour >= 0.2 ? 'D' :
        pureTotalBenefitPerHour >= 0 ? 'E' :
        pureTotalBenefitPerHour < 0 ? 'F' : '-';
      } else {
        rank =  pureTotalBenefitPerHour >= 1.5 ? 'S+' :
        pureTotalBenefitPerHour >= 1 ? 'S' :
        pureTotalBenefitPerHour >= 0.8 ? 'A' :
        pureTotalBenefitPerHour >= 0.6 ? 'B' :
        pureTotalBenefitPerHour >= 0.4 ? 'C' :
        pureTotalBenefitPerHour >= 0.2 ? 'D' :
        pureTotalBenefitPerHour >= 0 ? 'E' :
        pureTotalBenefitPerHour < 0 ? 'F' : '-';
      }
    }

    return StatisticsBaseResult(
      fruitEnergy: fruitEnergy,
      fruitBonusEnergy: fruitBonusEnergy,
      fruitEnergyAfterSpecialtyAndSubSkill: fruitEnergyAfterSpecialtyAndSubSkill,
      fruitEnergyAfterSnorlaxFavorite: fruitEnergyAfterSnorlaxFavorite,
      helpSpeedSM: helpSpeedSM,
      ingredientSM: ingredientSM,
      skillRateSM: skillRateSM,
      ingredientRate: ingredientRate,
      fruitRate: fruitRate,
      finalMainSkillLevel: finalMainSkillLevel.toInt(),
      helpIntervalWithLevel: helpIntervalWithLevel,
      helpIntervalWithLevelCharacterSkill: helpIntervalWithLevelCharacterSkill,
      finalHelpInterval: finalHelpInterval,
      pureHelpIntervalWithLevelVitality: pureHelpIntervalWithLevelVitality,
      fruitCountPerHour: fruitCountPerHour,
      pureFruitCountPerHour: pureFruitCountPerHour,
      ingredientCountPerHour: ingredientCountPerHour,
      pureIngredientCountPerHour: pureIngredientCountPerHour,
      ingredientCount1PerHour: ingredientCount1PerHour,
      pureIngredientCount1PerHour: pureIngredientCount1PerHour,
      ingredientCount2PerHour: ingredientCount2PerHour,
      pureIngredientCount2PerHour: pureIngredientCount2PerHour,
      ingredientCount3PerHour: ingredientCount3PerHour,
      pureIngredientCount3PerHour: pureIngredientCount3PerHour,
      totalIngredientCountPerHour: totalIngredientCountPerHour,
      pureTotalIngredientCountPerHour: pureTotalIngredientCountPerHour,
      fruitEnergyPerHour: fruitEnergyPerHour,
      totalIngredientEnergyPerHour: totalIngredientEnergyPerHour,
      pureFruitEnergyPerHour: pureFruitEnergyPerHour,
      pureIngredientEnergyPerHour: pureIngredientEnergyPerHour,
      skillActivateCountPerDay: skillActivateCountPerDay,
      pureSkillActivateCountPerHour: pureSkillActivateCountPerHour,
      ingredientShardsPerHour: ingredientShardsPerHour,
      mainSkillBenefitPerHour: mainSkillBenefitPerHour,
      pureMainSkillBenefitPerHour: pureMainSkillBenefitPerHour,
      totalBenefitPerHour: totalSelfBenefitPerHour,
      pureTotalBenefitPerHour: pureTotalBenefitPerHour,
      idealTotalBenefit: idealTotalBenefit,
      helpTeammateBenefitPerHour: helpTeammateBenefitPerHour,
      diffEffectTotalBenefit: diffEffectTotalBenefit,
      rank: rank,
    );
  }

  StatisticsWithHelpersResult calc2(StatisticsBaseResult baseResult, {
    required double helperAvgScore,
  }) {
    final helperScore = helperAvgScore * 5 * 0.05 * (useHelper ? 1 : 0);

    return StatisticsWithHelpersResult();
  }

  int _getIngredientPrice(Ingredient ingredient) {
    // TODO: NGA 的值如何產的？（他是寫死的）
    return switch (ingredient) {
      Ingredient.i1 => 7,
      Ingredient.i2 => 7,
      Ingredient.i3 => 5,
      Ingredient.i4 => 5,
      Ingredient.i5 => 4,
      Ingredient.i6 => 5,
      Ingredient.i7 => 4,
      Ingredient.i8 => 4,
      Ingredient.i9 => 4,
      Ingredient.i10 => 5,
      Ingredient.i11 => 4,
      Ingredient.i12 => 4,
      Ingredient.i13 => 6,
      Ingredient.i14 => 14,
      Ingredient.i15 => 4,
    };
  }

  /// tryCatch calculating or return 0
  double _tc(num Function() callback, {
    double defaultValue = 0,
  }) {
    try {
      return callback().toDouble();
    } catch (e) {
      return defaultValue;
    }
  }

  /// [level] is 1 ~ 100
  int _getSingleFruitEnergy(int level) {
    assert(level >= 1 && level <= 100);
    return profile.fruit.getLevels()[level - 1];
  }

  bool _subSkillsContains(SubSkill subSkill, int level) {
    return _getSubSkillsByLevel(level).contains(subSkill);
  }

  List<SubSkill> _getSubSkillsByLevel(int level) {
    final count = level >= 100 ? 5
        : level >= 75 ? 4
        : level >= 50 ? 3
        : level >= 25 ? 2
        : level >= 10 ? 1
        : 0;
    return profile.subSkills.take(count).toList();
  }

  double _transUserVitality() {
    return vitality == 5 ? 0.4
        : vitality == 4 ? 0.5
        : vitality == 3 ? 0.6
        : vitality == 2 ? 0.8
        : vitality == 1 ? 1.0
        : 1.0;
  }

  List<double> _calcMainSkillEnergyList(MainSkill mainSkill, {
    // _helperAvgScore
    required double helperAvgScore,
  }) {
    if (level > 99) {
      return _calcMainSkillEnergyListLv100(mainSkill, helperAvgScore: helperAvgScore);
    } else if (level >= 50) {
      return _calcMainSkillEnergyListLv50(mainSkill, helperAvgScore: helperAvgScore);
    } else {
      return _calcMainSkillEnergyListLv1(mainSkill, helperAvgScore: helperAvgScore);
    }
  }

  List<double> _calcMainSkillEnergyListLv1(MainSkill mainSkill, {
    // _helperAvgScore
    required double helperAvgScore,
  }) {
    // _ingredientAvg
    switch (mainSkill) {
      case MainSkill.energyFillS:
        return MainSkill.energyFillS.basicValues.map((e) => e / 24.0).toList();
      case MainSkill.energyFillM:
        return MainSkill.energyFillM.basicValues.map((e) => e / 24.0).toList();
      case MainSkill.energyFillSn:
        final v1 = <double>[200, 285, 393, 542, 748, 1033];
        final v2 = <double>[800, 1138, 1570, 2166, 2992, 4132];
        return List.generate(v1.length, (i) => (v1[i] + v2[i]) / 2.0 / 24.0);
      case MainSkill.dreamChipS:
        return MainSkill.dreamChipS.basicValues.map((e) => e / _shardsCoefficient).toList();
      case MainSkill.dreamChipSn:
        final v1 = [44, 63, 87, 137, 198, 284];
        final v2 = [176 ,250 ,346 ,548 ,790 ,1136];
        return List.generate(v1.length, (i) => (v1[i] + v2[i]) / 2 / _shardsCoefficient).toList();
      case MainSkill.vitalityS:
      // 活力係數，不知怎得的
        final v = [187.197, 233.155, 330.391, 433.691, 598.336, 845.682];
        return v.map((e) => e * helperAvgScore * 0.01 / 24.0).toList();
      case MainSkill.vitalityAllS:
      // 活力係數，不知怎得的
        final v = [61.331, 87.596, 114.851, 143.097, 202.310, 248.886];
        return v.map((e) => e * 5 * helperAvgScore * 0.01 / 24.0).toList();
      case MainSkill.vitalityFillS:
      // 活力係數，不知怎得的
        final v = [157.591, 217.629, 297.277, 398.597, 524.106, 692.877];
        return v.map((e) => e * 0.01 / 24.0).toList();
      case MainSkill.helpSupportS:
        return MainSkill.helpSupportS.basicValues.map((e) => e * _ingredientAvg / 24.0).toList();
      case MainSkill.ingredientS:
        return MainSkill.ingredientS.basicValues.map((e) => e * _ingredientAvg / 24).toList();
      case MainSkill.cuisineS:
      /// TODO: 后期考虑要乘以菜谱加成
        return MainSkill.cuisineS.basicValues.map((e) => e * _ingredientAvg / 24).toList();
      case MainSkill.finger:
        final values = <List<double>>[];
        for (final m in MainSkill.values) {
          if (m == MainSkill.finger || m == MainSkill.vitalityFillS) {
            continue;
          }
          values.add(_calcMainSkillEnergyListLv1(m, helperAvgScore: helperAvgScore));
        }
        return List.generate(6, (i) => values.map((e) => e[i]).reduce((a, b) => a + b) / values.length);
    }
  }

  List<double> _calcMainSkillEnergyListLv50(MainSkill mainSkill, {
    // helperAvgScoreLv50
    required double helperAvgScore,
  }) {
    // 果子估平均
    const fruitAvgConstant = 100.0;

    // _ingredientAvg
    switch (mainSkill) {
      case MainSkill.energyFillS:
        return MainSkill.energyFillS.basicValues.map((e) => e / 24.0).toList();
      case MainSkill.energyFillM:
        return MainSkill.energyFillM.basicValues.map((e) => e / 24.0).toList();
      case MainSkill.energyFillSn:
        final v1 = <double>[200, 285, 393, 542, 748, 1033];
        final v2 = <double>[800, 1138, 1570, 2166, 2992, 4132];
        return List.generate(v1.length, (i) => (v1[i] + v2[i]) / 2.0 / 24.0);
      case MainSkill.dreamChipS:
        return MainSkill.dreamChipS.basicValues.map((e) => e / _shardsCoefficient).toList();
      case MainSkill.dreamChipSn:
        final v1 = [44, 63, 87, 137, 198, 284];
        final v2 = [176 ,250 ,346 ,548 ,790 ,1136];
        return List.generate(v1.length, (i) => (v1[i] + v2[i]) / 2 / _shardsCoefficient).toList();
      case MainSkill.vitalityS:
        // 活力係數，不知怎得的
        final v = [187.197, 233.155, 330.391, 433.691, 598.336, 845.682];
        return v.map((e) => e * helperAvgScore * 0.01 / 24.0).toList();
      case MainSkill.vitalityAllS:
      // 活力係數，不知怎得的
        final v = [61.331, 87.596, 114.851, 143.097, 202.310, 248.886];
        return v.map((e) => e * 5 * helperAvgScore * 0.01 / 24.0).toList();
      case MainSkill.vitalityFillS:
      // 活力係數，不知怎得的
        final v = [157.591, 217.629, 297.277, 398.597, 524.106, 692.877];
        return v.map((e) => e * 0.01 / 24.0).toList();
      case MainSkill.helpSupportS:
        return MainSkill.helpSupportS.basicValues.map((e) => e * (_ingredientAvgLv50 + fruitAvgConstant) / 24.0).toList();
      case MainSkill.ingredientS:
        return MainSkill.ingredientS.basicValues.map((e) => e * _ingredientAvgLv50 / 24.0).toList();
      case MainSkill.cuisineS:
      /// TODO: 后期考虑要乘以菜谱加成
        return MainSkill.cuisineS.basicValues.map((e) => e * _ingredientAvgLv50 / 24.0).toList();
      case MainSkill.finger:
        final values = <List<double>>[];
        for (final m in MainSkill.values) {
          if (m == MainSkill.finger || m == MainSkill.vitalityFillS) {
            continue;
          }
          values.add(_calcMainSkillEnergyListLv50(m, helperAvgScore: helperAvgScore));
        }
        return List.generate(6, (i) => values.map((e) => e[i]).reduce((a, b) => a + b) / values.length);
    }
  }

  List<double> _calcMainSkillEnergyListLv100(MainSkill mainSkill, {
    // _helperAvgScoreLv100
    required double helperAvgScore,
  }) {
    //果子估平均
    const fruitAvgConstant = 310.0;

    // _ingredientAvg
    switch (mainSkill) {
      case MainSkill.energyFillS:
        return MainSkill.energyFillS.basicValues.map((e) => e / 24.0).toList();
      case MainSkill.energyFillM:
        return MainSkill.energyFillM.basicValues.map((e) => e / 24.0).toList();
      case MainSkill.energyFillSn:
        final v1 = <double>[200, 285, 393, 542, 748, 1033];
        final v2 = <double>[800, 1138, 1570, 2166, 2992, 4132];
        return List.generate(v1.length, (i) => (v1[i] + v2[i]) / 2.0 / 24.0);
      case MainSkill.dreamChipS:
        return MainSkill.dreamChipS.basicValues.map((e) => e / _shardsCoefficient).toList();
      case MainSkill.dreamChipSn:
        final v1 = [44, 63, 87, 137, 198, 284];
        final v2 = [176 ,250 ,346 ,548 ,790 ,1136];
        return List.generate(v1.length, (i) => (v1[i] + v2[i]) / 2 / _shardsCoefficient).toList();
      case MainSkill.vitalityS:
      // 活力係數，不知怎得的
        final v = [187.197, 233.155, 330.391, 433.691, 598.336, 845.682];
        return v.map((e) => e * helperAvgScore * 0.01 / 24.0).toList();
      case MainSkill.vitalityAllS:
      // 活力係數，不知怎得的
        final v = [61.331, 87.596, 114.851, 143.097, 202.310, 248.886];
        return v.map((e) => e * 5 * helperAvgScore * 0.01 / 24.0).toList();
      case MainSkill.vitalityFillS:
      // 活力係數，不知怎得的
        final v = [157.591, 217.629, 297.277, 398.597, 524.106, 692.877];
        return v.map((e) => e * 0.01 / 24.0).toList();
      case MainSkill.helpSupportS:
        return MainSkill.helpSupportS.basicValues.map((e) => e * (_ingredientAvgLv100 + fruitAvgConstant) / 24.0).toList();
      case MainSkill.ingredientS:
        return MainSkill.ingredientS.basicValues.map((e) => e * _ingredientAvgLv100 / 24.0).toList();
      case MainSkill.cuisineS:
      /// TODO: 后期考虑要乘以菜谱加成
        return MainSkill.cuisineS.basicValues.map((e) => e * _ingredientAvgLv100 / 24.0).toList();
      case MainSkill.finger:
        final values = <List<double>>[];
        for (final m in MainSkill.values) {
          if (m == MainSkill.finger || m == MainSkill.vitalityFillS) {
            continue;
          }
          values.add(_calcMainSkillEnergyListLv100(m, helperAvgScore: helperAvgScore));
        }
        return List.generate(6, (i) => values.map((e) => e[i]).reduce((a, b) => a + b) / values.length);
    }
  }

}

/// Step 1. 不考慮其他多隻寶可夢情境
class StatisticsBaseResult {
  StatisticsBaseResult({
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

/// Step 2. (Optional) 考量多隻
class StatisticsWithHelpersResult {

}

/// Step 3. 最終結果
class StatisticsFinalResult {
  // return ProfileStatisticsResult(
  //   profile, rankLv50, rankLv100,
  // );
}

extension _MainSkillX on MainSkill {
  bool get calculateWithHelperScore {
    return switch (this) {
      MainSkill.energyFillS => false,
      MainSkill.energyFillM => false,
      MainSkill.energyFillSn => false,
      MainSkill.dreamChipS => false,
      MainSkill.dreamChipSn => false,
      MainSkill.vitalityFillS => false,
      MainSkill.helpSupportS => false,
      MainSkill.ingredientS => false,
      MainSkill.cuisineS => false,
      MainSkill.vitalityS => true,
      MainSkill.vitalityAllS => true,
      MainSkill.finger => true,
    };
  }
}


