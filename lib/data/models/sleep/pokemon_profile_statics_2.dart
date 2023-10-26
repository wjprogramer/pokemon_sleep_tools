import 'package:flutter/foundation.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

/// 運算公式來源：「https://bbs.nga.cn/read.php?tid=37305277」
class PokemonProfileStatistics2 {
  PokemonProfileStatistics2(this.profile);

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Profile properties
  final PokemonProfile profile;
  PokemonBasicProfile get basicProfile => profile.basicProfile;
  /* AW 基礎間隔 */int get helpInterval => basicProfile.maxHelpInterval;
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
  int get ingredientCount2 => profile.ingredientCount2;
  int get ingredientCount3 => profile.ingredientCount3;
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

  List<dynamic> init() {
    final res = <dynamic>[];

    /* $GY$4 */ final gy4 = _helperAvgScoreLv50 * 5 * 0.05;
    /* $HA$4 */ final ha4 = _helperAvgScoreLv100 * 5 * 0.05;

    // 帮手计算估分
    /* $O$4 */ final o4 = _helperAvgScore * 5 * 0.05 * q4;

    /* AE 個數 */ final ae = ingredientCount2;
    /* AH 個數 */ final ah = ingredientCount3;

    /* (當前等級) AL 果子/顆 */ final fruitEnergyLvCurr = _getSingleFruitEnergy(_level);
    /* (當前等級) EK 樹果+1確認 */ final fruitBonusEnergy = _subSkillsContains(SubSkill.berryCountS, _level) ? fruitEnergyLvCurr : 0.0;
    /* (當前等級) AM 類型與技能加成/顆 */ final fruitEnergyAfterSpecialtyAndSubSkillLvCurr = fruitEnergyLvCurr * (isBerrySpecialty ? 2 : 1) + fruitBonusEnergy;
    /* (當前等級) AN +喜愛加成/顆 */ final fruitEnergyAfterSnorlaxFavorite = fruitEnergyAfterSpecialtyAndSubSkillLvCurr * (_isSnorlaxFavorite && _shouldConsiderSnorlaxFavorite ? 2 : 1);
    /* (當前等級) EL 幫忙M確認 */ final helpSpeedMLvCurr = _subSkillsContains(SubSkill.helpSpeedM, _level) ? 0.86 : 1.0;
    /* (當前等級) EM 幫忙S+M確認: */ final helpSpeedSMLvCurr = _subSkillsContains(SubSkill.helpSpeedS, _level)
        ? (helpSpeedMLvCurr == 0.86 ? 0.79 : 0.93)
        : (helpSpeedMLvCurr == 0.86 ? 0.86 : 1.00);

    /* AO (Lv 50) 果子/顆 */ final fruitEnergyLv50 = _getSingleFruitEnergy(50);
    /* EV (Lv 50) 樹果+1確認 */ final fruitBonusEnergyLv50 = _subSkillsContains(SubSkill.berryCountS, 50) ? fruitEnergyLv50 : 0.0;
    /* AP (Lv 50) 類型與技能加成/顆 */ final fruitEnergyAfterSpecialtyAndSubSkillLv50 = fruitEnergyLv50 * (isBerrySpecialty ? 2 : 1) + fruitBonusEnergyLv50;
    /* AQ (Lv 50) +喜愛加成/顆 */ final fruitEnergyAfterSnorlaxFavoriteLv50 = fruitEnergyAfterSpecialtyAndSubSkillLv50 * (_isSnorlaxFavorite && _shouldConsiderSnorlaxFavorite ? 2 : 1);

    /* AR (Lv 100) 果子/顆 */ final fruitEnergyLv100 = _getSingleFruitEnergy(100);
    /* FI (Lv 100) 樹果+1確認 */ final fruitBonusEnergyLv100 = _subSkillsContains(SubSkill.berryCountS, 100) ? fruitEnergyLv100 : 0.0;
    /* AS (Lv 100) 類型與技能加成/顆 */ final fruitEnergyAfterSpecialtyAndSubSkillLv100 = fruitEnergyLv100 * (isBerrySpecialty ? 2 : 1) + fruitBonusEnergyLv100;
    /* AT (Lv 100) +喜愛加成/顆 */ final fruitEnergyAfterSnorlaxFavoriteLv100 = fruitEnergyAfterSpecialtyAndSubSkillLv100 * (_isSnorlaxFavorite && _shouldConsiderSnorlaxFavorite ? 2 : 1);

    /* AX 等級調整 */ final helpIntervalLvCurr1 = helpInterval - (helpInterval * ((_level - 1) * 0.002));
    /* AY 性格+技能調整 */ final helpIntervalLvCurr2 = _tc(() => helpIntervalLvCurr1 * helpSpeedSMLvCurr
        * (
            character.positive == '幫忙速度' ? 0.9
                : character.negative == '幫忙速度' ? 1.1
                : 1.0
        ),
    );
    /* AZ 活力影響後 */ final helpIntervalLvCurr3 = helpIntervalLvCurr2 * _transUserVitality();
    /* BA 白板-活力影響 */ final helpIntervalPureLvCurr = _tc(() => helpIntervalLvCurr1 * _transUserVitality());

    /* BC 性格+活力調整 */
    final maxHelpIntervalAdjust1 = _tc(() => maxHelpInterval *
        (
            character.positive == '幫忙速度' ? 0.9
                : character.negative == '幫忙速度' ? 1.1
                : 1.0
        ) * _transUserVitality()
    );
    /* (Lv 50) EW 幫忙M確認 */ final helpSpeedMLv50 = _subSkillsContains(SubSkill.helpSpeedM, 50) ? 0.86 : 1.0;
    /* (Lv 50) EX 幫忙S+M確認 */ final helpSpeedSMLv50 = _subSkillsContains(SubSkill.helpSpeedS, 50)
        ? (helpSpeedMLv50 == 0.86 ? 0.79 : 0.93)
        : (helpSpeedMLv50 == 0.86 ? 0.86 : 1.00);

    /* BD 50間隔 */ final bd = _tc(() => maxHelpIntervalAdjust1 - (maxHelpIntervalAdjust1 * ((50-1) * 0.002))) * helpSpeedSMLv50;

    /* BE 50白板活力 */ final be = _tc(() => (maxHelpInterval - (maxHelpInterval * ((50-1)*0.002)))*_transUserVitality());
    /* BG 100白板活力 */ final maxHelpIntervalLv100 = _tc(() => (maxHelpInterval - (maxHelpInterval * ((100-1)*0.002))) * _transUserVitality());

    /* DU (100白板) 次數/h */ final du = _tc(() => 3600/maxHelpIntervalLv100 *_transUserVitality() +
        (isSkillSpecialty ? 0.2 : 0)+ _ccc2 * (_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)-1) + _ccc1,
    );

