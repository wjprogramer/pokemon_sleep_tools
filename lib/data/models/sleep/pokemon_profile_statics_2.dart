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
class PokemonProfileStatistics {
  PokemonProfileStatistics(this.profile);

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
  /* $AM$4 */ final _AM_4 = 0.2;
  /* $AL$4 */ final _AL_4 = 0.25;

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
    /* BQ, CO, DM (白板計算) 食材機率 */ const ingredientRate = 0.2; // TODO: 感覺應該根據 BasicProfile 的食材機率
    /* BO (白板計算) 果子機率 */ const fruitRate = 1 - ingredientRate;
    // endregion


    // NOTES:
    // - Lv 50 與 Lv 100 的狀況下都是假設進化到最終階段

    final statisticsLvCurr = _PokemonProfileStatisticsAtLevel(profile: profile, type: _StatisticsLevelType.levelCurr, isSnorlaxFavorite: _shouldConsiderSnorlaxFavorite && _isSnorlaxFavorite, vitality: _userVitality, baseHelpInterval: helpInterval, mainSkillLv: _mainSkillLv, level: _level).calc();
    final statisticsLv50 = _PokemonProfileStatisticsAtLevel(profile: profile, type: _StatisticsLevelType.level50, isSnorlaxFavorite: _shouldConsiderSnorlaxFavorite && _isSnorlaxFavorite, vitality: _userVitality, baseHelpInterval: maxHelpInterval, mainSkillLv: _mainSkillLv, level: 50).calc();
    final statisticsLv100 = _PokemonProfileStatisticsAtLevel(profile: profile, type: _StatisticsLevelType.level100, isSnorlaxFavorite: _shouldConsiderSnorlaxFavorite && _isSnorlaxFavorite, vitality: _userVitality, baseHelpInterval: maxHelpInterval, mainSkillLv: _mainSkillLv, level: 100).calc();

    /* AK 食材換算成碎片/h */ final akLvCurr = statisticsLvCurr.ingredientCount1PerHour * ingredientPrice1
        + statisticsLvCurr.ingredientCount2PerHour * ingredientPrice2
        + statisticsLvCurr.ingredientCount3PerHour * ingredientPrice3;




