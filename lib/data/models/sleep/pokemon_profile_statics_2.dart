import 'package:flutter/foundation.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonProfileStatistics2Result {
  PokemonProfileStatistics2Result(this.profile, this.rankLv50, this.rankLv100);

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
class PokemonProfileStatistics2 {
  PokemonProfileStatistics2(this.profile);

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  PokemonProfileStatistics2Result? _result;
  PokemonProfileStatistics2Result? get result => _result;

  // Profile properties
  final PokemonProfile profile;
  PokemonBasicProfile get basicProfile => profile.basicProfile;
  /* AW 基礎間隔 */int get helpInterval => basicProfile.helpInterval;
  Fruit get fruit => basicProfile.fruit;
  /* BB 最高進化階段基礎間隔 */ int get maxHelpInterval => basicProfile.maxHelpInterval;
  PokemonSpecialty get specialty => basicProfile.specialty;
  /* AU 專長編號  樹果1, 食材2, 技能3 */
  bool get isBerrySpecialty => specialty == PokemonSpecialty.t3;
  bool get isSkillSpecialty => specialty == PokemonSpecialty.t1;
  bool get isIngredientSpecialty => specialty == PokemonSpecialty.t2;
  PokemonCharacter get character => profile.character;
  List<SubSkill> get subSkills => profile.subSkills;
  Ingredient get ingredient1 => profile.ingredient1;
  Ingredient get ingredient2 => profile.ingredient2;
  Ingredient get ingredient3 => profile.ingredient3;
  int get ingredientCount1 => profile.ingredientCount1;
  /* AE 個數 */ int get ingredientCount2 => profile.ingredientCount2;
  /* AH 個數 */ int get ingredientCount3 => profile.ingredientCount3;
  SubSkill get subSkillLv10 => profile.subSkillLv10;
  SubSkill get subSkillLv25 => profile.subSkillLv25;
  SubSkill get subSkillLv50 => profile.subSkillLv50;
  SubSkill get subSkillLv75 => profile.subSkillLv75;
  SubSkill get subSkillLv100 => profile.subSkillLv100;
  /// 之後 profile 要可以設定等級，先暫時固定
  /* I */ static int _level = 25;

  // 其他
  /* AV 喜愛的果子 */
  /// 卡比獸喜愛的果子 (之後要根據實際島嶼計算)
  final _isSnorlaxFavorite = false;

  // 計算基準（可由使用者設定）
  /// 食材估平均
  final _ingredientAvg = 110.0;
  final _ingredientAvgLv50 = 135.0;
  final _ingredientAvgLv100 = 135.0;
  /// (幫手計算) 出场平均估分，試算表上說
  /// 手動計算「选上你要上场的五只高分宝可梦「自身收益」平均数。」
  /// TODO: 在隊伍分析頁面中，使用自動計算
  final _helperAvgScore = 226.0;
  /* $GY$3 */ final _helperAvgScoreLv50 = 815.0;
  /* $HA$3 */ final _helperAvgScoreLv100 = 2333.0;
  /// 碎片估算係數
  /* 主技能:$R$11 */ final _shardsCoefficient = 5;
  /* D 活力檔位 */ final _userVitality = 4;
  /// 是否考慮卡比獸喜愛的果子 (之後由使用者設定)
  /* $H$4 */ final _shouldConsiderSnorlaxFavorite = false;
  /// 主技能等級
  /* FW */ final _mainSkillLv = 3;
  /// 是否考慮幫手
  /* $Q$4 */ final q4 = 1; // 1 為考慮，反之 0 為不考慮

  // 在 sheet 上為常數
  /* $AM$4 */ final _ccc1 = 0.25;
  /* $AL$4 */ final _ccc2 = 0.25;

  List<dynamic> calcForDev() {
    return _calc(_Type.dev);
  }

  PokemonProfileStatistics2Result calcForUser() {
    _result = _calc(_Type.userView);
    return _result!;
  }

  // PokemonProfileStatistics2Result calc() {