    /* DW 食材1售價 */ final iPrice1 = _getIngredientPrice(ingredient1);
    /* DX 食材2售價 */ final iPrice2 = _getIngredientPrice(ingredient2);
    /* DY 食材3售價 */ final iPrice3 = _getIngredientPrice(ingredient3);
    /* DZ 食材1能量 */ final dz = ingredient1.energy;
    /* EA 食材2能量 */ final ea = ingredient2.energy;
    /* EB 食材3能量 */ final eb = ingredient3.energy;

    /* (當前等級) EN 食材M確認 */ final ingredientMLvCurr = _subSkillsContains(SubSkill.ingredientRateM, _level) ? 1.36 : 1.0;
    /* (當前等級) EO 食材S+M確認 */ final ingredientSMLvCurr = _subSkillsContains(SubSkill.ingredientRateS, _level)
        ? (ingredientMLvCurr == 1.36 ? 1.54 : 1.18)
        : (ingredientMLvCurr == 1.36 ? 1.36 : 1.00);
    /* (當前等級) EP 技能幾率M確認 */ final skillRateMLvCurr = _subSkillsContains(SubSkill.skillRateM, _level) ? 1.36 : 1.0;
    /* (當前等級) EQ 技能幾率S+M確認 */ final skillRateSMLvCurr = _subSkillsContains(SubSkill.skillRateS, _level)
        ? (skillRateMLvCurr == 1.36 ? 1.54 : 1.18)
        : (skillRateMLvCurr == 1.36 ? 1.36 : 1.00);
    /* ER 加成後主技能等級 */
    final er = _mainSkillLv +
        (_subSkillsContains(SubSkill.skillLevelM, _level) ? 2 : 0) +
        (_subSkillsContains(SubSkill.skillLevelS, _level) ? 1 : 0);

