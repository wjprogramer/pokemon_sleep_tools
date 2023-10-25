import 'package:flutter/foundation.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

/// 運算公式來源：「https://bbs.nga.cn/read.php?tid=37305277」
class PokemonProfileStatistics2 {
  PokemonProfileStatistics2(this.profile);

  // Profile properties
  final PokemonProfile profile;
  PokemonBasicProfile get basicProfile => profile.basicProfile;
  /// 基礎間隔
  int get helpInterval => basicProfile.helpInterval;
  Fruit get fruit => basicProfile.fruit;
  PokemonSpecialty get specialty => basicProfile.specialty;
  PokemonCharacter get character => profile.character;
  List<SubSkill> get subSkills => profile.subSkills;
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
  /// 之後 profile 要可以設定等級，先暫時固定
  static int _level = 25;


  // 計算基準（可由使用者設定）
  /// 食材估平均
  final _ingredientAvg = 110.0;
  /// (幫手計算) 出场平均估分，試算表上說
  /// 手動計算「选上你要上场的五只高分宝可梦「自身收益」平均数。」
  /// TODO: 在隊伍分析頁面中，使用自動計算
  final _helperAvgScore = 226.0;
  /// 碎片估算係數
  /* 主技能:$R$11 */ final _shardsCoefficient = 5;
  /* D */ final _userVitality = 4;

  // factory PokemonProfileStatistics2.from(PokemonProfile profile) {
  //   return PokemonProfileStatistics2._(profile);
  // }

  void init() {
    /* A */
    /* B */
    /* C */
    /* E */
    /* F */
    /* G */
    /* S */
    /* U */
    /* V */
    /* W */
    /* X */
    /* Y */
    /* Z */
    /* AA */
    /* AB */
    /* AC */
    /* AD */
    /* AE */
    /* AF */
    /* AG */
    /* AH */
    /* AI */
    /* AJ */
    /* AK */
    /* AL */ final fruitEnergyLvCurr = _getSingleFruitEnergy(_level);
    /* EK */ final fruitBonusEnergy = _subSkillsContains(SubSkill.berryCountS, _level) ? fruitEnergyLvCurr : 0.0;
    /* AM */ final fruitEnergyAfterSpecialtyAndSubSkillLvCurr = fruitEnergyLvCurr * (specialty == PokemonSpecialty.t3 ? 2 : 1) + fruitBonusEnergy;
    /* AN */
    /* AO */ final fruitEnergyLv50 = _getSingleFruitEnergy(50);
    /* EV */
    /* AP */
    /* AQ */
    /* AR */ final fruitEnergyLv100 = _getSingleFruitEnergy(100);
    /* AS */
    /* AT */
    /* AU */
    /* AV */
    /* AW */
    /* AX */ final levelAdjust = helpInterval - (helpInterval * ((_level - 1) * 0.002));
    /* AY */
    /* AZ */
    /* BA */
    /* BB */
    /* BC */
    /* BD */
    /* BE */
    /* BF */
    /* BG */
    /* BH */
    /* BI */
    /* BJ */
    /* BK */ // ~
    /* BL */
    /* BM */ // final x = _level > 29 ?
    /* BN */

    // region 順序有亂
    /* BQ */ const ingredientRate = 0.2;
    /* BO */ const fruitRate = 1 - ingredientRate;
    /* BP */
    // endregion

    /* BR */
    /* BS */
    /* BT */
    /* BU */
    /* BV */
    /* BW */
    /* BX */
    /* BY */
    /* BZ */
    /* CA */
    /* CB */
    /* CC */
    /* CD */
    /* CE */
    /* CF */
    /* CG */
    /* CH */
    /* CI */
    /* CJ */
    /* CK */
    /* CL */
    /* CM */
    /* CN */
    /* CO */
    /* CP */
    /* CQ */
    /* CR */
    /* CS */
    /* CT */
    /* CU */
    /* CV */
    /* CW */
    /* CX */
    /* CY */
    /* CZ */
    /* DA */
    /* DB */
    /* DC */
    /* DD */
    /* DE */
    /* DF */
    /* DG */
    /* DH */
    /* DI */
    /* DJ */
    /* DK */
    /* DL */
    /* DM */
    /* DN */
    /* DO */
    /* DP */
    /* DQ */
    /* DR */
    /* DS */
    /* DT */
    /* DU */
    /* DV */
    /* DW */ final iPrice1 = _getIngredientPrice(ingredient1);
    /* DX */ final iPrice2 = _getIngredientPrice(ingredient2);
    /* DY */ final iPrice3 = _getIngredientPrice(ingredient3);
    /* DZ */
    /* EA */
    /* EB */
    /* EC */
    /* ED */
    /* EE */
    /* EL 幫忙M確認 */ final helpSpeedMLvCurr = _subSkillsContains(SubSkill.helpSpeedM, _level) ? 0.86 : 1.0;
    /* EM 幫忙S+M確認: */ final helpSpeedSM = _subSkillsContains(SubSkill.helpSpeedS, _level)
        ? (helpSpeedMLvCurr == 0.86 ? 0.79 : 0.93)
        : (helpSpeedMLvCurr == 0.86 ? 0.86 : 1.00);
    /* EN 食材M確認 */ final ingredientMLvCurr = _subSkillsContains(SubSkill.ingredientM, _level) ? 0.86 : 1.0;
    /* EO */
    /* EP */
    /* EQ */
    /* ER */
    /* ES */
    /* ET */
    /* EU */
    /* EW */
    /* EX */
    /* EY */
    /* EZ */
    /* FA */
    /* FB */
    /* FC */
    /* FD */
    /* FE */
    /* FF */
    /* FG */
    /* FH */
    /* FI */
    /* FJ */
    /* FK */
    /* FL */
    /* FM */
    /* FN */
    /* FO */
    /* FP */
    /* FQ ~ GC Skipped */
    /* GD */
    /* GE */
    /* GF */
    /* GG */
    /* GH */
    /* GI */
    /* GJ */
    /* GK */
    /* GL */
    /* GM */
    /* GN */
    /* GO */
    /* GP */
    /* GQ */
    /* GR */
    /* GS */
    /* GT */
    /* GU */
    /* GV */
    /* GW */
    /* GX */
    /* GY */
    /* GZ */


    debugPrint('~');
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
    return subSkills.take(count).toList();
  }

  _getIngredientPrice(Ingredient ingredient) {
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

  void tempTest() {
    for (final mainSkill in MainSkill.values) {
      debugPrint(
        '${mainSkill.nameI18nKey.xTr}: ${_calcMainSkillEnergyList(mainSkill).map((e) => e.toStringAsFixed(2)).join(',')}',
      );
    }
  }

  List<double> _calcMainSkillEnergyList(MainSkill mainSkill) {
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
        return v.map((e) => e * _helperAvgScore * 0.01 / 24.0).toList();
      case MainSkill.vitalityAllS:
        // 活力係數，不知怎得的
        final v = [61.331, 87.596, 114.851, 143.097, 202.310, 248.886];
        return v.map((e) => e * 5 * _helperAvgScore * 0.01 / 24.0).toList();
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
          if (m == MainSkill.finger || m == MainSkill.vitalityS || m == MainSkill.vitalityAllS || m == MainSkill.vitalityFillS) {
            continue;
          }
          values.add(_calcMainSkillEnergyList(m));
        }
        return List.generate(6, (i) => values.map((e) => e[i]).reduce((a, b) => a + b) / values.length);
    }
  }

  /// [level 1~100]
  int _getSingleFruitEnergy(int level) {
    assert(level >= 1 && level <= 100);
    return fruit.getLevels()[level - 1];
  }


}