  dynamic _calc(_Type type) {

    /* $GY$4 */ final gy4 = _helperAvgScoreLv50 * 5 * 0.05;
    /* $HA$4 */ final ha4 = _helperAvgScoreLv100 * 5 * 0.05;

    // 帮手计算估分
    /* $O$4 */ final o4 = _helperAvgScore * 5 * 0.05 * q4;

    // region 無關等級
    /* DW 食材1售價 */ final ingredientPrice1 = _getIngredientPrice(ingredient1);
    /* DX 食材2售價 */ final ingredientPrice2 = _getIngredientPrice(ingredient2);
    /* DY 食材3售價 */ final ingredientPrice3 = _getIngredientPrice(ingredient3);
    /* DZ 食材1能量 */ final ingredientEnergy1 = ingredient1.energy;
    /* EA 食材2能量 */ final ingredientEnergy2 = ingredient2.energy;
    /* EB 食材3能量 */ final ingredientEnergy3 = ingredient3.energy;
    /* BQ (白板計算) 食材機率 */ const ingredientRate = 0.2; // TODO: 感覺應該根據 BasicProfile 的食材機率
    /* BO (白板計算) 果子機率 */ const fruitRate = 1 - ingredientRate;
    // endregion

    /* BC (進化後) 性格+活力調整 */
    final maxHelpIntervalAdjust1 = _tc(() => maxHelpInterval *
        (
            character.positive == '幫忙速度' ? 0.9
                : character.negative == '幫忙速度' ? 1.1
                : 1.0
        ) * _transUserVitality()
    );


    // region 當前等級
    /* (當前等級) AL 果子/顆 */ final fruitEnergyLvCurr = _getSingleFruitEnergy(_level);
    /* (當前等級) EK 樹果+1確認 */ final fruitBonusEnergy = _subSkillsContains(SubSkill.berryCountS, _level) ? fruitEnergyLvCurr : 0.0;
    /* (當前等級) AM 類型與技能加成/顆 */ final fruitEnergyAfterSpecialtyAndSubSkillLvCurr = fruitEnergyLvCurr * (isBerrySpecialty ? 2 : 1) + fruitBonusEnergy;
    /* (當前等級) AN +喜愛加成/顆 */ final fruitEnergyAfterSnorlaxFavorite = fruitEnergyAfterSpecialtyAndSubSkillLvCurr * (_isSnorlaxFavorite && _shouldConsiderSnorlaxFavorite ? 2 : 1);
    /* (當前等級) EL 幫忙M確認 */ final helpSpeedMLvCurr = _subSkillsContains(SubSkill.helpSpeedM, _level) ? 0.86 : 1.0;
    /* (當前等級) EM 幫忙S+M確認: */ final helpSpeedSMLvCurr = _subSkillsContains(SubSkill.helpSpeedS, _level)
        ? (helpSpeedMLvCurr == 0.86 ? 0.79 : 0.93)
        : (helpSpeedMLvCurr == 0.86 ? 0.86 : 1.00);

    // 幫忙間隔
    /* (當前等級) AX 等級調整 */ final helpIntervalLvCurr1 = helpInterval - (helpInterval * ((_level - 1) * 0.002));
    /* (當前等級) AY 性格+技能調整 */ final helpIntervalLvCurr2 = _tc(() => helpIntervalLvCurr1 * helpSpeedSMLvCurr
        * (
            character.positive == '幫忙速度' ? 0.9
                : character.negative == '幫忙速度' ? 1.1
                : 1.0
        ),
    );
    /* (當前等級) AZ 活力影響後 */ final helpIntervalLvCurr3 = helpIntervalLvCurr2 * _transUserVitality();
    /* (當前等級) BA 白板-活力影響 */ final helpIntervalPureLvCurr = _tc(() => helpIntervalLvCurr1 * _transUserVitality());
    /* (當前等級) EN 食材M確認 */ final ingredientMLvCurr = _subSkillsContains(SubSkill.ingredientRateM, _level) ? 1.36 : 1.0;
    /* (當前等級) EO 食材S+M確認 */ final ingredientSMLvCurr = _subSkillsContains(SubSkill.ingredientRateS, _level)
        ? (ingredientMLvCurr == 1.36 ? 1.54 : 1.18)
        : (ingredientMLvCurr == 1.36 ? 1.36 : 1.00);
    /* (當前等級) EP 技能幾率M確認 */ final skillRateMLvCurr = _subSkillsContains(SubSkill.skillRateM, _level) ? 1.36 : 1.0;
    /* (當前等級) EQ 技能幾率S+M確認 */ final skillRateSMLvCurr = _subSkillsContains(SubSkill.skillRateS, _level)
        ? (skillRateMLvCurr == 1.36 ? 1.54 : 1.18)
        : (skillRateMLvCurr == 1.36 ? 1.36 : 1.00);
    /* ER 加成後主技能等級 */
    final erLvCurr = _mainSkillLv +
        (_subSkillsContains(SubSkill.skillLevelM, _level) ? 2 : 0) +
        (_subSkillsContains(SubSkill.skillLevelS, _level) ? 1 : 0);
    /* BJ (加成後) 食材機率 */
    final bjLvCurr = _tc(() => 0.2 * ingredientSMLvCurr
        * (
            character.positive == '食材發現' ? 1.2
                : character.negative == '食材發現' ? 0.8
                : 1.0
        )
    );
    /* BH (加成後) 果子機率 */ final fruitRateLvCurr1 = 1 - bjLvCurr;
    /* BK (加成後) 食材預期次數/h */ final ingredientCountPerHourLvCurr = _tc(() => 3600 / helpIntervalLvCurr3 * bjLvCurr);
    /* BI (加成後) 果實預期次數/h */ final biLvCurr = _tc(() => 3600 / helpIntervalLvCurr3 * fruitRateLvCurr1);
    /* BL (加成後) 食材1個數/h */
    final ingredient1CountPerHourAfterAdjustLvCurr = _tc(() => ingredientCountPerHourLvCurr * (isIngredientSpecialty ? 2 : 1))
        * (_level > 59 ? 1/3 : (_level > 29 ? 1/2 : 1));
    /* BM (加成後) 食材2個數/h */ final ingredient2CountPerHourAfterAdjustLvCurr = _tc(() => (_level>29 ? ingredientCountPerHourLvCurr * ingredientCount2 : 0),) * (_level > 59 ? 1/3 : 1/2);
    /* BN (加成後) 食材3個數/h */ final ingredient3CountPerHourAfterAdjustLvCurr = _tc(() => (_level>59 ? ingredientCountPerHourLvCurr * ingredientCount3: 0)) / 3;
    /* AJ 食材能量/h */ final ajLvCurr = _tc(() => ingredient1CountPerHourAfterAdjustLvCurr * ingredientEnergy1 + ingredient2CountPerHourAfterAdjustLvCurr * ingredientEnergy2 + ingredient3CountPerHourAfterAdjustLvCurr * ingredientEnergy3);
    /* AI 食材個/h */ final aiLvCurr = ingredient1CountPerHourAfterAdjustLvCurr + ingredient2CountPerHourAfterAdjustLvCurr + ingredient3CountPerHourAfterAdjustLvCurr;
    /* AK 食材換算成碎片/h */ final akLvCurr = _tc(() => ingredient1CountPerHourAfterAdjustLvCurr * ingredientPrice1 + ingredient2CountPerHourAfterAdjustLvCurr * ingredientPrice2 + ingredient3CountPerHourAfterAdjustLvCurr * ingredientPrice3);
    /* BP (白板計算) 果實預期次數/h */ final bpLvCurr = _tc(() => 3600 / helpIntervalPureLvCurr * fruitRate);

    /* BR (白板計算) 食材預期次數/h */ final brLvCurr = _tc(() => 3600/ helpIntervalPureLvCurr * ingredientRate);
    /* BS (白板計算) 食材1個數/h */ final bsLvCurr = _tc(() => brLvCurr * (isIngredientSpecialty ? 2 : 1)) * (_level > 59 ? 1/3 : (_level>29 ? 1/2 : 1));
    /* BT (白板計算) 食材2個數/h */ final btLvCurr = _tc(() => (_level > 29 ? brLvCurr * ingredientCount2 : 0)) * (_level > 59 ? 1/3 : 1/2);
    /* BU (白板計算) 食材3個數/h */ final buLvCurr = _tc(() => (_level > 59 ? brLvCurr * ingredientCount3 : 0)) / 3.0;
    /* BV (白板收益) 樹果能量/h */ final bvLvCurr = _tc(() => fruitEnergyLvCurr * bpLvCurr * (isBerrySpecialty ? 2 : 1) * (_isSnorlaxFavorite?2:1));
    /* BW (白板收益) 食材個/h */ final bwLvCurr = bsLvCurr + btLvCurr + buLvCurr;
    /* BX (白板收益) 食材能量/h */ final bxLvCurr = _tc(() => bsLvCurr * ingredientEnergy1 + btLvCurr * ingredientEnergy2 + buLvCurr * ingredientEnergy3);
    /* BY (白板收益) 次數/h */
    final byLvCurr = _tc(() {
      return 3600 / helpIntervalLvCurr1 +
          (isSkillSpecialty ? 0.2 : 0.0)+
          0.25*(_mainSkillLv-1)+
          (basicProfile.currentEvolutionStage - 2) * _ccc1;
    });
    /* BZ (白板收益) 主技能效益/h */
    final bzLvCurr = _tc(() {
      return basicProfile.mainSkill == MainSkill.vitalityFillS
          ? (bvLvCurr + bxLvCurr)* _calcMainSkillEnergyList(basicProfile.mainSkill)[_mainSkillLv - 1]
          : _calcMainSkillEnergyList(basicProfile.mainSkill)[_mainSkillLv - 1];
    }) * byLvCurr;

    /* U 主技能等級 */ final uLvCurr = erLvCurr;
    /* V 技能次數/d */
    final vLvCurr = _tc(() =>
    (skillRateSMLvCurr * 3600 / helpIntervalLvCurr2*
        (character.negative == '主技能' ?  0.8 : character.positive == '主技能' ? 1.2 : 1))+
        _ccc2 * (uLvCurr - 1)+
        (isSkillSpecialty ?0.5:0)+
        (basicProfile.currentEvolutionStage - 2)*_ccc1
    );
    /* Z 樹果能量/h */
    final zLvCurr = _tc(() => biLvCurr * fruitEnergyAfterSnorlaxFavorite);
    /* W 主技能效益/h */
    final wLvCurr = _tc(() =>
    (
        basicProfile.mainSkill == MainSkill.vitalityFillS
            ? (zLvCurr + ajLvCurr)* _calcMainSkillEnergyList(basicProfile.mainSkill)[uLvCurr.toInt() - 1]
            : _calcMainSkillEnergyList(basicProfile.mainSkill)[uLvCurr.toInt() - 1]
    ))*vLvCurr;
    /* B 白板收益/h */ final bLvCurr = bvLvCurr + bxLvCurr + bzLvCurr;
    /* E 理想總收益/h */
    final eLvCurr = _tc(() =>
    zLvCurr + ajLvCurr + wLvCurr + (_subSkillsContains(SubSkill.helperBonus, _level) ? o4 : 0)
    );
    /* C 性格技能影響 */ final cLvCurr = bLvCurr == 0 ? 0 : (eLvCurr - bLvCurr) / bLvCurr;
    /* F 自身收益/h */
    // =IFERROR(
    // Z7+AJ7+(W7+IF(OR(EF7=6,EG7=6,EH7=6,EI7=6,EJ7=6),$O$4/5,))*IF(VLOOKUP(VLOOKUP(H7,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$1:$P$13,15,FALSE)>1,0,1),)
    final fLvCurr = _tc(() =>
    zLvCurr + ajLvCurr + (wLvCurr + (_subSkillsContains(SubSkill.helperBonus, _level) ? o4 / 5 : 0)) *
        (basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS ? 0 : 1)
    );
    /* G 輔助隊友收益/h */
    final gLvCurr = eLvCurr - fLvCurr;
    // endregion


    // region Lv 50
    /* (Lv 50) AO 果子/顆 */ final fruitEnergyLv50 = _getSingleFruitEnergy(50);
    /* (Lv 50) EV 樹果+1確認 */ final fruitBonusEnergyLv50 = _subSkillsContains(SubSkill.berryCountS, 50) ? fruitEnergyLv50 : 0.0;
    /* (Lv 50) AP 類型與技能加成/顆 */ final fruitEnergyAfterSpecialtyAndSubSkillLv50 = fruitEnergyLv50 * (isBerrySpecialty ? 2 : 1) + fruitBonusEnergyLv50;
    /* (Lv 50) AQ +喜愛加成/顆 */ final fruitEnergyAfterSnorlaxFavoriteLv50 = fruitEnergyAfterSpecialtyAndSubSkillLv50 * (_isSnorlaxFavorite && _shouldConsiderSnorlaxFavorite ? 2 : 1);
    /* (Lv 50) EW 幫忙M確認 */ final helpSpeedMLv50 = _subSkillsContains(SubSkill.helpSpeedM, 50) ? 0.86 : 1.0;
    /* (Lv 50) EX 幫忙S+M確認 */ final helpSpeedSMLv50 = _subSkillsContains(SubSkill.helpSpeedS, 50)
        ? (helpSpeedMLv50 == 0.86 ? 0.79 : 0.93)
        : (helpSpeedMLv50 == 0.86 ? 0.86 : 1.00);
    /* (Lv 50) BD 間隔 */ final bdLv50 = _tc(() => maxHelpIntervalAdjust1 - (maxHelpIntervalAdjust1 * ((50-1) * 0.002))) * helpSpeedSMLv50;
    /* BE 50白板活力 */ final beLv50 = _tc(() => (maxHelpInterval - (maxHelpInterval * ((50-1)*0.002)))*_transUserVitality());
    /* (Lv 50) EY 食材M確認 */ final ingredientMLv50 = _subSkillsContains(SubSkill.ingredientRateM, 50) ? 1.36 : 1.0;
    /* (Lv 50) EZ 食材S+M確認 */ final ingredientSMLv50 = _subSkillsContains(SubSkill.ingredientRateS, 50)
        ? (ingredientMLv50 == 1.36 ? 1.54 : 1.18)
        : (ingredientMLv50 == 1.36 ? 1.36 : 1.00);
    /* (Lv 50) FA 技能幾率M確認 */ final skillRateMLv50 = _subSkillsContains(SubSkill.skillRateM, 50) ? 1.36 : 1.0;
    /* (Lv 50) FB 技能幾率S+M確認 */ final skillRateSMLv50 = _subSkillsContains(SubSkill.skillRateS, 50)
        ? (skillRateMLv50 == 1.36 ? 1.54 : 1.18)
        : (skillRateMLv50 == 1.36 ? 1.36 : 1.00);
    /* (Lv 50) FC 加成後主技能等級 */
    final fcLv50 = _mainSkillLv +
        (_subSkillsContains(SubSkill.skillLevelM, 50) ? 2 : 0) +
        (_subSkillsContains(SubSkill.skillLevelS, 50) ? 1 : 0) +
        3 -
        _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3);