    /* (Lv 50) EY 食材M確認 */ final ingredientMLv50 = _subSkillsContains(SubSkill.ingredientRateM, 50) ? 1.36 : 1.0;
    /* (Lv 50) EZ 食材S+M確認 */ final ingredientSMLv50 = _subSkillsContains(SubSkill.ingredientRateS, 50)
        ? (ingredientMLv50 == 1.36 ? 1.54 : 1.18)
        : (ingredientMLv50 == 1.36 ? 1.36 : 1.00);
    /* (Lv 50) FA 技能幾率M確認 */ final skillRateMLv50 = _subSkillsContains(SubSkill.skillRateM, 50) ? 1.36 : 1.0;
    /* (Lv 50) FB 技能幾率S+M確認 */ final skillRateSMLv50 = _subSkillsContains(SubSkill.skillRateS, 50)
        ? (skillRateMLv50 == 1.36 ? 1.54 : 1.18)
        : (skillRateMLv50 == 1.36 ? 1.36 : 1.00);
    /* (Lv 50) FC 加成後主技能等級 */
    final fc = _mainSkillLv +
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
    /* CB (50計算) 果實預期次數/h */ final cb = _tc(() => 3600 / bd * fruitRateLv50);
    /* BJ (加成後) 食材機率 */
    final bj = _tc(() => 0.2 * ingredientSMLvCurr
        * (
            character.positive == '食材發現' ? 1.2
                : character.negative == '食材發現' ? 0.8
                : 1.0
        )
    );
    /* BH (加成後) 果子機率 */ final fruitRateLvCurr1 = 1 - bj;
    /* BK (加成後) 食材預期次數/h */ final ingredientCountPerHourLvCurr = _tc(() => 3600 / helpIntervalLvCurr3 * bj);
    /* BI (加成後) 果實預期次數/h */ final bi = _tc(() => 3600 / helpIntervalLvCurr3 * fruitRateLvCurr1);
    /* BL (加成後) 食材1個數/h */
    final ingredient1CountPerHourAfterAdjustLvCurr = _tc(() => ingredientCountPerHourLvCurr * (isIngredientSpecialty ? 2 : 1))
        * (_level > 59 ? 1/3 : (_level > 29 ? 1/2 : 1));
    /* BM (加成後) 食材2個數/h */ final ingredient2CountPerHourAfterAdjustLvCurr = _tc(() => (_level>29 ? ingredientCountPerHourLvCurr * ae : 0),) * (_level > 59 ? 1/3 : 1/2);
    /* BN (加成後) 食材3個數/h */ final ingredient3CountPerHourAfterAdjustLvCurr = _tc(() => (_level>59 ? ingredientCountPerHourLvCurr * ah: 0)) / 3;
    /* AJ 食材能量/h */ final aj = _tc(() => ingredient1CountPerHourAfterAdjustLvCurr * dz + ingredient2CountPerHourAfterAdjustLvCurr * ea + ingredient3CountPerHourAfterAdjustLvCurr * eb);
    /* AI 食材個/h */ final ai = ingredient1CountPerHourAfterAdjustLvCurr + ingredient2CountPerHourAfterAdjustLvCurr + ingredient3CountPerHourAfterAdjustLvCurr;
    /* AK 食材換算成碎片/h */ final ak = _tc(() => ingredient1CountPerHourAfterAdjustLvCurr * iPrice1 + ingredient2CountPerHourAfterAdjustLvCurr * iPrice2 + ingredient3CountPerHourAfterAdjustLvCurr * iPrice3);

