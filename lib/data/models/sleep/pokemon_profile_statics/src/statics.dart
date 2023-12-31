import 'package:collection/collection.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

part 'utils.dart';
part 'types.dart';

// xx_ 開頭：需參考幫手、主技能

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
  final List<PokemonProfile?> profiles;

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
  final _mainSkillLv = 3;

  List<StatisticsResults?> calc() {
    return _calc();
  }

  List<dynamic> calcForDev() {
    return [];
    // return _calc(_Type.dev);
  }

  List<StatisticsResults?> _calc() {
    // NOTES:
    // - Lv 50 與 Lv 100 的狀況下都是假設進化到最終階段
    if (profiles.isEmpty) {
      return [];
    }

    final statistics = profiles.map((profile) =>  profile == null ? null : _PokemonProfileStatisticsAtLevel(
      profile: profile,
      isSnorlaxFavorite: useSnorlaxFavorite && isSnorlaxFavorite,
      vitality: _userVitality,
      baseHelpInterval: level >= 50
          ? profile.helpIntervalAtMaxStage : profile.helpInterval,
      mainSkillLv: _mainSkillLv,
      level: level,
    )).toList();

    // Step1
    final baseResults = statistics
        .map((statistic) => statistic?.calc1())
        .toList();

    // Step2
    final helperTotalScore = baseResults
        .map((e) => e?.totalSelfBenefitPerHourWithoutHelpers ?? 0.0)
        .reduce((value, element) => value + element);
    final resultsWithHelpers = List.generate(profiles.length, (index) {
      final baseResult = baseResults[index];
      if (baseResult == null) {
        return null;
      }
      return statistics[index]?.calc2(
        baseResult,
        helperAvgScore: helperTotalScore / profiles.whereNotNull().length,
      );
    });

    _isInitialized = true;

    return List.generate(profiles.length, (index) {
      final profile = profiles[index];
      if (profile == null) {
        return null;
      }

      return StatisticsResults(
        profile: profile,
        baseResult: baseResults[index],
        resultWithHelpers: resultsWithHelpers[index],
      );
    });
  }

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
  }): type = level > 99 ? _StatisticsLevelType.level100
      : level > 49 ? _StatisticsLevelType.level50
      : _StatisticsLevelType.levelCustom;

  final PokemonProfile profile;
  final _StatisticsLevelType type;
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

  StatisticsResultBase calc1() {
    // region TODO: 改為計算
    /// (幫手計算) 出场平均估分，試算表上說
    /// 手動計算「选上你要上场的五只高分宝可梦「自身收益」平均数。」
    /// TODO: 在隊伍分析頁面中，使用自動計算

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
            profile.character.positiveEffect == CharacterEffect.ingredientDiscovery ? 1.2
                : profile.character.negativeEffect == CharacterEffect.ingredientDiscovery ? 0.8
                : 1.0
        ),
    );
    // 樹果機率
    final fruitRate = 1 - ingredientRate;
    // 加成後的主技能等級
    final finalMainSkillLevel = mainSkillLv
        + (_subSkillsContains(SubSkill.skillLevelM, level) ? 2 : 0)
        + (_subSkillsContains(SubSkill.skillLevelS, level) ? 1 : 0)
        + (type == _StatisticsLevelType.levelCustom ? 0 : (
            3 - _tc(() => profile.basicProfile.currentEvolutionStage, defaultValue: 3)
        ));

    // ## 幫忙間隔
    // 等級調整
    final helpIntervalWithLevel = _tc(() => baseHelpInterval - (baseHelpInterval * ((level - 1) * 0.002)));
    // 等級+性格+技能調整
    final helpIntervalWithLevelCharacterSkill = helpIntervalWithLevel * helpSpeedSM * (
        profile.character.positiveEffect == CharacterEffect.helpSpeed ? 0.9
            : profile.character.negativeEffect == CharacterEffect.helpSpeed ? 1.1
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
            + ingredientCount2PerHour * (profile.ingredient2?.energy ?? 0)
            + ingredientCount3PerHour * (profile.ingredient3?.energy ?? 0);

    // (白板收益) 樹果能量/h
    final pureFruitEnergyPerHour = fruitEnergy
        * pureFruitCountPerHour
        * (profile.isBerrySpecialty ? 2 : 1)
        * (isSnorlaxFavorite ? 2 : 1);

    // (白板收益) 食材能量/h
    final pureIngredientEnergyPerHour =
        pureIngredientCount1PerHour * profile.ingredient1.energy
            + pureIngredientCount2PerHour * (profile.ingredient2?.energy ?? 0)
            + pureIngredientCount3PerHour * (profile.ingredient3?.energy ?? 0);

    // (收益) 技能次數/d
    // 原有欄位是 V、CK、DI，確認了很多次，「當前等級」和「Lv50,Lv100」的算法不同
    //
    // 包含
    //
    // - 前者不參考活力
    // - 專長影響程度不同
    // - AM4 前者用乘法後者用加法
    final skillActivateCountPerDay = _tc(() {
      final xxx = profile.character.negativeEffect == CharacterEffect.mainSkill ? 0.8
          : profile.character.positiveEffect == CharacterEffect.mainSkill ? 1.2
          : 1;

      switch (type) {
        case _StatisticsLevelType.levelCustom:
          return skillRateSM * 3600 / helpIntervalWithLevelCharacterSkill * xxx
              + (profile.isSkillSpecialty ? 0.5 : 0)
              + _AL_4 * (finalMainSkillLevel - 1)
              + (profile.basicProfile.currentEvolutionStage - 2) * _AM_4;
        case _StatisticsLevelType.level100:
        case _StatisticsLevelType.level50:
          return skillRateSM * 3600 / helpIntervalWithLevelCharacterSkill * _transUserVitality() * xxx
              + (profile.isSkillSpecialty ? 0.2 : 0)
              + _AL_4 * (finalMainSkillLevel - 1)
              + _AM_4;
      }
    });

    // (白板收益) 次數/h
    final pureSkillActivateCountPerHour = _tc(() {
      switch (type) {
        case _StatisticsLevelType.levelCustom:
          return 3600 / helpIntervalWithLevel
              + (profile.isSkillSpecialty ? 0.2 : 0.0)
              + 0.25 // 不知道哪裡來的數字，原表單沒有給固定欄列
                  * (mainSkillLv - 1)
              + _AM_4 * (profile.basicProfile.currentEvolutionStage - 2);
        case _StatisticsLevelType.level100:
        case _StatisticsLevelType.level50:
          return 3600 / pureHelpIntervalWithLevelVitality * _transUserVitality()
              + (profile.isSkillSpecialty ? 0.2 : 0)
              + _AL_4 * (mainSkillLv + 3 - _tc(() => profile.basicProfile.currentEvolutionStage, defaultValue: 3)  - 1 + _AM_4);
      }
    });

    // (加成後) (不參考其他幫手) 主技能效益/h
    final mainSkillBenefitPerHourWithoutHelpers = (() {
      return _tc(() {
        final xx = _calcMainSkillEnergyList(profile.basicProfile.mainSkill, helperAvgScore: 0)[finalMainSkillLevel.toInt() - 1];

        return profile.basicProfile.mainSkill == MainSkill.vitalityFillS
            ? xx * (fruitEnergyPerHour + totalIngredientEnergyPerHour)
            : xx;
      }) * skillActivateCountPerDay;
    })();

    // (白板) (不參考其他幫手) 主技能效益/h
    final xxx_pureMainSkillBenefitPerHourWithoutHelpers = (() {
      final xx = _calcMainSkillEnergyList(basicProfile.mainSkill, helperAvgScore: 0);

      final yy123 = switch (type) {
        _StatisticsLevelType.levelCustom => xx[mainSkillLv - 1],
        _StatisticsLevelType.level100 => xx[(mainSkillLv + 3 - basicProfile.currentEvolutionStage).toInt() - 1],
        _StatisticsLevelType.level50 => xx[(mainSkillLv + 3 - basicProfile.currentEvolutionStage).toInt() - 1],
      };

      return _tc(() {
        return basicProfile.mainSkill == MainSkill.vitalityFillS
            ? yy123 * (pureFruitEnergyPerHour + pureIngredientEnergyPerHour) : yy123;
      }) * pureSkillActivateCountPerHour;
    })();

    // 食材換算成碎片/h
    final ingredientShardsPerHour = ingredientCount1PerHour * _getIngredientPrice(profile.ingredient1)
        + ingredientCount2PerHour * _getIngredientPrice(profile.ingredient2)
        + ingredientCount3PerHour * _getIngredientPrice(profile.ingredient3);

    // (不參考其他幫手效益) 白板收益/h
    final pureTotalBenefitPerHourWithoutHelpers = pureFruitEnergyPerHour
        + pureIngredientEnergyPerHour
        + xxx_pureMainSkillBenefitPerHourWithoutHelpers;

    // (加成後) ('不參考' 幫手效益) 自身收益/h
    final totalSelfBenefitPerHourWithoutHelpers = (() {
      final xxy = basicProfile.mainSkill == MainSkill.vitalityAllS ||
          basicProfile.mainSkill == MainSkill.vitalityS;

      return _tc(() => fruitEnergyPerHour
          + totalIngredientEnergyPerHour
          + mainSkillBenefitPerHourWithoutHelpers * (xxy ? 0 : 1)
      );
    })();

    return StatisticsResultBase(
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
      xxx_mainSkillBenefitPerHour: mainSkillBenefitPerHourWithoutHelpers,
      xxx_pureMainSkillBenefitPerHour: xxx_pureMainSkillBenefitPerHourWithoutHelpers,
      pureTotalBenefitPerHour: pureTotalBenefitPerHourWithoutHelpers,
      totalSelfBenefitPerHourWithoutHelpers: totalSelfBenefitPerHourWithoutHelpers,
    );
  }

  /// [helperAvgScore]: 出場平均估分
  StatisticsResultWithHelpers calc2(StatisticsResultBase baseResult, {
    required double helperAvgScore,
  }) {
    final pureTotalBenefitPerHour = baseResult.pureTotalBenefitPerHour;

    // 幫手計算估分
    final helperScore = helperAvgScore * 5 * 0.05 * (useHelper ? 1 : 0);

    // (加成後) (參考其他幫手) 主技能效益/h
    final mainSkillBenefitPerHour = (() {
      return _tc(() {
        final xx = _calcMainSkillEnergyList(
            profile.basicProfile.mainSkill, helperAvgScore: helperAvgScore)[baseResult.finalMainSkillLevel.toInt() - 1];

        return profile.basicProfile.mainSkill == MainSkill.vitalityFillS
            ? xx * (baseResult.fruitEnergyPerHour + baseResult.totalIngredientEnergyPerHour)
            : xx;
      }) * baseResult.skillActivateCountPerDay;
    })();

    // (加成後) ('參考'幫手效益) 自身收益/h From Step1
    final totalSelfBenefitPerHour = (() {
      // final xxy = basicProfile.mainSkill.isCalcWithHelperScore;
      final xxy = basicProfile.mainSkill == MainSkill.vitalityAllS ||
          basicProfile.mainSkill == MainSkill.vitalityS;

      return _tc(() => baseResult.fruitEnergyPerHour
          + baseResult.totalIngredientEnergyPerHour
          + mainSkillBenefitPerHour * (xxy ? 0 : 1)
          + (profile.hasSubSkillAtLevel(SubSkill.helperBonus, level) ? helperScore / 5 : 0)
      );
    })();

    final effect = totalSelfBenefitPerHour == 0 ? 0
        : (totalSelfBenefitPerHour - pureTotalBenefitPerHour) / pureTotalBenefitPerHour;

    // 評級, Rank
    String rank;
    if (pureTotalBenefitPerHour == 0) {
      rank = '-';
    } else {
      if (level < 50) {
        rank = effect >= 0.3 ? 'S' :
        effect >= 0.24 ? 'A' :
        effect >= 0.18 ? 'B' :
        effect >= 0.12 ? 'C' :
        effect >= 0.06 ? 'D' :
        effect >= 0 ? 'E' :
        effect < 0 ? 'F' : '-';
      } else if (level < 100) {
        rank = effect >= 1 ? 'S' :
        effect >= 0.8 ? 'A' :
        effect >= 0.6 ? 'B' :
        effect >= 0.4 ? 'C' :
        effect >= 0.2 ? 'D' :
        effect >= 0 ? 'E' :
        effect < 0 ? 'F' : '-';
      } else {
        rank = effect >= 1.5 ? 'SS' :
        effect >= 1 ? 'S' :
        effect >= 0.8 ? 'A' :
        effect >= 0.6 ? 'B' :
        effect >= 0.4 ? 'C' :
        effect >= 0.2 ? 'D' :
        effect >= 0 ? 'E' :
        effect < 0 ? 'F' : '-';
      }
    }

    return StatisticsResultWithHelpers(
      rank: rank,
      totalSelfBenefitPerHour: totalSelfBenefitPerHour,
    );
  }

  int _getIngredientPrice(Ingredient? ingredient) {
    if (ingredient == null) {
      return 0;
    }

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

  List<SubSkill?> _getSubSkillsByLevel(int level) {
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

class StatisticsResults {
  StatisticsResults({
    required this.profile,
    required this.baseResult,
    required this.resultWithHelpers,
  });

  final PokemonProfile profile;
  final StatisticsResultBase? baseResult;
  final StatisticsResultWithHelpers? resultWithHelpers;
}