    /* CC (50計算) 食材機率 */ final ingredientRateLv50 = 0.2 * ingredientSMLv50 * (
        character.positive == '食材發現' ? 1.2
            : character.negative == '食材發現' ? 0.8
            : 1.0
    );
    /* CA (50計算) 果子機率 */ final fruitRateLv50 = 1 - ingredientRateLv50;
    /* CB (50計算) 果實預期次數/h */ final cbLv50 = _tc(() => 3600 / bdLv50 * fruitRateLv50);
    /* CD (50計算) 食材預期次數/h */ final cdLv50 = _tc(() => 3600 / bdLv50 * ingredientRateLv50);
    /* CE (50計算) 食材1個數/h */ final ceLv50 = _tc(() => cdLv50 * (isIngredientSpecialty ? 2 : 1)) / 2.0;
    /* CF (50計算) 食材2個數/h */ final cfLv50 = _tc(() => cdLv50 * ingredientCount2) / 2.0;
    /* CG (50計算), CS (50白板計算) 食材3個數/h */ const ingredientCount3Lv50 = 0;
    /* CH (50收益) 樹果能量/h, GD (Lv50Result) 樹果能量/h */ final chLv50 = _tc(() => cbLv50 * fruitEnergyAfterSnorlaxFavoriteLv50);
    /* CI (50收益) 食材個/h, GE (Lv50Result) 食材個/h */ final ciLv50 = ceLv50 + cfLv50 + ingredientCount3Lv50;
    /* CJ (50收益) 食材能量/h, GF (Lv50Result) 食材能量/h */ final cjLv50 = _tc(() => ceLv50 * ingredientEnergy1 + cfLv50 * ingredientEnergy2 + ingredientCount3Lv50 * ingredientEnergy3);