    /* FJ (Lv 100) 幫忙M確認 */ final helpSpeedMLv100 = _subSkillsContains(SubSkill.helpSpeedM, 100) ? 0.86 : 1.0;
    /* FK (Lv 100) 幫忙S+M確認 */ final helpSpeedSMLv100 = _subSkillsContains(SubSkill.helpSpeedS, 100)
        ? (helpSpeedMLv50 == 0.86 ? 0.79 : 0.93)
        : (helpSpeedMLv50 == 0.86 ? 0.86 : 1.00);
    /* FL (Lv 100) 食材M確認 */ final ingredientMLv100 = _subSkillsContains(SubSkill.ingredientRateM, 100) ? 1.36 : 1.0;
    /* FM (Lv 100) 食材S+M確認 */ final ingredientSMLv100 = _subSkillsContains(SubSkill.ingredientRateS, 100)
        ? (ingredientMLvCurr == 1.36 ? 1.54 : 1.18)
        : (ingredientMLvCurr == 1.36 ? 1.36 : 1.00);
    /* FN (Lv 100) 技能幾率M確認 */ final skillRateMLv100 = _subSkillsContains(SubSkill.skillRateM, 100) ? 1.36 : 1.0;
    /* FO (Lv 100) 技能幾率S+M確認 */ final skillRateSMLv100 = _subSkillsContains(SubSkill.skillRateS, 100)
        ? (skillRateMLvCurr == 1.36 ? 1.54 : 1.18)
        : (skillRateMLvCurr == 1.36 ? 1.36 : 1.00);
    /* FP (Lv 100) 加成後主技能等級 */
    final fp = _mainSkillLv +
        (_subSkillsContains(SubSkill.skillLevelM, 100) ? 2 : 0) +
        (_subSkillsContains(SubSkill.skillLevelS, 100) ? 1 : 0) +
        3 -
        _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3);
    /* DA (Lv 100) 食材機率 */
    final da = _tc(() => 0.2 * ingredientSMLv100
        * (
            character.positive == '食材發現' ? 1.2
                : character.negative == '食材發現' ? 0.8
                : 1.0
        ),
    );
    /* CY (100計算) 果子機率 */ final cy = 1 - da;
    /* BF 100間隔 */ final bf = _tc(() => maxHelpIntervalAdjust1 - (maxHelpIntervalAdjust1 * ((100-1) * 0.002)),) * helpSpeedSMLv100;
    /* CZ (100計算) 果實預期次數/h */ final cz = _tc(() => 3600 / bf * cy);
    /* DB (100計算) 食材預期次數/h */ final db = _tc(() => 3600 / bf * da);
    /* DC (100計算) 食材1個數/h */ final dc = _tc(() => db * (isIngredientSpecialty ? 2 : 1)) / 3.0;

    /* DD (100計算) 食材2個數/h */ final dd = _tc(() => db * ae) / 3.0;
    /* DE (100計算) 食材3個數/h */ final de = _tc(() => db * ah) / 3.0;
    /* DF (100收益) 樹果能量/h */ final df = _tc(() => cz * fruitEnergyAfterSnorlaxFavoriteLv100);
    /* DG (100收益) 食材個/h */ final dg = dc + dd + de;
    /* DH (100收益) 食材能量/h */ final dh = _tc(() => dc * dz + dd * ea + de * eb);
    /* DI (100收益) 次數/h */
    final di = _tc(() => (
        skillRateSMLv100 * 3600 / bf * _transUserVitality()
            * (character.negative == '主技能' ? 0.8 : character.positive == '主技能' ? 1.2 : 1)
    )
        + (isSkillSpecialty ? 0.2 : 0)
        + 0.25 * (fp - 1)
        + 0.2,
    );
    /* DJ (100收益) 主技能效益/h */
    final dj = _tc(() =>
      (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (df+dh) * _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[fp.toInt() - 1] :
        _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[fp.toInt() - 1]
      ),
    ) * di;
    /* DM (100白板計算) 食材機率 */ const dm = 0.2; // TODO: 感覺應該根據 BasicProfile 的食材機率
    /* DK (100白板計算) 果子機率 */ final dk = 1 - dm;
    /* DL (100白板計算) 果實預期次數/h */ final dl = _tc(() => 3600 / maxHelpIntervalLv100 * dk);
    /* DN (100白板計算) 食材預期次數/h */ final dn = _tc(() => 3600 / maxHelpIntervalLv100 * dm);
    /* DO (100白板計算) 食材1個數/h */ final doX = _tc(() => dn * (isIngredientSpecialty ? 2 : 1))/3;
    /* DP (100白板計算) 食材2個數/h */ final dp = _tc(() => dn * ae) / 3.0;
    /* DQ (100白板計算) 食材3個數/h */ final dq = _tc(() => dn * ah) / 3.0;
    /* DR (100白板收益) 樹果能量/h */ final dr = _tc(() => fruitEnergyLv100 * dl * (isBerrySpecialty ? 2 : 1) * (_isSnorlaxFavorite ? 2 : 1));
    /* DS (100白板收益) 食材個/h */ final ds = doX + dp + dq;
    /* DT (100白板收益) 食材能量/h */ final dt = _tc(() => doX * dz + dp * ea + dq * eb);
    /* DV (100白板) 主技能效益/h */
    final dv = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (dr+dt) * _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[(_mainSkillLv + 3-_tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1] :
        _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[(_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1]
    )
    ) * du;

    /* CD (50計算) 食材預期次數/h */ final cd = _tc(() => 3600 / bd * ingredientRateLv50);
    /* CE (50計算) 食材1個數/h */ final ce = _tc(() => cd * (isIngredientSpecialty ? 2 : 1)) / 2.0;
    /* CF (50計算) 食材2個數/h */ final cf = _tc(() => cd * ae) / 2.0;
    /* CG (50計算) 食材3個數/h */ const cg = 0;
    /* CH (50收益) 樹果能量/h */ final ch = _tc(() => cb * fruitEnergyAfterSnorlaxFavoriteLv50);
    /* CI (50收益) 食材個/h */ final ci = ce + cf + cg;
    /* CJ (50收益) 食材能量/h */ final cj = _tc(() => ce * dz + cf * ea + cg * eb);

    /* CK (50收益) 次數/h */
    final ck = _tc(() => (
        skillRateSMLv50 * 3600 / bd * _transUserVitality()
            * (
            character.negative == '主技能' ? 0.8
                : character.positive == '主技能' ? 1.2
                : 1
        )
    )
        + (isSkillSpecialty ? 0.2 : 0)
        + _ccc1 * (fc - 1)
        + _ccc2,
    );

    /* CL (50收益) 主技能效益/h */
    final cl = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (ch+cj) * _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[fc.toInt() - 1] :
        _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[fc.toInt() - 1]
    )
    ) * ck;

    /* CO (50白板計算) 食材機率 */ final co = 0.2;
    /* CM (50白板計算) 果子機率 */ final cm = 1 - co;
    /* CN (50白板計算) 果實預期次數/h */ final cn = _tc(() => 3600 / be * cm);
    /* CP (50白板計算) 食材預期次數/h */ final cp = _tc(() => 3600 / be * co);
    /* CQ (50白板計算) 食材1個數/h */ final cq = _tc(() => cp * (isIngredientSpecialty ? 2 : 1)) / 2.0;
    /* CR (50白板計算) 食材2個數/h */ final cr = _tc(() => cp * ae) / 2.0;

    /* CS (50白板計算) 食材3個數/h */ final cs = 0;
    /* CT (50白板收益) 樹果能量/h */ final ct = _tc(() => fruitEnergyLv50 * cn * (isBerrySpecialty ? 2 : 1) * (_isSnorlaxFavorite ? 2 : 1));
    /* CU (50白板收益) 食材個/h */ final cu = cq + cr + cs;
    /* CV (50白板收益) 食材能量/h */ final cv = _tc(() => cq * dz + cr * ea + cs * eb);
    /* CW (50白板收益) 次數/h */
    final cw = _tc(() =>
        (
            3600 / be * _transUserVitality()
        )
        + (isSkillSpecialty ? 0.2 : 0)
        + _ccc2 *
            (_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)  - 1 + _ccc1),
    );
    /* CX (50白板收益) 主技能效益/h */
    final cx = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (ct+cv) * _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[(_mainSkillLv + 3-_tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1] :

        _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[(_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1]
    )
    ) * cw;

    /* BQ (白板計算) 食材機率 */ const ingredientRate = 0.2;
    /* BO (白板計算) 果子機率 */ const fruitRate = 1 - ingredientRate;
    /* BP (白板計算) 果實預期次數/h */ final bp = _tc(() => 3600 / helpIntervalPureLvCurr * fruitRate);

    /* BR (白板計算) 食材預期次數/h */ final br = _tc(() => 3600/ helpIntervalPureLvCurr * ingredientRate);
    /* BS (白板計算) 食材1個數/h */ final bs = _tc(() => br * (isIngredientSpecialty ? 2 : 1)) * (_level > 59 ? 1/3 : (_level>29 ? 1/2 : 1));
    /* BT (白板計算) 食材2個數/h */ final bt = _tc(() => (_level > 29 ? br * ae : 0)) * (_level > 59 ? 1/3 : 1/2);
    /* BU (白板計算) 食材3個數/h */ final bu = _tc(() => (_level > 59 ? br * ah : 0)) / 3.0;
    /* BV (白板收益) 樹果能量/h */ final bv = _tc(() => fruitEnergyLvCurr * bp * (isBerrySpecialty ? 2 : 1) * (_isSnorlaxFavorite?2:1));
    /* BW (白板收益) 食材個/h */ final bw = bs + bt + bu;
    /* BX (白板收益) 食材能量/h */ final bx = _tc(() => bs * dz + bt * ea + bu * eb);
    /* BY (白板收益) 次數/h */
    final by = _tc(() {
      return 3600 / helpIntervalLvCurr1 +
          (isSkillSpecialty ? 0.2 : 0.0)+
          0.25*(_mainSkillLv-1)+
          (basicProfile.currentEvolutionStage - 2) * _ccc1;
    });
    /* BZ (白板收益) 主技能效益/h */
    final bz = _tc(() {
      return basicProfile.mainSkill == MainSkill.vitalityFillS
          ? (bv + bx)* _calcMainSkillEnergyList(basicProfile.mainSkill)[_mainSkillLv - 1]
          : _calcMainSkillEnergyList(basicProfile.mainSkill)[_mainSkillLv - 1];
    }) * by;

    /* U 主技能等級 */ final u = er;
    /* V 技能次數/d */
    final v = _tc(() =>
        (skillRateSMLvCurr * 3600 / helpIntervalLvCurr2*
            (character.negative == '主技能' ?  0.8 : character.positive == '主技能' ? 1.2 : 1))+
        _ccc2 * (u-1)+
        (isSkillSpecialty ?0.5:0)+
        (basicProfile.currentEvolutionStage - 2)*_ccc1
    );
    /* Z 樹果能量/h */
    final z = _tc(() => bi * fruitEnergyAfterSnorlaxFavorite);
    /* W 主技能效益/h */
    final w = _tc(() =>
    (
      basicProfile.mainSkill == MainSkill.vitalityFillS
          ? (z + aj)* _calcMainSkillEnergyList(basicProfile.mainSkill)[u.toInt() - 1]
          : _calcMainSkillEnergyList(basicProfile.mainSkill)[u.toInt() - 1]
    ))*v;
    /* B 白板收益/h */ final b = bv + bx + bz;
    /* E 理想總收益/h */
    final e = _tc(() =>
    z + aj + w + (_subSkillsContains(SubSkill.helperBonus, _level) ? o4 : 0)
    );
    /* C 性格技能影響 */ final c = b == 0 ? 0 : (e - b) / b;
    /* F 自身收益/h */
    // =IFERROR(
    // Z7+AJ7+(W7+IF(OR(EF7=6,EG7=6,EH7=6,EI7=6,EJ7=6),$O$4/5,))*IF(VLOOKUP(VLOOKUP(H7,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$1:$P$13,15,FALSE)>1,0,1),)
    final f = _tc(() =>
    z + aj + (w + (_subSkillsContains(SubSkill.helperBonus, _level) ? o4 / 5 : 0)) *
        (basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS ? 0 : 1)
    );
    /* G 輔助隊友收益/h */
    final g = e - f;

    /* (Lv50Result) GD 樹果能量/h */ final gd = ch;
    /* (Lv50Result) GE 食材個/h */ final ge = ci;
    /* (Lv50Result) GF 食材能量/h */ final gf = cj;
    /* (Lv50Result) GG 技能次數/d */ final gg = ck;
    /* (Lv50Result) GH 主技能效益/h */ final gh = cl;
    /* (Lv50Result) GI 50自身收益/h */
    final gi = _tc(() =>
    ch + cj + cl *
        (basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS ? 0 : 1) +
        (_subSkillsContains(SubSkill.helperBonus, 50) ? gy4 / 5 : 0)
    );
    /* (Lv50Result) GK 50收益/h */ final gk = _tc(() => ch + cj + cl + (_subSkillsContains(SubSkill.helperBonus, 50) ? gy4 : 0));
    /* (Lv50Result) GJ 50輔助隊友收益/h */ final gj = gk - gi;
    /* (Lv50Result) GL 50白板/h */ final gl = ct + cv + cx;
    /* (Lv50Result) GM 影響 */ final gm = b == 0 ? 0 : (gk - gl) / gl;
    /* (Lv100Result) GN 樹果能量/h */ final gn = df;
    /* (Lv100Result) GO 食材個/h */ final go = dg;
    /* (Lv100Result) GP 食材能量/h */ final gp = dh;
    /* (Lv100Result) GQ 技能次數/d */ final gq = di;
    /* (Lv100Result) GR 主技能效益/h */ final gr = dj;
    /* (Lv100Result) GS 100自身收益/h */
    final gs = _tc(() =>
      df+dh+dj*
          (
              basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS?
              0 :
              1
          )+
          (_subSkillsContains(SubSkill.helperBonus, 100) ? ha4/5 : 0)
    );
    /* (Lv100Result) GU 100收益/h */ final gu = _tc(() =>
    df + dh + dj + (_subSkillsContains(SubSkill.helperBonus, 100) ? ha4 : 0)
    );
    /* (Lv100Result) GT 100輔助隊友收益/h */ final gt = gu - gs;
    /* (Lv100Result) GV 100白板/h */ final gv = dr + dt + dv;
    /* (Lv100Result) GW 影響 */ final gw = b == 0 ? 0 : (gu - gv) / gv;

    /* (Rank) GX 50評級 */
    final gx = b == 0 ? '-' :
    gm >= 1 ? 'S' :
    gm >= 0.8 ? 'A' :
    gm >= 0.6 ? 'B' :
    gm >= 0.4 ? 'C' :
    gm >= 0.2 ? 'D' :
    gm >= 0 ? 'E' :
    gm < 0 ? 'F' : '-';

    /* (Rank) GY 100評級 */
    final gy = b == 0 ? '-' :
    gw >= 1.5 ? 'S+' :
    gw >= 1 ? 'S' :
    gw >= 0.8 ? 'A' :
    gw >= 0.6 ? 'B' :
    gw >= 0.4 ? 'C' :
    gw >= 0.2 ? 'D' :
    gw >= 0 ? 'E' :
    gw < 0 ? 'F' : '-';

    /* (Rank) GZ 100時收益 */
    final gz = (
        gu > 10000 ? "★★★★★" :
        gu > 9000 ? "★★★★☆" :
        gu > 8000 ? "★★★☆☆" :
        gu > 7000?"★★☆☆☆":
        gu > 6000 ? "★☆☆☆☆" :
        gu > 5000 ? "☆☆☆☆☆" :
        gu > 4000 ? "☆☆☆☆" :
        gu > 3000 ? "☆☆☆" :
        gu > 2000 ? "☆☆" :
        gu > 1000 ? "☆" :
        gu > 0 ? "" : "-"
    );

    /* A 評級 */
    // IF(B7=0,"-",IFS(C7>=0.3,"S",C7>=0.24,"A",C7>=0.18,"B",C7>=0.12,"C",C7>=0.06,"D",C7>=0,"E",C7<0,"F")&GX7&GY7&CHAR(10)&GZ7)
    final a = (b == 0 ? '-' :
    c >= 0.3 ? 'S' :
    c >= 0.24 ? 'A' :
    c >= 0.18 ? 'B' :
    c >= 0.12 ? 'C' :
    c >= 0.06 ? 'D' :
    c >= 0 ? 'E' :
    c < 0 ? 'F' : '-') + gx + gy + gz;

    _isInitialized = true;
    if (!kDebugMode) {
      return res;
    }

    return [
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
            Display.numDouble(bd),
            Display.numDouble(000000),
          ],
          [
            'Lv100',
            '',
            Display.numDouble(000000),
            Display.numDouble(bf),
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
            Display.numDouble(be),
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
            '',
            Display.numDouble(0),
            Display.numDouble(0),
            '',
            '',
            Display.numDouble(0),
            Display.numDouble(0),
            Display.numDouble(0),
          ],
          [
            '當前等級\n(加成後)',
            Display.numDouble(fruitRateLvCurr1),
            Display.numDouble(bi),
            Display.numDouble(bj),
            Display.numDouble(ingredientCountPerHourLvCurr),
            Display.numDouble(ingredient1CountPerHourAfterAdjustLvCurr),
            Display.numDouble(ingredient2CountPerHourAfterAdjustLvCurr),
            Display.numDouble(ingredient3CountPerHourAfterAdjustLvCurr),
          ],
          [
            '當前等級\n(白板)',
            Display.numDouble(fruitRate),
            Display.numDouble(bp),
            Display.numDouble(ingredientRate),
            Display.numDouble(br),
            Display.numDouble(bs),
            Display.numDouble(bt),
            Display.numDouble(bu),
          ],
          [
            'Lv50\n(加成後)',
            Display.numDouble(fruitRateLv50),
            Display.numDouble(cb),
            Display.numDouble(ingredientRateLv50),
            Display.numDouble(cd),
            Display.numDouble(ce),
            Display.numDouble(cf),
            Display.numDouble(cg),
          ],
          [
            'Lv50\n(白板)',
            Display.numDouble(cm),
            Display.numDouble(cn),
            Display.numDouble(co),
            Display.numDouble(cp),
            Display.numDouble(cq),
            Display.numDouble(cr),
            Display.numDouble(cs),
          ],
          [
            'Lv100\n(加成後)',
            Display.numDouble(cy),
            Display.numDouble(cz),
            Display.numDouble(da),
            Display.numDouble(db),
            Display.numDouble(dc),
            Display.numDouble(dd),
            Display.numDouble(de),
          ],
          [
            'Lv100\n(白板)',
            Display.numDouble(dk),
            Display.numDouble(dl),
            Display.numDouble(dm),
            Display.numDouble(dn),
            Display.numDouble(doX),
            Display.numDouble(dp),
            Display.numDouble(dq),
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
            '次數/h',
            '主技能效益/h',
            '食材換算成碎片/h',
          ],
          [
            '當前等級\n(加成後)',
            Display.numDouble(z),
            Display.numDouble(ai),
            Display.numDouble(aj),
            Display.numDouble(v), // TODO: 原 sheet 是 '次數/d'，但其他都是 `/h`，可是個人感覺像是 `/d`?
            Display.numDouble(w),
            Display.numDouble(ak),
          ],
          [
            '當前等級\n(白板)',
            Display.numDouble(bv),
            Display.numDouble(bw),
            Display.numDouble(bx),
            Display.numDouble(by),
            Display.numDouble(bz),
            '',
          ],
          [
            'Lv50\n(加成後)',
            Display.numDouble(ch),
            Display.numDouble(ci),
            Display.numDouble(cj),
            Display.numDouble(ck),
            Display.numDouble(cl),
            '',
          ],
          [
            'Lv50\n(白板)',
            Display.numDouble(ct),
            Display.numDouble(cu),
            Display.numDouble(cv),
            Display.numDouble(cw),
            Display.numDouble(cx),
            '',
          ],
          [
            'Lv100\n(加成後)',
            Display.numDouble(df),
            Display.numDouble(dg),
            Display.numDouble(dh),
            Display.numDouble(di),
            Display.numDouble(dj),
            '',
          ],
          [
            'Lv100\n(白板)',
            Display.numDouble(dr),
            Display.numDouble(ds),
            Display.numDouble(dt),
            Display.numDouble(du),
            Display.numDouble(dv),
            '',
          ],
        ],
      }
    ];
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
      print(123);
    }

    return fruit.getLevels()[level - 1];
  }

  // endregion Formulas

}