    /* BY (白板收益) 次數/h */
    final byLvCurr = _tc(() {
      return 3600 / statisticsLvCurr.helpIntervalWithLevel
          + (isSkillSpecialty ? 0.2 : 0.0)
          + 0.25 * (_mainSkillLv-1)
          + _AM_4 * (basicProfile.currentEvolutionStage - 2);
    });
    /* CW (50白板收益) 次數/h */
    final cwLv50 = _tc(() =>
        3600 / statisticsLv50.pureHelpIntervalWithLevelVitality * _transUserVitality()
        + (isSkillSpecialty ? 0.2 : 0)
        + _AL_4 * (_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)  - 1 + _AM_4),
    );
    /* DU (100白板) 次數/h */ final duLv100 = _tc(() =>
        3600 / statisticsLv100.pureHelpIntervalWithLevelVitality * _transUserVitality()
        + (isSkillSpecialty ? 0.2 : 0)
        + _AL_4 * (_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3) - 1) + _AM_4,
    );





    /* W (當前等及) 主技能效益/h */
    final wLvCurr = _tc(() =>
    (
        basicProfile.mainSkill == MainSkill.vitalityFillS
            ? (statisticsLvCurr.fruitEnergyPerHour + statisticsLvCurr.totalIngredientEnergyPerHour)* _calcMainSkillEnergyList(basicProfile.mainSkill)[statisticsLvCurr.finalMainSkillLevel.toInt() - 1]
            : _calcMainSkillEnergyList(basicProfile.mainSkill)[statisticsLvCurr.finalMainSkillLevel.toInt() - 1]
    )) * statisticsLvCurr.skillActivateCountPerDay;
    /* BZ (白板收益) 主技能效益/h */
    final bzLvCurr = _tc(() {
      return basicProfile.mainSkill == MainSkill.vitalityFillS
          ? (statisticsLvCurr.pureFruitEnergyPerHour + statisticsLvCurr.pureIngredientEnergyPerHour)* _calcMainSkillEnergyList(basicProfile.mainSkill)[_mainSkillLv - 1]
          : _calcMainSkillEnergyList(basicProfile.mainSkill)[_mainSkillLv - 1];
    }) * byLvCurr;
    /* CL (50收益) 主技能效益/h, GH (Lv50Result) 主技能效益/h */
    final clLv50 = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (statisticsLv50.fruitEnergyPerHour + statisticsLv50.totalIngredientEnergyPerHour) * _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[statisticsLv50.finalMainSkillLevel.toInt() - 1] :
        _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[statisticsLv50.finalMainSkillLevel.toInt() - 1]
    )
    ) * statisticsLv50.skillActivateCountPerDay;
    /* CX (50白板收益) 主技能效益/h */
    final cxLv50 = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (statisticsLv50.pureFruitEnergyPerHour + statisticsLv50.pureIngredientEnergyPerHour) * _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[(_mainSkillLv + 3-_tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1] :

        _calcMainSkillEnergyListLv50(basicProfile.mainSkill)[(_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1]
    )
    ) * cwLv50;
    /* DV (100白板) 主技能效益/h */
    final dvLv100 = _tc(() => (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (statisticsLv100.pureFruitEnergyPerHour + statisticsLv100.pureIngredientEnergyPerHour) * _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[(_mainSkillLv + 3-_tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1] :
        _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[(_mainSkillLv + 3 - _tc(() => basicProfile.currentEvolutionStage, defaultValue: 3)).toInt() - 1]
    )
    ) * duLv100;
    /* DJ (100收益) 主技能效益/h, GR (Lv100Result) */
    final djLv100 = _tc(() =>
    (
        basicProfile.mainSkill == MainSkill.vitalityFillS ?
        (statisticsLv100.fruitEnergyPerHour + statisticsLv100.totalIngredientEnergyPerHour) * _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[statisticsLv100.finalMainSkillLevel.toInt() - 1] :
        _calcMainSkillEnergyListLv100(basicProfile.mainSkill)[statisticsLv100.finalMainSkillLevel.toInt() - 1]
    ),
    ) * statisticsLv100.skillActivateCountPerDay;
    
    
    

    /* (Lv50Result) GI 50自身收益/h */
    final giLv50 = _tc(() =>
    statisticsLv50.fruitEnergyPerHour + statisticsLv50.totalIngredientEnergyPerHour + clLv50 *
        (basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS ? 0 : 1) +
        (_subSkillsContains(SubSkill.helperBonus, 50) ? gy4 / 5 : 0)
    );
    /* (Lv50Result) GK 50收益/h */ final gkLv50 = _tc(
            () => statisticsLv50.fruitEnergyPerHour + statisticsLv50.totalIngredientEnergyPerHour + clLv50 + (_subSkillsContains(SubSkill.helperBonus, 50) ? gy4 : 0)
    );
    /* GJ (Lv50Result) 50輔助隊友收益/h */ final gjLv50 = gkLv50 - giLv50;



    /* B 白板收益/h */ final bLvCurr = statisticsLvCurr.pureFruitEnergyPerHour + statisticsLvCurr.pureIngredientEnergyPerHour + bzLvCurr;
    /* E 理想總收益/h */
    final eLvCurr = _tc(() =>
    statisticsLvCurr.fruitEnergyPerHour + statisticsLvCurr.totalIngredientEnergyPerHour + wLvCurr + (_subSkillsContains(SubSkill.helperBonus, _level) ? o4 : 0)
    );
    /* C 性格技能影響 */ final cLvCurr = bLvCurr == 0 ? 0 : (eLvCurr - bLvCurr) / bLvCurr;
    /* F 自身收益/h */
    final fLvCurr = _tc(() =>
    statisticsLvCurr.fruitEnergyPerHour + statisticsLvCurr.totalIngredientEnergyPerHour + (wLvCurr + (_subSkillsContains(SubSkill.helperBonus, _level) ? o4 / 5 : 0)) *
        (basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS ? 0 : 1)
    );
    /* G 輔助隊友收益/h */
    final gLvCurr = eLvCurr - fLvCurr;


    /* GL (Lv50Result) 50白板/h */ final glLv50 = statisticsLv50.pureFruitEnergyPerHour + statisticsLv50.pureIngredientEnergyPerHour + cxLv50;
    /* (Lv100Result) GV 100白板/h */ final gvLv100 = statisticsLv100.pureFruitEnergyPerHour + statisticsLv100.pureIngredientEnergyPerHour + dvLv100;
    /* GM (Lv50Result) 影響 */ final gmLv50 = bLvCurr == 0 ? 0 : (gkLv50 - glLv50) / glLv50;


    /* (Lv100Result) GU 100收益/h */ final guLv100 = _tc(() =>
    statisticsLv100.fruitEnergyPerHour + statisticsLv100.totalIngredientEnergyPerHour + djLv100 + (_subSkillsContains(SubSkill.helperBonus, 100) ? ha4 : 0)
    );
    /* GS (Lv100Result) 100自身收益/h */
    final gsLv100 = _tc(() =>
    statisticsLv100.fruitEnergyPerHour+statisticsLv100.totalIngredientEnergyPerHour+djLv100*
        (
            basicProfile.mainSkill == MainSkill.vitalityAllS || basicProfile.mainSkill == MainSkill.vitalityS?
            0 :
            1
        )+
        (_subSkillsContains(SubSkill.helperBonus, 100) ? ha4/5 : 0)
    );
    /* (Lv100Result) GT 100輔助隊友收益/h */ final gtLv100 = guLv100 - gsLv100;
    /* (Lv100Result) GW 影響 */ final gwLv100 = bLvCurr == 0 ? 0 : (guLv100 - gvLv100) / gvLv100;























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
              '幫忙S+M確認',
              '食材S+M確認',
              '技能幾率S+M確認',
              '加成後主技能等級',
            ],
            [
              '當前等級',
              Display.numDouble(statisticsLvCurr.fruitBonusEnergy),
              Display.numDouble(statisticsLvCurr.helpSpeedSM),
              Display.numDouble(statisticsLvCurr.ingredientSM),
              Display.numDouble(statisticsLvCurr.skillRateSM),
              Display.numDouble(statisticsLvCurr.finalMainSkillLevel),
            ],
            [
              'Lv 50',
              Display.numDouble(statisticsLv50.fruitBonusEnergy),
              Display.numDouble(statisticsLv50.helpSpeedSM),
              Display.numDouble(statisticsLv50.ingredientSM),
              Display.numDouble(statisticsLv50.skillRateSM),
              Display.numDouble(statisticsLv50.finalMainSkillLevel),
            ],
            [
              'Lv 100',
              Display.numDouble(statisticsLv100.fruitBonusEnergy),
              Display.numDouble(statisticsLv100.helpSpeedSM),
              Display.numDouble(statisticsLv100.ingredientSM),
              Display.numDouble(statisticsLv100.skillRateSM),
              Display.numDouble(statisticsLv100.finalMainSkillLevel),
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
              Display.numDouble(statisticsLvCurr.fruitEnergy),
              Display.numDouble(statisticsLvCurr.fruitEnergyAfterSpecialtyAndSubSkill),
              Display.numDouble(statisticsLvCurr.fruitEnergyAfterSnorlaxFavorite),
            ],
            [
              'Lv50',
              Display.numDouble(statisticsLv50.fruitEnergy),
              Display.numDouble(statisticsLv50.fruitEnergyAfterSpecialtyAndSubSkill),
              Display.numDouble(statisticsLv50.fruitEnergyAfterSnorlaxFavorite),
            ],
            [
              'Lv100',
              Display.numDouble(statisticsLv100.fruitEnergy),
              Display.numDouble(statisticsLv100.fruitEnergyAfterSpecialtyAndSubSkill),
              Display.numDouble(statisticsLv100.fruitEnergyAfterSnorlaxFavorite),
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
              Display.numDouble(statisticsLvCurr.helpIntervalWithLevel),
              Display.numDouble(statisticsLvCurr.helpIntervalWithLevelCharacterSkill),
              Display.numDouble(statisticsLvCurr.finalHelpInterval),
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
              Display.numDouble(statisticsLvCurr.helpIntervalWithLevel),
              Display.numDouble(statisticsLvCurr.pureHelpIntervalWithLevelVitality),
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
              Display.numDouble(0000),
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
              Display.numDouble(statisticsLv50.helpIntervalWithLevelCharacterSkill),
              Display.numDouble(000000),
            ],
            [
              'Lv100',
              '',
              Display.numDouble(000000),
              Display.numDouble(statisticsLv100.helpIntervalWithLevelCharacterSkill),
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
              Display.numDouble(statisticsLv50.pureHelpIntervalWithLevelVitality),
              '',
              Display.numDouble(000000),
            ],
            [
              'Lv100',
              '',
              Display.numDouble(statisticsLv100.pureHelpIntervalWithLevelVitality),
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
              Display.numDouble(statisticsLvCurr.fruitRate),
              Display.numDouble(statisticsLvCurr.fruitCountPerHour),
              Display.numDouble(statisticsLvCurr.ingredientRate),
              Display.numDouble(statisticsLvCurr.ingredientCountPerHour),
              Display.numDouble(statisticsLvCurr.ingredientCount1PerHour),
              Display.numDouble(statisticsLvCurr.ingredientCount2PerHour),
              Display.numDouble(statisticsLvCurr.ingredientCount3PerHour),
            ],
            [
              '當前等級\n(白板)',
              Display.numDouble(fruitRate),
              Display.numDouble(statisticsLvCurr.pureFruitCountPerHour),
              Display.numDouble(ingredientRate),
              Display.numDouble(statisticsLvCurr.pureIngredientCountPerHour),
              Display.numDouble(statisticsLvCurr.pureIngredientCount1PerHour),
              Display.numDouble(statisticsLvCurr.pureIngredientCount2PerHour),
              Display.numDouble(statisticsLvCurr.pureIngredientCount3PerHour),
            ],
            [
              'Lv50\n(加成後)',
              Display.numDouble(statisticsLv50.fruitRate),
              Display.numDouble(statisticsLv50.fruitCountPerHour),
              Display.numDouble(statisticsLv50.ingredientRate),
              Display.numDouble(statisticsLv50.ingredientCountPerHour),
              Display.numDouble(statisticsLv50.ingredientCount1PerHour),
              Display.numDouble(statisticsLv50.ingredientCount2PerHour),
              Display.numDouble(statisticsLv50.ingredientCount3PerHour),
            ],
            [
              'Lv50\n(白板)',
              Display.numDouble(fruitRate),
              Display.numDouble(statisticsLv50.pureFruitCountPerHour),
              Display.numDouble(ingredientRate),
              Display.numDouble(statisticsLv50.pureIngredientCountPerHour),
              Display.numDouble(statisticsLv50.pureIngredientCount1PerHour),
              Display.numDouble(statisticsLv50.pureIngredientCount2PerHour),
              Display.numDouble(statisticsLv50.ingredientCount3PerHour),
            ],
            [
              'Lv100\n(加成後)',
              Display.numDouble(statisticsLv100.fruitRate),
              Display.numDouble(statisticsLv100.fruitCountPerHour),
              Display.numDouble(statisticsLv100.ingredientRate),
              Display.numDouble(statisticsLv100.ingredientCountPerHour),
              Display.numDouble(statisticsLv100.ingredientCount1PerHour),
              Display.numDouble(statisticsLv100.ingredientCount2PerHour),
              Display.numDouble(statisticsLv100.ingredientCount3PerHour),
            ],
            [
              'Lv100\n(白板)',
              Display.numDouble(fruitRate),
              Display.numDouble(statisticsLv100.pureFruitCountPerHour),
              Display.numDouble(ingredientRate),
              Display.numDouble(statisticsLv100.pureIngredientCountPerHour),
              Display.numDouble(statisticsLv100.pureIngredientCount1PerHour),
              Display.numDouble(statisticsLv100.pureIngredientCount2PerHour),
              Display.numDouble(statisticsLv100.pureIngredientCount3PerHour),
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
              Display.numDouble(statisticsLvCurr.fruitEnergyPerHour),
              Display.numDouble(statisticsLvCurr.totalIngredientCountPerHour),
              Display.numDouble(statisticsLvCurr.totalIngredientEnergyPerHour),
              Display.numDouble(statisticsLvCurr.skillActivateCountPerDay),
              Display.numDouble(wLvCurr),
              Display.numDouble(akLvCurr),
              '',
              Display.numDouble(eLvCurr),
              '${cLvCurr > 0 ? '+' : cLvCurr < 0 ? '-' : ''}${Display.numDouble(cLvCurr * 100)}%',
            ],
            [
              '當前等級\n(白板)',
              Display.numDouble(statisticsLvCurr.pureFruitEnergyPerHour),
              Display.numDouble(statisticsLvCurr.pureTotalIngredientCountPerHour),
              Display.numDouble(statisticsLvCurr.pureIngredientEnergyPerHour),
              Display.numDouble(byLvCurr),
              Display.numDouble(bzLvCurr),
              '',
              '',
              Display.numDouble(bLvCurr),
              '',
            ],
            [
              'Lv50\n(加成後)',
              Display.numDouble(statisticsLv50.fruitEnergyPerHour),
              Display.numDouble(statisticsLv50.totalIngredientCountPerHour),
              Display.numDouble(statisticsLv50.totalIngredientEnergyPerHour),
              Display.numDouble(statisticsLv50.skillActivateCountPerDay),
              Display.numDouble(clLv50),
              '',
              '',
              '',
              '',
            ],
            [
              'Lv50\n(白板)',
              Display.numDouble(statisticsLv50.pureFruitEnergyPerHour),
              Display.numDouble(statisticsLv50.pureTotalIngredientCountPerHour),
              Display.numDouble(statisticsLv50.pureIngredientEnergyPerHour),
              Display.numDouble(cwLv50),
              Display.numDouble(cxLv50),
              '',
              '',
              '',
              '',
            ],
            [
              'Lv100\n(加成後)',
              Display.numDouble(statisticsLv100.fruitEnergyPerHour),
              Display.numDouble(statisticsLv100.totalIngredientCountPerHour),
              Display.numDouble(statisticsLv100.totalIngredientEnergyPerHour),
              Display.numDouble(statisticsLv100.skillActivateCountPerDay),
              Display.numDouble(djLv100),
              '',
              '',
              '',
              '',
            ],
            [
              'Lv100\n(白板)',
              Display.numDouble(statisticsLv100.pureFruitEnergyPerHour),
              Display.numDouble(statisticsLv100.pureTotalIngredientCountPerHour),
              Display.numDouble(statisticsLv100.pureIngredientEnergyPerHour),
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
              Display.numDouble(statisticsLv50.fruitEnergyPerHour),
              Display.numDouble(statisticsLv50.totalIngredientCountPerHour),
              Display.numDouble(statisticsLv50.totalIngredientEnergyPerHour),
              Display.numDouble(statisticsLv50.skillActivateCountPerDay),
              Display.numDouble(clLv50),
              Display.numDouble(giLv50),
              Display.numDouble(gjLv50),
              Display.numDouble(gkLv50),
              Display.numDouble(glLv50),
              '${Display.numDouble(gmLv50 * 100)}%',
            ],
            [
              'Lv 100',
              Display.numDouble(statisticsLv100.fruitEnergyPerHour),
              Display.numDouble(statisticsLv100.totalIngredientCountPerHour),
              Display.numDouble(statisticsLv100.totalIngredientEnergyPerHour),
              Display.numDouble(statisticsLv100.skillActivateCountPerDay),
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
  // endregion Formulas

}