    /* CK (50收益) 次數/d, GG (Lv50Result) 技能次數/d */
    final ckLv50 = _tc(() => (
        skillRateSMLv50 * 3600 / bdLv50 * _transUserVitality()
            * (
            character.negative == '主技能' ? 0.8
                : character.positive == '主技能' ? 1.2
                : 1
        )
    )
        + (isSkillSpecialty ? 0.2 : 0)
        + _ccc1 * (fcLv50 - 1)
        + _ccc2,
    );

    /* CL (50收益) 主技能效益/h, GH (Lv50Result) 主技能效益/h */
    final clLv50 = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (chLv50+cjLv50) * _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[fcLv50.toInt() - 1] :
        _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[fcLv50.toInt() - 1]
    )
    ) * ckLv50;
    
    /* CN (50白板計算) 果實預期次數/h */ final cnLv50 = _tc(() => 3600 / beLv50 * fruitRate);
    /* CP (50白板計算) 食材預期次數/h */ final cpLv50 = _tc(() => 3600 / beLv50 * ingredientRate);
    /* CQ (50白板計算) 食材1個數/h */ final cqLv50 = _tc(() => cpLv50 * (isIngredientSpecialty ? 2 : 1)) / 2.0;
    /* CR (50白板計算) 食材2個數/h */ final crLv50 = _tc(() => cpLv50 * ingredientCount2) / 2.0;

    /* CT (50白板收益) 樹果能量/h */ final ctLv50 = _tc(() => fruitEnergyLv50 * cnLv50 * (isBerrySpecialty ? 2 : 1) * (_isSnorlaxFavorite ? 2 : 1));
    /* CU (50白板收益) 食材個/h */ final cuLv50 = cqLv50 + crLv50 + ingredientCount3Lv50;
    /* CV (50白板收益) 食材能量/h */ final cvLv50 = _tc(() => cqLv50 * ingredientEnergy1 + crLv50 * ingredientEnergy2 + ingredientCount3Lv50 * ingredientEnergy3);
    /* CW (50白板收益) 次數/h */
    final cwLv50 = _tc(() =>
    (
        3600 / beLv50 * _transUserVitality()
    )
        + (isSkillSpecialty ? 0.2 : 0)
        + _ccc2 *
        (_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)  - 1 + _ccc1),
    );
    /* CX (50白板收益) 主技能效益/h */
    final cxLv50 = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (ctLv50 + cvLv50) * _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[(_mainSkillLv + 3-_tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1] :

        _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[(_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1]
    )
    ) * cwLv50;
    /* (Lv50Result) GI 50自身收益/h */
    final giLv50 = _tc(() =>
    chLv50 + cjLv50 + clLv50 *
        (basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS ? 0 : 1) +
        (_subSkillsContains(SubSkill.helperBonus, 50) ? gy4 / 5 : 0)
    );
    /* (Lv50Result) GK 50收益/h */ final gkLv50 = _tc(
            () => chLv50 + cjLv50 + clLv50 + (_subSkillsContains(SubSkill.helperBonus, 50) ? gy4 : 0)
    );
    /* GJ (Lv50Result) 50輔助隊友收益/h */ final gjLv50 = gkLv50 - giLv50;
    /* GL (Lv50Result) 50白板/h */ final glLv50 = ctLv50 + cvLv50 + cxLv50;
    /* GM (Lv50Result) 影響 */ final gmLv50 = bLvCurr == 0 ? 0 : (gkLv50 - glLv50) / glLv50;
    // endregion


    // region Lv 100
    /* AR (Lv 100) 果子/顆 */ final fruitEnergyLv100 = _getSingleFruitEnergy(100);
    /* FI (Lv 100) 樹果+1確認 */ final fruitBonusEnergyLv100 = _subSkillsContains(SubSkill.berryCountS, 100)
        ? fruitEnergyLv100 : 0.0;
    /* AS (Lv 100) 類型與技能加成/顆 */ final fruitEnergyAfterSpecialtyAndSubSkillLv100 = fruitEnergyLv100 * (isBerrySpecialty ? 2 : 1) + fruitBonusEnergyLv100;
    /* AT (Lv 100) +喜愛加成/顆 */ final fruitEnergyAfterSnorlaxFavoriteLv100 = fruitEnergyAfterSpecialtyAndSubSkillLv100 * (_isSnorlaxFavorite && _shouldConsiderSnorlaxFavorite ? 2 : 1);
    /* BG 100白板活力 */ final maxHelpIntervalLv100 = _tc(() => (maxHelpInterval - (maxHelpInterval * ((100-1)*0.002))) * _transUserVitality());
    /* DU (100白板) 次數/h */ final duLv100 = _tc(() => 3600/maxHelpIntervalLv100 *_transUserVitality() +
        (isSkillSpecialty ? 0.2 : 0)+ _ccc2 * (_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)-1) + _ccc1,
    );
    /* FJ (Lv 100) 幫忙M確認 */ final helpSpeedMLv100 = _subSkillsContains(SubSkill.helpSpeedM, 100) ? 0.86 : 1.0;
    /* FK (Lv 100) 幫忙S+M確認 */ final helpSpeedSMLv100 = _subSkillsContains(SubSkill.helpSpeedS, 100)
        ? (helpSpeedMLv50 == 0.86 ? 0.79 : 0.93)
        : (helpSpeedMLv50 == 0.86 ? 0.86 : 1.00);
    /* FL (Lv 100) 食材M確認 */ final ingredientMLv100 = _subSkillsContains(SubSkill.ingredientRateM, 100) ? 1.36 : 1.0;
    /* FM (Lv 100) 食材S+M確認 */ final ingredientSMLv100 = _subSkillsContains(SubSkill.ingredientRateS, 100)
        ? (ingredientMLv100 == 1.36 ? 1.54 : 1.18)
        : (ingredientMLv100 == 1.36 ? 1.36 : 1.00);
    /* FN (Lv 100) 技能幾率M確認 */ final skillRateMLv100 = _subSkillsContains(SubSkill.skillRateM, 100) ? 1.36 : 1.0;
    /* FO (Lv 100) 技能幾率S+M確認 */ final skillRateSMLv100 = _subSkillsContains(SubSkill.skillRateS, 100)
        ? (skillRateMLv100 == 1.36 ? 1.54 : 1.18)
        : (skillRateMLv100 == 1.36 ? 1.36 : 1.00);
    /* FP (Lv 100) 加成後主技能等級 */
    final fpLv100 = _mainSkillLv 
        + (_subSkillsContains(SubSkill.skillLevelM, 100) ? 2 : 0) 
        + (_subSkillsContains(SubSkill.skillLevelS, 100) ? 1 : 0)
        + 3
        - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3);
    /* DA (Lv 100) 食材機率 */
    final daLv100 = _tc(() => 0.2 * ingredientSMLv100
        * (
            character.positive == '食材發現' ? 1.2
                : character.negative == '食材發現' ? 0.8
                : 1.0
        ),
    );
    /* CY (100計算) 果子機率 */ final cyLv100 = 1 - daLv100;
    /* BF 100間隔 */ final bfLv100 = _tc(() => maxHelpIntervalAdjust1 - (maxHelpIntervalAdjust1 * ((100-1) * 0.002)),) * helpSpeedSMLv100;
    /* CZ (100計算) 果實預期次數/h */ final czLv100 = _tc(() => 3600 / bfLv100 * cyLv100);
    /* DB (100計算) 食材預期次數/h */ final dbLv100 = _tc(() => 3600 / bfLv100 * daLv100);
    /* DC (100計算) 食材1個數/h */ final dcLv100 = _tc(() => dbLv100 * (isIngredientSpecialty ? 2 : 1)) / 3.0;

    /* DD (100計算) 食材2個數/h */ final ddLv100 = _tc(() => dbLv100 * ingredientCount2) / 3.0;
    /* DE (100計算) 食材3個數/h */ final deLv100 = _tc(() => dbLv100 * ingredientCount3) / 3.0;
    /* DF (100收益) 樹果能量/h, GN (Lv100Result) 樹果能量/h */ final dfLv100 = _tc(() => czLv100 * fruitEnergyAfterSnorlaxFavoriteLv100);
    /* DG (100收益) 食材個/h, GO (Lv100Result) 食材個/h */ final dgLv100 = dcLv100 + ddLv100 + deLv100;
    /* DH (100收益) 食材能量/h, GP (Lv100Result) */ final dhLv100 = _tc(() => dcLv100 * ingredientEnergy1 + ddLv100 * ingredientEnergy2 + deLv100 * ingredientEnergy3);
    /* DI (100收益) 技能次數/d, GQ (Lv100Result) */
    final diLv100 = _tc(() => (
        skillRateSMLv100 * 3600 / bfLv100 * _transUserVitality()
            * (character.negative == '主技能' ? 0.8 : character.positive == '主技能' ? 1.2 : 1)
    )
        + (isSkillSpecialty ? 0.2 : 0)
        + 0.25 * (fpLv100 - 1)
        + 0.2,
    );
    /* DJ (100收益) 主技能效益/h, GR (Lv100Result) */
    final djLv100 = _tc(() =>
    (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (dfLv100 + dhLv100) * _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[fpLv100.toInt() - 1] :
        _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[fpLv100.toInt() - 1]
    ),
    ) * diLv100;
    /* DL (100白板計算) 果實預期次數/h */ final dlLv100 = _tc(() => 3600 / maxHelpIntervalLv100 * fruitRate);
    /* DN (100白板計算) 食材預期次數/h */ final dnLv100 = _tc(() => 3600 / maxHelpIntervalLv100 * ingredientRate);
    /* DO (100白板計算) 食材1個數/h */ final doLv100 = _tc(() => dnLv100 * (isIngredientSpecialty ? 2 : 1))/3;
    /* DP (100白板計算) 食材2個數/h */ final dpLv100 = _tc(() => dnLv100 * ingredientCount2) / 3.0;
    /* DQ (100白板計算) 食材3個數/h */ final dqLv100 = _tc(() => dnLv100 * ingredientCount3) / 3.0;
    /* DR (100白板收益) 樹果能量/h */ final drLv100 = _tc(() => fruitEnergyLv100 * dlLv100 * (isBerrySpecialty ? 2 : 1) * (_isSnorlaxFavorite ? 2 : 1));
    /* DS (100白板收益) 食材個/h */ final dsLv100 = doLv100 + dpLv100 + dqLv100;
    /* DT (100白板收益) 食材能量/h */ final dtLv100 = _tc(() => doLv100 * ingredientEnergy1 + dpLv100 * ingredientEnergy2 + dqLv100 * ingredientEnergy3);
    /* DV (100白板) 主技能效益/h */
    final dvLv100 = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (drLv100+dtLv100) * _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[(_mainSkillLv + 3-_tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1] :
        _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[(_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1]
    )
    ) * duLv100;
    /* (Lv100Result) GU 100收益/h */ final guLv100 = _tc(() =>
    dfLv100 + dhLv100 + djLv100 + (_subSkillsContains(SubSkill.helperBonus, 100) ? ha4 : 0)
    );
    /* GS (Lv100Result) 100自身收益/h */
    final gsLv100 = _tc(() =>
    dfLv100+dhLv100+djLv100*
        (
            basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS?
            0 :
            1
        )+
        (_subSkillsContains(SubSkill.helperBonus, 100) ? ha4/5 : 0)
    );
    /* (Lv100Result) GT 100輔助隊友收益/h */ final gtLv100 = guLv100 - gsLv100;
    /* (Lv100Result) GV 100白板/h */ final gvLv100 = drLv100 + dtLv100 + dvLv100;
    /* (Lv100Result) GW 影響 */ final gwLv100 = bLvCurr == 0 ? 0 : (guLv100 - gvLv100) / gvLv100;
    // endregion
























    /* (Rank) GX 50評級 */
    final gx = bLvCurr == 0 ? '-' :
    gmLv50 >= 1 ? 'S' :
    gmLv50 >= 0.8 ? 'A' :
    gmLv50 >= 0.6 ? 'B' :
    gmLv50 >= 0.4 ? 'C' :
    gmLv50 >= 0.2 ? 'D' :
    gmLv50 >= 0 ? 'E' :
    gmLv50 < 0 ? 'F' : '-';

    /* (Rank) GY 100評級 */
    final gy = bLvCurr == 0 ? '-' :
    gwLv100 >= 1.5 ? 'S+' :
    gwLv100 >= 1 ? 'S' :
    gwLv100 >= 0.8 ? 'A' :
    gwLv100 >= 0.6 ? 'B' :
    gwLv100 >= 0.4 ? 'C' :
    gwLv100 >= 0.2 ? 'D' :
    gwLv100 >= 0 ? 'E' :
    gwLv100 < 0 ? 'F' : '-';

    /* (Rank) GZ 100時收益 */
    final rankLv100 = (
        guLv100 > 10000 ? "★★★★★" :
        guLv100 > 9000 ? "★★★★☆" :
        guLv100 > 8000 ? "★★★☆☆" :
        guLv100 > 7000?"★★☆☆☆":
        guLv100 > 6000 ? "★☆☆☆☆" :
        guLv100 > 5000 ? "☆☆☆☆☆" :
        guLv100 > 4000 ? "☆☆☆☆" :
        guLv100 > 3000 ? "☆☆☆" :
        guLv100 > 2000 ? "☆☆" :
        guLv100 > 1000 ? "☆" :
        guLv100 > 0 ? "" : "-"
    );

    /* A 評級 */
    final a = (bLvCurr == 0 ? '-' :
    cLvCurr >= 0.3 ? 'S' :
    cLvCurr >= 0.24 ? 'A' :
    cLvCurr >= 0.18 ? 'B' :
    cLvCurr >= 0.12 ? 'C' :
    cLvCurr >= 0.06 ? 'D' :
    cLvCurr >= 0 ? 'E' :
    cLvCurr < 0 ? 'F' : '-') + gx + gy + rankLv100;

    _isInitialized = true;

    return switch (type) {
      _Type.userView => PokemonProfileStatistics2Result(
        profile, gx, gy,
      ),
      _Type.dev => [
        {
          'type': 'table',
          'title': '技能加成確認',
          'cells': [
            [
              '',
              '樹果+1確認',
              '幫忙M確認',
              '幫忙S+M確認',
              '食材M確認',
              '食材S+M確認',
              '技能幾率M確認',
              '技能幾率S+M確認',
              '加成後主技能等級',
            ],
            [
              '當前等級',
              Display.numDouble(fruitBonusEnergy),
              Display.numDouble(helpSpeedMLvCurr),
              Display.numDouble(helpSpeedSMLvCurr),
              Display.numDouble(ingredientMLvCurr),
              Display.numDouble(ingredientSMLvCurr),
              Display.numDouble(skillRateMLvCurr),
              Display.numDouble(skillRateSMLvCurr),
              Display.numDouble(erLvCurr),
            ],
            [
              'Lv 50',
              Display.numDouble(fruitBonusEnergyLv50),
              Display.numDouble(helpSpeedMLv50),
              Display.numDouble(helpSpeedSMLv50),
              Display.numDouble(ingredientMLv50),
              Display.numDouble(ingredientSMLv50),
              Display.numDouble(skillRateMLv50),
              Display.numDouble(skillRateSMLv50),
              Display.numDouble(fcLv50),
            ],
            [
              'Lv 100',
              Display.numDouble(fruitBonusEnergyLv100),
              Display.numDouble(helpSpeedMLv100),
              Display.numDouble(helpSpeedSMLv100),
              Display.numDouble(ingredientMLv100),
              Display.numDouble(ingredientSMLv100),
              Display.numDouble(skillRateMLv100),
              Display.numDouble(skillRateSMLv100),
              Display.numDouble(fpLv100),
            ],
          ],
        },
        {
          'type': 'table',
          'title': '樹果',
          'cells': [
            [
              '',
              '能量/顆',
              '能量/顆\n(+專長/技能加成)',
              '能量/顆\n(+卡比獸喜好)',
            ],
            [
              '當前等級',
              Display.numDouble(fruitEnergyLvCurr),
              Display.numDouble(fruitEnergyAfterSpecialtyAndSubSkillLvCurr),
              Display.numDouble(fruitEnergyAfterSnorlaxFavorite),
            ],
            [
              'Lv50',
              Display.numDouble(fruitEnergyLv50),
              Display.numDouble(fruitEnergyAfterSpecialtyAndSubSkillLv50),
              Display.numDouble(fruitEnergyAfterSnorlaxFavoriteLv50),
            ],
            [
              'Lv100',
              Display.numDouble(fruitEnergyLv100),
              Display.numDouble(fruitEnergyAfterSpecialtyAndSubSkillLv100),
              Display.numDouble(fruitEnergyAfterSnorlaxFavoriteLv100),
            ],
            // [
            //   Display.numDouble(000000),
            //   Display.numDouble(000000),
            //   Display.numDouble(000000),
            //   Display.numDouble(000000),
            // ],
          ],
        },
        {
          'type': 'table',
          'title': '幫忙時間',
          'cells': [
            [
              '',
              '基礎',
              '+等級調整',
              '+性格/技能調整',
              '+活力影響',
            ],
            [
              '',
              Display.numDouble(helpInterval),
              '',
              '',
              '',
            ],
            [
              '當前等級',
              '',
              Display.numDouble(helpIntervalLvCurr1),
              Display.numDouble(helpIntervalLvCurr2),
              Display.numDouble(helpIntervalLvCurr3),
            ],
            [
              'Lv50',
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
            ],
            [
              'Lv100',
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
            ],
            // [
            //   '',
            //   Display.numDouble(000000),
            //   Display.numDouble(000000),
            //   Display.numDouble(000000),
            // ],
          ],
        },
        {
          'type': 'table',
          'subtitle': '幫忙時間 (白版)',
          'cells': [
            [
              '',
              '基礎',
              '+等級調整',
              '+活力調整',
              '',
            ],
            [
              '',
              Display.numDouble(helpInterval),
              '',
              '',
              '',
            ],
            [
              '當前等級',
              '',
              Display.numDouble(helpIntervalLvCurr1),
              Display.numDouble(helpIntervalPureLvCurr),
              Display.numDouble(0),
            ],
            [
              'Lv50',
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
            ],
            [
              'Lv100',
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
              Display.numDouble(000000),
            ],
          ],
        },
        {
          'type': 'table',
          'subtitle': '幫忙時間 (最高階進化)',
          'cells': [
            [
              '',
              '基礎',
              '+性格/活力調整',
              '+等級/副技能調整',
              '',
            ],
            [
              '',
              Display.numDouble(maxHelpInterval),
              Display.numDouble(maxHelpIntervalAdjust1),
              '',
              '',
            ],
            [
              '當前等級',
              '',
              Display.numDouble(0),
              Display.numDouble(0),
              Display.numDouble(0),
            ],
            [
              'Lv50',
              '',
              '',
              Display.numDouble(bdLv50),
              Display.numDouble(000000),
            ],
            [
              'Lv100',
              '',
              Display.numDouble(000000),
              Display.numDouble(bfLv100),
              Display.numDouble(000000),
            ],
          ],
        },
        {
          'type': 'table',
          'subtitle': '幫忙時間 (最高階進化、白板)',
          'cells': [
            [
              '',
              '基礎',
              '+等級/活力調整',
              '',
              '',
            ],
            [
              '',
              Display.numDouble(maxHelpInterval),
              Display.numDouble(0),
              '',
              '',
            ],
            [
              '當前等級',
              '',
              Display.numDouble(0),
              Display.numDouble(0),
              Display.numDouble(0),
            ],
            [
              'Lv50',
              '',
              Display.numDouble(beLv50),
              '',
              Display.numDouble(000000),
            ],
            [
              'Lv100',
              '',
              Display.numDouble(maxHelpIntervalLv100),
              Display.numDouble(000000),
              Display.numDouble(000000),
            ],
          ],
        },
        {
          'type': 'table',
          'title': '樹果 & 食材',
          'cells': [
            [
              '',
              '樹果機率\n(+副技能/性格)',
              '果實預期次數/h',
              '食材機率\n(+副技能/性格)',
              '食材預期次數/h',
              '食材1\n個數',
              '食材2\n個數',
              '食材3\n個數',
            ],
            [
              '當前等級\n(加成後)',
              Display.numDouble(fruitRateLvCurr1),
              Display.numDouble(biLvCurr),
              Display.numDouble(bjLvCurr),
              Display.numDouble(ingredientCountPerHourLvCurr),
              Display.numDouble(ingredient1CountPerHourAfterAdjustLvCurr),
              Display.numDouble(ingredient2CountPerHourAfterAdjustLvCurr),
              Display.numDouble(ingredient3CountPerHourAfterAdjustLvCurr),
            ],
            [
              '當前等級\n(白板)',
              Display.numDouble(fruitRate),
              Display.numDouble(bpLvCurr),
              Display.numDouble(ingredientRate),
              Display.numDouble(brLvCurr),
              Display.numDouble(bsLvCurr),
              Display.numDouble(btLvCurr),
              Display.numDouble(buLvCurr),
            ],
            [
              'Lv50\n(加成後)',
              Display.numDouble(fruitRateLv50),
              Display.numDouble(cbLv50),
              Display.numDouble(ingredientRateLv50),
              Display.numDouble(cdLv50),
              Display.numDouble(ceLv50),
              Display.numDouble(cfLv50),
              Display.numDouble(ingredientCount3Lv50),
            ],
            [
              'Lv50\n(白板)',
              Display.numDouble(fruitRate),
              Display.numDouble(cnLv50),
              Display.numDouble(ingredientRate),
              Display.numDouble(cpLv50),
              Display.numDouble(cqLv50),
              Display.numDouble(crLv50),
              Display.numDouble(ingredientCount3Lv50),
            ],
            [
              'Lv100\n(加成後)',
              Display.numDouble(cyLv100),
              Display.numDouble(czLv100),
              Display.numDouble(daLv100),
              Display.numDouble(dbLv100),
              Display.numDouble(dcLv100),
              Display.numDouble(ddLv100),
              Display.numDouble(deLv100),
            ],
            [
              'Lv100\n(白板)',
              Display.numDouble(fruitRate),
              Display.numDouble(dlLv100),
              Display.numDouble(ingredientRate),
              Display.numDouble(dnLv100),
              Display.numDouble(doLv100),
              Display.numDouble(dpLv100),
              Display.numDouble(dqLv100),
            ],
          ],
        },
        {
          'type': 'table',
          'subtitle': '樹果 & 食材收益',
          'cells': [
            [
              '',
              '樹果能量/h',
              '食材個/h',
              '食材能量/h',
              '主技能發動次數/d',
              '主技能效益/h',
              '食材換算成碎片/h',
              '|',
              '總收益/h', // = 樹果能量/h + 食材能量/h + 主技能效益/h
              '影響', // 相較白板
            ],
            [
              '當前等級\n(加成後)',
              Display.numDouble(zLvCurr),
              Display.numDouble(aiLvCurr),
              Display.numDouble(ajLvCurr),
              Display.numDouble(vLvCurr),
              Display.numDouble(wLvCurr),
              Display.numDouble(akLvCurr),
              '',
              Display.numDouble(eLvCurr),
              '${cLvCurr > 0 ? '+' : cLvCurr < 0 ? '-' : ''}${Display.numDouble(cLvCurr * 100)}%',
            ],
            [
              '當前等級\n(白板)',
              Display.numDouble(bvLvCurr),
              Display.numDouble(bwLvCurr),
              Display.numDouble(bxLvCurr),
              Display.numDouble(byLvCurr),
              Display.numDouble(bzLvCurr),
              '',
              '',
              Display.numDouble(bLvCurr),
              '',
            ],
            [
              'Lv50\n(加成後)',
              Display.numDouble(chLv50),
              Display.numDouble(ciLv50),
              Display.numDouble(cjLv50),
              Display.numDouble(ckLv50),
              Display.numDouble(clLv50),
              '',
              '',
              '',
              '',
            ],
            [
              'Lv50\n(白板)',
              Display.numDouble(ctLv50),
              Display.numDouble(cuLv50),
              Display.numDouble(cvLv50),
              Display.numDouble(cwLv50),
              Display.numDouble(cxLv50),
              '',
              '',
              '',
              '',
            ],
            [
              'Lv100\n(加成後)',
              Display.numDouble(dfLv100),
              Display.numDouble(dgLv100),
              Display.numDouble(dhLv100),
              Display.numDouble(diLv100),
              Display.numDouble(djLv100),
              '',
              '',
              '',
              '',
            ],
            [
              'Lv100\n(白板)',
              Display.numDouble(drLv100),
              Display.numDouble(dsLv100),
              Display.numDouble(dtLv100),
              Display.numDouble(duLv100),
              Display.numDouble(dvLv100),
              '',
              '',
              '',
              '',
            ],
          ],
        },
        {
          'type': 'table',
          'title': '結算表',
          'cells': [
            [
              '',
              '樹果能量/h',
              '食材個/h',
              '食材能量/h',
              '技能次數/d',
              '主技能效益/h',
              '50自身收益/h',
              '50輔助隊友收益/h',
              '收益/h',
              '50白板/h',
              '影響',
            ],
            [
              'Lv 50',
              Display.numDouble(chLv50),
              Display.numDouble(ciLv50),
              Display.numDouble(cjLv50),
              Display.numDouble(ckLv50),
              Display.numDouble(clLv50),
              Display.numDouble(giLv50),
              Display.numDouble(gjLv50),
              Display.numDouble(gkLv50),
              Display.numDouble(glLv50),
              '${Display.numDouble(gmLv50 * 100)}%',
            ],
            [
              'Lv 100',
              Display.numDouble(dfLv100),
              Display.numDouble(dgLv100),
              Display.numDouble(dhLv100),
              Display.numDouble(diLv100),
              Display.numDouble(djLv100),
              Display.numDouble(gsLv100),
              Display.numDouble(gtLv100),
              Display.numDouble(guLv100),
              Display.numDouble(gvLv100),
              '${Display.numDouble(gwLv100 * 100)}%',
            ],
          ],
        },
        {
          'type': 'table',
          'subtitle': '收益',
          'cells': [
            [
              '',
              '自身收益/h',
              '+',
              '輔助隊友收益/h',
              '=',
              '理想總收益/h',
            ],
            [
              '當前等級',
              Display.numDouble(fLvCurr),
              '',
              Display.numDouble(gLvCurr),
              '',
              Display.numDouble(eLvCurr),
            ],
          ],
        },
        {
          'type': 'table',
          'subtitle': '評級',
          'cells': [
            [
              '',
              '評級',
              '收益',
            ],
            [
              'Lv 50',
              gx,
              '',
            ],
            [
              'Lv 100',
              gy,
              rankLv100,
            ],
          ],
        },
      ],
    };
  }

  // region Formulas
  double _transUserVitality() {
    return _userVitality == 5 ? 0.4
        : _userVitality == 4 ? 0.5
        : _userVitality == 3 ? 0.6
        : _userVitality == 2 ? 0.8
        : _userVitality == 1 ? 1.0
        : 1.0;
  }

  bool _subSkillsContains(SubSkill subSkill, int level) {
    return _getSubSkillsByLevel(level).contains(subSkill);
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
        '${mainSkill.nameI18nKey.xTr}: ${_calcMainSkillEnergyListLv50(mainSkill).map((e) => e.toStringAsFixed(2)).join(',')}',
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
          if (m == MainSkill.finger || m == MainSkill.vitalityFillS) {
            continue;
          }
          values.add(_calcMainSkillEnergyList(m));
        }
        return List.generate(6, (i) => values.map((e) => e[i]).reduce((a, b) => a + b) / values.length);
    }
  }

  List<double> _calcMainSkillEnergyListLv50(MainSkill mainSkill) {
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
        return v.map((e) => e * _helperAvgScoreLv50 * 0.01 / 24.0).toList();
      case MainSkill.vitalityAllS:
      // 活力係數，不知怎得的
        final v = [61.331, 87.596, 114.851, 143.097, 202.310, 248.886];
        return v.map((e) => e * 5 * _helperAvgScoreLv50 * 0.01 / 24.0).toList();
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
          values.add(_calcMainSkillEnergyListLv50(m));
        }
        return List.generate(6, (i) => values.map((e) => e[i]).reduce((a, b) => a + b) / values.length);
    }
  }

  List<double> _calcMainSkillEnergyListLv100(MainSkill mainSkill) {
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
        return v.map((e) => e * _helperAvgScoreLv100 * 0.01 / 24.0).toList();
      case MainSkill.vitalityAllS:
      // 活力係數，不知怎得的
        final v = [61.331, 87.596, 114.851, 143.097, 202.310, 248.886];
        return v.map((e) => e * 5 * _helperAvgScoreLv100 * 0.01 / 24.0).toList();
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
          values.add(_calcMainSkillEnergyListLv100(m));
        }
        return List.generate(6, (i) => values.map((e) => e[i]).reduce((a, b) => a + b) / values.length);
    }
  }

  /// [level 1~100]
  int _getSingleFruitEnergy(int level) {
    assert(level >= 1 && level <= 100);

    if (level == 25) {
      final a = fruit.getLevels();
    }

    return fruit.getLevels()[level - 1];
  }

  // endregion Formulas

}