enum _StatisticsLevelType {
  levelCurr,
  level100,
  level50,
}

class _PokemonProfileStatisticsAtLevel {
  _PokemonProfileStatisticsAtLevel({
    required this.profile,
    required this.type,
    required this.level,
    required this.isSnorlaxFavorite,
    required this.baseHelpInterval,
    required this.mainSkillLv,
    required this.vitality,
  });

  final PokemonProfile profile;
  final _StatisticsLevelType type;
  final int level;
  final bool isSnorlaxFavorite;
  /// 帳面上的幫忙間隔
  final int baseHelpInterval;
  final int mainSkillLv;
  final int vitality;

  // 在 sheet 上為常數
  /* $AM$4 */ static const _AM_4 = 0.2;
  /* $AL$4 */ static final _AL_4 = 0.25;

  _PokemonProfileStatisticsAtLevelResult calc() {
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
    final ingredientRate = _tc(() => 0.2 * ingredientSM
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
        + (type == _StatisticsLevelType.levelCurr ? 0 : (
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

    /* (加成後) 果實預期次數/h */ final fruitCountPerHour = _tc(() => 3600 / finalHelpInterval * fruitRate);
    /* (白板計算) 果實預期次數/h */ final pureFruitCountPerHour = _tc(() => 3600 / pureHelpIntervalWithLevelVitality * fruitRate);

    /* (加成後) 食材預期次數/h */ final ingredientCountPerHour = _tc(() => 3600/ finalHelpInterval * ingredientRate);
    /* (白板計算) 食材預期次數/h */ final pureIngredientCountPerHour = _tc(() => 3600/ pureHelpIntervalWithLevelVitality * ingredientRate);

    final useIngredientCount = (level > 59 ? 3 : (level > 29 ? 2 : 1));
    /* (加成後) 食材1個數/h */ final ingredientCount1PerHour =
        ingredientCountPerHour * (profile.isIngredientSpecialty ? 2 : 1)
            / useIngredientCount;
    /* (白板) 食材1個數/h */ final pureIngredientCount1PerHour =
        pureIngredientCountPerHour * (profile.isIngredientSpecialty ? 2 : 1)
            / useIngredientCount;

    /* (加成後) 食材2個數/h */ final ingredientCount2PerHour = level < 30 ? 0.0 : (
        ingredientCountPerHour * profile.ingredientCount2
            / useIngredientCount
    );
    /* (白板) 食材2個數/h */
    final pureIngredientCount2PerHour = level < 30 ? 0.0 : (
        pureIngredientCountPerHour * profile.ingredientCount2
            / useIngredientCount
    );

    /* (加成後) 食材3個數/h */
    final ingredientCount3PerHour = level < 60 ? 0.0 : (
        ingredientCountPerHour * profile.ingredientCount3
            / useIngredientCount
    );
    /* (白板) 食材3個數/h */
    final pureIngredientCount3PerHour = level < 60 ? 0.0 : (
        pureIngredientCountPerHour * profile.ingredientCount3
            / useIngredientCount
    );

    /* (收益) 食材個/h */
    final totalIngredientCountPerHour = ingredientCount1PerHour + ingredientCount2PerHour + ingredientCount3PerHour;
    /* (白板收益) 食材個/h */
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
        case _StatisticsLevelType.levelCurr:
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



    return _PokemonProfileStatisticsAtLevelResult(
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
    );
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

}

class _PokemonProfileStatisticsAtLevelResult {
  _PokemonProfileStatisticsAtLevelResult({
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

}
