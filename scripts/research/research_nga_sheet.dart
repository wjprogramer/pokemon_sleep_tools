// 研究 宝可梦sleep期望计算20231004v2土豆版 请用WPS打开
// https://bbs.nga.cn/read.php?tid=37305277
// 此 .dart 檔案為理解試算表公式用的

import 'package:collection/collection.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/basic/collection.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/main_skill.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/sub_skill.dart';

// ignore_for_file: avoid_print

const _useTaiwanName = true;

typedef SheetFormulaBuilder = String Function(Map<String, DataColumn> columnCodeMapping);

final _successColumnCodeSet = <String>{};

extension _SubSkillX on SubSkill {
  String _getName() {
    return switch (this) {
      SubSkill.berryCountS => '樹果數量S',
      SubSkill.helperBonus => '幫手獎勵',
      SubSkill.helpSpeedM => '幫忙速度M',
      SubSkill.helpSpeedS => '幫忙速度S',
      SubSkill.ingredientRateM => '食材機率提升M',
      SubSkill.ingredientRateS => '食材機率提升S',
      SubSkill.skillLevelM => '技能等級提升M',
      SubSkill.skillLevelS => '技能等級提升S',
      SubSkill.skillRateM => '技能機率提升M',
      SubSkill.skillRateS => '技能機率提升S',
      SubSkill.holdMaxL => '持有上限提升L',
      SubSkill.holdMaxM => '持有上限提升M',
      SubSkill.holdMaxS => '持有上限提升S',
      SubSkill.energyRecoverBonus => '活力回復獎勵',
      SubSkill.sleepExpBonus => '睡眠EXP獎勵',
      SubSkill.researchExpBonus => '研究EXP獎勵',
      SubSkill.dreamChipBonus => '夢之碎片獎勵',
    };
  }
}

extension _MainSkillX on MainSkill {
  String _getName() {
    return switch (this) {
      MainSkill.energyFillS => '能量填充S',
      MainSkill.energyFillM => '能量填充M',
      MainSkill.energyFillSn => '能量填充Sn',
      MainSkill.dreamChipS => '夢之碎片獲取S',
      MainSkill.dreamChipSn => '夢之碎片獲取Sn',
      MainSkill.vitalityS => '活力療癒S',
      MainSkill.vitalityAllS => '活力全體療癒S',
      MainSkill.vitalityFillS => '活力填充S',
      MainSkill.helpSupportS => '幫手支援S',
      MainSkill.ingredientS => '食材獲取S',
      MainSkill.cuisineS => '料理強化S',
      MainSkill.finger => '揮指',
    };
  }
}

// note: sheet IFERROR => 如果沒給錯誤的值，發生錯誤時，預設會給予零
void main() {
  // CK, DI 原本 sheet 上會有活力加成，但 V 卻沒有

  final columns = <(String, String, String, SheetFormulaBuilder)>[
    /* A */ ('評級', '', 'vv', (m) {
      // =IF(B7=0,"-",IFS(C7>=0.3,"S",C7>=0.24,"A",C7>=0.18,"B",C7>=0.12,"C",C7>=0.06,"D",C7>=0,"E",C7<0,"F")&GX7&GY7&CHAR(10)&GZ7)
      return '根據 ${m.gn('C')} 決定評級，並同時列出 ${m.gn('GX')}、${m.gn('GY')}、${m.gn('GZ')}';
    }),
    /* B */ ('白板收益/h', '', 'vv', (m) {
      return '${m.gn('BV')} + ${m.gn('BX')} + ${m.gn('BZ')}';
    }),
    ('性格技能影響', '', 'vv', (m) {
      // =IF(B7=0,0,(E7-B7)/B7)
      return '${m.gn('B')} == 0 ? 0 : (${m.gn('E')} - ${m.gn('B')}) / ${m.gn('B')}'; // 為比例，呈現上可以乘上 100 加上 %
    }),
    ('活力檔', '', 'vv', (m) {
      return 'int, 值為 1~5，使用者設定';
    }),
    ('理想總收益/h', '', '', (m) {
      // =Z7+AJ7+W7+IF(OR(EF7=6,EG7=6,EH7=6,EI7=6,EJ7=6),$O$4,),
      return '${m.gn('Z')}+${m.gn('AJ')}+${m.gn('W')}+'
          'IF(OR(${m.gn('EF')}=6,${m.gn('EG')}=6,${m.gn('EH')}=6,${m.gn('EI')}=6,${m.gn('EJ')}=6),\$O\$4,)';
    }),
    ('自身收益/h', '', '', (m) {
      // =IFERROR(Z7+AJ7+(W7+IF(OR(EF7=6,EG7=6,EH7=6,EI7=6,EJ7=6),$O$4/5,))*IF(VLOOKUP(VLOOKUP(H7,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$1:$P$13,15,FALSE)>1,0,1),)
      return '';
    }),
    ('輔助隊友收益/h', '', 'v', (m) {
      return '${m.gn('E')} - ${m.gn('F')}';
    }),
    ('寶可夢', '', 'v', (m) {
      return m.gn('FQ');
    }),
    ('等級', '', 'v', (m) {
      return m.gn('FR');
    }),
    /* J */ ('性格', '', 'v', (m) {
      return m.gn('GC');
    }),
    ('性格↑', '', 'v', (m) {
      return '查表，看性格帶來什麼特色';
    }),
    ('性格↓', '', 'v', (m) {
      return '查表，看性格帶來什麼特色';
    }),
    /* M */ ('類型', '', 'v', (m) {
      return '查表：看寶可夢決定，食材、樹果、技能';
    }),
    ('10 (副技能)', '', 'v', (m) {
      return m.gn('FX');
    }),
    ('25 (副技能)', '', 'v', (m) {
      return m.gn('FY');
    }),
    ('50 (副技能)', '', 'v', (m) {
      return m.gn('FZ');
    }),
    ('75 (副技能)', '', 'v', (m) {
      return m.gn('GA');
    }),
    /* R */ ('100 (副技能)', '', 'v', (m) {
      return m.gn('GB');
    }),
    ('間隔', '', 'v', (m) {
      return m.gn('AY');
    }),
    /* T */ ('技能', '', 'v', (m) {
      return '查表：看寶可夢決定';
    }),
    ('主技能等級', '', 'v', (m) {
      return m.gn('ER');
    }),
    ('技能次數/d', '', 'v', (m) {
      // 錯誤回傳 0
      //      (       EQ7   *3600/   AY7       *IFS(EE7          =4,0.8,     ED7     =4,1.2,I7          >-1,1)) + $AL$4        *(U7          -1) + IF(AU7          =3,0.5,0) + (VLOOKUP($H7,          '宝可梦'   !$B$7:$Q$115,  9,FALSE)-2) * $AM$4
      return '(${m.gn('EQ')}*3600/${m.gn('AY')}*IFS(${m.gn('EE')}=4,0.8,${m.gn('ED')}=4,1.2,${m.gn('I')}>-1,1)) + ${m.gn('AL')}*(${m.gn('U')}-1) + IF(${m.gn('AU')}=3,0.5,0) + (VLOOKUP(${m.gn('H')},\'宝可梦\'!\$B\$7:\$Q\$115,9,FALSE)-2) * 0.2';
    }),
    ('主技能效益/h', '', 'v', (m) {
      /*
       化簡

       "能量填充"(回傳主技能名稱)＝VLOOKUP(
          H7,
          '宝可梦'!$B$7:$S$115,17,
          FALSE
        )

        主技能是否為「活力填充S」＝VLOOKUP(
          "能量填充",
          '主技能'!$B$1:$P$13,
          15,
          FALSE
        )＝1

        根據主技能等級(${m.gn('U7')})，取得位於主技能列表的 J~O 欄的值) = VLOOKUP(
          主技能名稱,
          '主技能'!$B$1:$P$13,U7+8,FALSE
        )
        =====> 以幫忙支援S來說，數值為 18.33, 22.92, ...., 41.25
        =====> 根據 U7，以及 PokemonProfileStatistics2._calcMainSkillEnergyList 求值

       =IFERROR(
          IF(
            如果主技能是「活力填充S」,
            (Z7+AJ7)*VLOOKUP(
              主技能名稱,
              '主技能'!$B$1:$P$13,U7+8,FALSE
            ),
            VLOOKUP(
              主技能名稱,
              '主技能'!$B$1:$P$13,U7+8,FALSE
            )
          ),
        )*V7
       */
      return  'x = 根據 ${m.gn('U')}，以及 PokemonProfileStatistics2._calcMainSkillEnergyList 求值\n'
          'y = 如果主技能是「活力填充S」 ? (${m.gn('Z')}+${m.gn('AJ')}) * x : x\n'
          'z = y * ${m.gn('V')}';
    }),
    ('樹果', '', 'vv', (m) {
      return '_';
    }),
    ('樹果', '', 'vv', (m) {
      return '_';
    }),
    ('樹果能量/h', '', 'vv', (m) {
      return '${m.gn('BI')} * ${m.gn('AN')}';
    }),
    ('食材1/1級', '', 'vv', (m) {
      return '';
    }),
    ('食材1/1級', '', 'vv', (m) {
      return '';
    }),
    ('食材2/30級', '', 'vv', (m) {
      return '';
    }),
    ('食材2/30級', '', 'vv', (m) {
      return '';
    }),
    ('個數', '', 'vv', (m) {
      return '';
    }),
    ('食材3/60級', '', 'vv', (m) {
      return '';
    }),
    ('食材3/60級', '', 'vv', (m) {
      return '';
    }),
    ('個數', '', 'vv', (m) {
      return '';
    }),
    ('食材個/h', '', 'v', (m) {
      return '${m.gn('BL')} + ${m.gn('BM')} + ${m.gn('BN')}';
    }),
    ('食材能量/h', '', 'v', (m) {
      return '${m.gn('BL')}*${m.gn('DZ')} + ${m.gn('BM')}*${m.gn('EA')} + ${m.gn('BN')}*${m.gn('EB')}';
    }),
    ('食材換算成碎片/h', '', 'v', (m) {
      return '${m.gn('BL')}*${m.gn('DW')} + ${m.gn('BM')}*${m.gn('DX')} + ${m.gn('BN')}*${m.gn('DY')}';
    }),
    ('(當前等級) 果子/顆', '', 'v', (m) {
      return '根據 ${m.gn('Y')} 並根據 Fruit.getLevels 取得相對應的數值';
    }),
    ('(當前等級) 類型與技能加成/顆', '', 'v', (m) {
      // =IFERROR(IF(AU7=1,AL7*2,AL7)+EK7,)
      return '(${m.gn('AU')} 是否為樹果型 ? ${m.gn('AL')} * 2 : ${m.gn('AL')}) + ${m.gn('EK')}';
    }),
    ('(當前等級) +喜愛加成/顆', '', 'v', (m) {
      return '${m.gn('AM')}, 如果 ${m.gn('AV')} 並且設定 `要考慮喜愛樹果`';
    }),
    ('(Lv 50) 果子/顆', '', 'v', (m) {
      return '算法與 `當前等級` 相同（只是等級改成 50）';
    }),
    ('(Lv 50) 類型與技能加成/顆', '', 'v', (m) {
      return '';
    }),
    ('(Lv 50) +喜愛加成/顆', '', 'v', (m) {
      return '';
    }),
    ('(Lv 100) 果子/顆', '', 'v', (m) {
      return '算法與 `當前等級` 相同（只是等級改成 100）';
    }),
    ('(Lv 100) 類型與技能加成/顆', '', 'v', (m) {
      return '';
    }),
    ('(Lv 100) +喜愛加成/顆', '', 'v', (m) {
      return '';
    }),
    ('專長編號', '', 'vv', (m) {
      return '查表：根據寶可夢決定 （表上的編號：樹果1, 食材2, 技能3）';
    }),
    /* AV */ ('喜愛的果子', '卡比獸喜愛的樹果', 'vv', (m) {
      return '為布林值，是否為當週卡比的喜愛樹果，會有全域變數決定是否要將其納入考量；如果不考慮，恆等於 false';
    }),
    ('基礎間隔', '', 'vv', (m) {
      return '查表：像是雷丘為 2200S，皮卡丘為 2700S';
    }),
    ('等級調整', '', 'v', (m) {
      return '${m.gn('AW')} - (${m.gn('AW')} * ( (${m.gn('I')} - 1) * 0.002 ))';
    }),
    ('性格+技能調整', '', 'v', (m) {
      // AX7*EM7*IF(ED7=1,0.9,IF(EE7=1,1.1,1))
      return '性格補正（根據幫忙速度）＝1 or 0.9(正面補正) or 1.1(負面補正)\n'
          '${m.gn('AX')}*${m.gn('EM')}*`性格補正`';
    }),
    ('活力影響後', '', 'v', (m) {
      return '活力補正(根據${m.gn('D')}) = { 5: 0.4, 4: 0.5, 3: 0.6, 2: 0.8, 1: 1 }\n'
          '${m.gn('AY')} * `活力補正`';
    }),
    ('白板-活力影響', '', 'v', (m) {
      return '活力補正(根據${m.gn('D')}) = { 5: 0.4, 4: 0.5, 3: 0.6, 2: 0.8, 1: 1 }\n'
        '${m.gn('AX')} * `活力補正';
    }),
    ('進化後基礎間隔', '', 'v', (m) {
      return '查表：看最高階，例如皮卡丘原本是 2700，但變成雷丘後是 2200，所以結果為 2200（皮丘也是看最高階，所以也是 2200）';
    }),
    ('性格+活力調整', '', 'v', (m) {
      // BB7*IF(ED7=1,0.9,IF(EE7=1,1.1,1))*IFS(D7=5,0.4,D7=4,0.5,D7=3,0.6,D7=2,0.8,D7=1,1),
      return '活力補正(根據${m.gn('D')}) = { 5: 0.4, 4: 0.5, 3: 0.6, 2: 0.8, 1: 1 }\n'
          '性格補正（根據幫忙速度）＝1 or 0.9(正面補正) or 1.1(負面補正)\n'
          '${m.gn('BB')} * `性格補正`*`活力補正`';
    }),
    ('50間隔', '', 'v', (m) {
      // =IFERROR($BC7-($BC7*((50-1)*0.002)),)*EX7
      return '${m.gn('BC')}-(${m.gn('BC')}*((50-1)*0.002))*${m.gn('EX')}';
    }),
    ('50白板活力', '', 'v', (m) {
      // ($BB7-($BB7*((50-1)*0.002)))*IFS(D7=5,0.4,D7=4,0.5,D7=3,0.6,D7=2,0.8,D7=1,1)
      return '活力補正(根據${m.gn('D')}) = { 5: 0.4, 4: 0.5, 3: 0.6, 2: 0.8, 1: 1 }\n'
          '(${m.gn('BB')}-(${m.gn('BB')}*((50-1)*0.002)))*`活力補正`';
    }),
    ('100間隔', '', 'v', (m) {
      // ($BC7-($BC7*((100-1)*0.002))) * FK7
      return '(${m.gn('BC')}-(${m.gn('BC')}*((100-1)*0.002))) * ${m.gn('FK')}';
    }),
    ('100白板活力', '', 'v', (m) {
      // ($BB7-($BB7*((100-1)*0.002)))*IFS(D7=5,0.4,D7=4,0.5,D7=3,0.6,D7=2,0.8,D7=1,1),
      return '活力補正(根據${m.gn('D')}) = { 5: 0.4, 4: 0.5, 3: 0.6, 2: 0.8, 1: 1 }\n'
          '(${m.gn('BB')}-(${m.gn('BB')}*((100-1)*0.002)))*`活力補正`';
    }),
    ('(加成後) 果子機率', '', 'v', (m) {
      return '1 - ${m.gn('BJ')}';
    }),
    ('(加成後) 果實預期次數/h', '', 'v', (m) {
      // =IFERROR(3600/AZ7*BH7,)
      return '3600/${m.gn('AZ')}*${m.gn('BH')}';
    }),
    ('(加成後) 食材機率', '', 'v', (m) {
      // 0.2*EO7*IF(ED7=3,1.2,IF(EE7=3,0.8,1)),
      return '性格補正（食材發現）＝1, 1.2(正面), 0.8(負面)\n'
          '0.2*${m.gn('EO')}*`性格補正`';
    }),
    ('(加成後) 食材預期次數/h', '', 'v', (m) {
      // =IFERROR(3600/AZ7*BJ7,)
      return '3600/${m.gn('AZ')}*${m.gn('BJ')}';
    }),
    ('(加成後) 食材1個數/h', '', '', (m) {
      // =(BK7*IF(AU7=2,2,1),)*IF(I7>59,1/3,IF(I7>29,1/2,1))
      return '(${m.gn('BK')}*IF(${m.gn('AU')}=2,2,1))*IF(${m.gn('I')}>59,1/3,IF(${m.gn('I')}>29,1/2,1))';
    }),
    /*BM*/ ('(加成後) 食材2個數/h', '', 'v', (m) {
      // =    (IF(I7        >29  ,    BK7       *AE7           ,0)) * IF( I7>59,         1/3, 1/2)
      return '(${m.gn('I')} > 29 ? ${m.gn('BK')}*${m.gn('AE')} : 0) * (${m.gn('I')} > 59 ? 1/3 : 1/2)';
    }),
    ('(加成後) 食材3個數/h', '', '', (m) {
      // =(IF(I7>59,BK7*AH7,0),)/3
      return '';
    }),
    ('(白板計算) 果子機率', '', 'v', (m) {
      // 1-BQ7
      return '1 - ${m.gn('BQ')}';
    }),
    ('(白板計算) 果實預期次數/h', '', 'v', (m) {
      // =3600/BA7*BO7
      return '3600/${m.gn('BA')}*${m.gn('BO')}';
    }),
    ('(白板計算) 食材機率', '', 'v', (m) {
      return '0.2';
    }),
    ('(白板計算) 食材預期次數/h', '', 'v', (m) {
      // =IFERROR(3600/BA7*BQ7,)
      return '3600/${m.gn('BA')}*${m.gn('BQ')}';
    }),
    ('(白板計算) 食材1個數/h', '', '', (m) {
      // BS
      // =(BR7*IF(AU7=2,2,1),) * IF(I7>59,1/3,IF(I7>29,1/2,1))
      return '';
    }),
    ('(白板計算) 食材2個數/h', '', '', (m) {
      // =IFERROR(IF(I7>29,BR7*AE7,0),)*IF(I7>59,1/3,1/2)
      return '';
    }),
    ('(白板計算) 食材3個數/h', '', '', (m) {
      // =IFERROR(IF(I7>59,BR7*AH7,0),)/3
      return '';
    }),
    ('(白板收益) 樹果能量/h', '', '', (m) {
      // =IFERROR(AL7*BP7*IF(AU7=1,2,1)*IF(AV7=TRUE,2,1),)
      return '';
    }),
    ('(白板收益) 食材個/h', '', '', (m) {
      // =SUM(BS7:BU7)
      return '';
    }),
    ('(白板收益) 食材能量/h', '', '', (m) {
      // =IFERROR(BS7*DZ7+BT7*EA7+BU7*EB7,)
      return '';
    }),
    ('(白板收益) 次數/h', '', '', (m) {
      // =IFERROR(3600/AX7+IF(AU7=3,0.2,0)+0.25*(FW7-1)+(VLOOKUP($H7,'宝可梦'!$B$7:$Q$115,9,FALSE)-2)*$AM$4,)
      return '';
    }),
    ('(白板收益) 主技能效益/h', '', '', (m) {
      // =IFERROR(IF(VLOOKUP(VLOOKUP(H7,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$1:$P$13,15,FALSE)=1,(BV7+BX7)*VLOOKUP(VLOOKUP(H7,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$1:$P$13,FW7+8,FALSE),VLOOKUP(VLOOKUP(H7,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$1:$P$13,FW7+8,FALSE)),)*BY7
      return '';
    }),
    /* CA */ ('(50計算) 果子機率', '', 'v', (m) {
      // =1-CC7
      return '1 - ${m.gn('CC')}';
    }),
    ('(50計算) 果實預期次數/h', '', 'v', (m) {
      // =IFERROR(3600/BD7*CA7,)
      return '3600 / ${m.gn('BD')} * ${m.gn('CA')}';
    }),
    /* CC */ ('(50計算) 食材機率', '', 'v', (m) {
      // =0.2*EZ7*IF(ED7=3,1.2,IF(EE7=3,0.8,1))
      return '性格補正（食材發現）＝1, 1.2(正面), 0.8(負面)\n'
          '0.2 * ${m.gn('EZ')} * `性格補正`';
    }),
    ('(50計算) 食材預期次數/h', '', '', (m) {
      // =IFERROR(3600/BD7*CC7,)
      return '';
    }),
    ('(50計算) 食材1個數/h', '', '', (m) {
      return '';
    }),
    ('(50計算) 食材2個數/h', '', '', (m) {
      return '';
    }),
    ('(50計算) 食材3個數/h', '', '', (m) {
      return '';
    }),
    ('(50收益) 樹果能量/h', '', '', (m) {
      return '';
    }),
    ('(50收益) 食材個/h', '', '', (m) {
      return '';
    }),
    ('(50收益) 食材能量/h', '', '', (m) {
      return '';
    }),
    ('(50收益) 次數/h', '', '', (m) {
      return '';
    }),
    ('(50收益) 主技能效益/h', '', '', (m) {
      return '';
    }),
    ('(50白板計算) 果子機率', '', '', (m) {
      return '';
    }),
    ('(50白板計算) 果實預期次數/h', '', '', (m) {
      return '';
    }),
    ('(50白板計算) 食材機率', '', '', (m) {
      return '';
    }),
    ('(50白板計算) 食材預期次數/h', '', '', (m) {
      return '';
    }),
    ('(50白板計算) 食材1個數/h', '', '', (m) {
      return '';
    }),
    ('(50白板計算) 食材2個數/h', '', '', (m) {
      return '';
    }),
    ('(50白板計算) 食材3個數/h', '', '', (m) {
      return '';
    }),
    ('(50白板收益) 樹果能量/h', '', '', (m) {
      return '';
    }),
    ('(50白板收益) 食材個/h', '', '', (m) {
      return '';
    }),
    ('(50白板收益) 食材能量/h', '', '', (m) {
      return '';
    }),
    ('(50白板收益) 次數/h', '', '', (m) {
      return '';
    }),
    ('(50白板收益) 主技能效益/h', '', '', (m) {
      return '';
    }),
    ('(Lv100計算) 果子機率', '', '', (m) {
      return '';
    }),
    ('(Lv100計算) 果實預期次數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100計算) 食材機率', '', '', (m) {
      return '';
    }),
    ('(Lv100計算) 食材預期次數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100計算) 食材1個數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100計算) 食材2個數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100計算) 食材3個數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100收益) 樹果能量/h', '', '', (m) {
      return '';
    }),
    ('(Lv100收益) 食材個/h', '', '', (m) {
      return '';
    }),
    ('(Lv100收益) 食材能量/h', '', '', (m) {
      return '';
    }),
    ('(Lv100收益) 次數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100收益) 主技能效益/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板計算) 果子機率', '', '', (m) {
      return '';
    }),
    ('(Lv100白板計算) 果實預期次數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板計算) 食材機率', '', '', (m) {
      return '';
    }),
    ('(Lv100白板計算) 食材預期次數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板計算) 食材1個數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板計算) 食材2個數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板計算) 食材3個數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板收益) 樹果能量/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板收益) 食材個/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板收益) 食材能量/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板收益) 次數/h', '', '', (m) {
      return '';
    }),
    ('(Lv100白板收益) 主技能效益/h', '', '', (m) {
      return '';
    }),
    ('食材1售價', '', 'vv', (m) {
      return '';
    }),
    ('食材2售價', '', 'vv', (m) {
      return '';
    }),
    ('食材3售價', '', 'vv', (m) {
      return '';
    }),
    ('食材1能量', '', 'vv', (m) {
      return '';
    }),
    ('食材2能量', '', 'vv', (m) {
      return '';
    }),
    ('食材3能量', '', 'vv', (m) {
      return '';
    }),
    ('性格編號', '', 'vv', (m) {
      return '';
    }),
    ('性格增', '', 'vv', (m) {
      return '';
    }),
    ('性格減', '', 'vv', (m) {
      return '';
    }),
    ('(當前等級) SSk10Ix', '', 'vv', (m) {
      return '';
    }),
    ('(當前等級) SSk25Ix', '', 'vv', (m) {
      return '';
    }),
    ('(當前等級) SSk50Ix', '', 'vv', (m) {
      return '';
    }),
    ('(當前等級) SSk75Ix', '', 'vv', (m) {
      return '';
    }),
    ('(當前等級) SSk100Ix', '', 'vv', (m) {
      return '';
    }),
    ('(當前等級) 樹果+1確認', '', 'vv', (m) {
      // 1. 「目前等級中」，所有的副技能有沒有樹果數量 S
      // 2. 只會有最多一個樹果數量Ｓ！（因為是最高階副技能）

      // IF(
      //    OR(
      //      $EF7=1,$EG7=1,$EH7=1,$EI7=1,$EJ7=1
      //    ),
      //    AL7*1,
      //    0
      // ),
      return '如果後續計算錯誤，回傳0；\n'
          '                         公式: 如果 Lv 1~Curr 的副技能有 `${SubSkill.berryCountS._getName()}` ? `${m.gn('AL')}` : 0';
    }),
    ('(當前等級) 幫忙M確認', '', 'vv', (m) {
      //=IF(
      //    OR(
      //      $EF7=7,$EG7=7,$EH7=7,$EI7=7,$EJ7=7
      //    ),
      //    0.86,
      //    1
      // )
      return '如果後續計算錯誤，回傳0；\n'
          '                       公式: 如果 Lv 1~Curr 的副技能有 `${SubSkill.helpSpeedM._getName()}` ? 0.86 : 1';
    }),
    ('(當前等級) 幫忙S+M確認', '', 'vv', (m) {
      // EM 幫忙S+M確認:
      // 8 => 幫忙速度S

      // IF(
      //    OR($EF7=8,$EG7=8,$EH7=8,$EI7=8,$EJ7=8),
      //    IF(EL7=0.86,0.79,0.93),
      //    IF(EL7=0.86,0.86,1)
      // )
      return '如果後續計算錯誤，回傳0；\n'
          '                        公式: 1.0\n'
          '                             - (如果 Lv 1~Curr 的副技能有 `${SubSkill.helpSpeedM._getName()}` ? 0.14 : 0)\n'
          '                             - (如果 Lv 1~Curr 的副技能有 `${SubSkill.helpSpeedS._getName()}` ? 0.07 : 0)';
    }),
    ('(當前等級) 食材M確認', '', 'vv', (m) {
      // =IFERROR(IF(OR($EF7=9,$EG7=9,$EH7=9,$EI7=9,$EJ7=9),1.36,1),)
      // EN 食材M確認:
      return '如果後續計算錯誤，回傳0；\n'
          '                       公式: 如果 Lv 1~Curr 的副技能有 `${SubSkill.ingredientRateM._getName()}` ? 1.36 : 1';
    }),
    /* EO */ ('(當前等級) 食材S+M確認', '', 'vv', (m) {
      // IF(
      //    OR($EF7=10,$EG7=10,$EH7=10,$EI7=10,$EJ7=10),
      //    IF(EN7=1.36,1.54,1.18),
      //    IF(EN7=1.36,1.36,1)
      // ),
      return '如果後續計算錯誤，回傳0；\n'
          '                        公式: 1.0\n'
          '                             + (如果 Lv 1~Curr 的副技能有 `${SubSkill.ingredientRateM._getName()}` ? 0.36 : 0)\n'
          '                             + (如果 Lv 1~Curr 的副技能有 `${SubSkill.ingredientRateS._getName()}` ? 0.18 : 0)';
    }),
    ('(當前等級) 技能幾率M確認', '', 'vv', (m) {
      return '如果後續計算錯誤，回傳0；\n'
          '                           如果 Lv 1~Curr 的副技能有 `${SubSkill.skillRateM._getName()}` ? 1.36 : 1';
    }),
    ('(當前等級) 技能幾率S+M確認', '', 'vv', (m) {
      // IF(
      //      OR($EF7=18,$EG7=18,$EH7=18,$EI7=18,$EJ7=18),
      //      IF(EP7=1.36,1.54,1.18),
      //      IF(EP7=1.36,1.36,1)
      // ),
      return '如果後續計算錯誤，回傳0；\n'
          '                           公式: 1.0\n'
          '                                + (如果 Lv 1~Curr 的副技能有 `${SubSkill.skillRateM._getName()}` ? 0.36 : 0)\n'
          '                                + (如果 Lv 1~Curr 的副技能有 `${SubSkill.skillRateS._getName()}` ? 0.18 : 0)';
    }),
    ('(當前等級) 加成後主技能等級', '', 'vv', (m) {
      // ER
      // =FW7 + IF(OR($EF7=15,$EG7=15,$EH7=15,$EI7=15,$EJ7=15),2,0)+IF(OR($EF7=16,$EG7=16,$EH7=16,$EI7=16,$EJ7=16),1,0)
      return '公式: ${m.gn('FW')}\n'
          '                                  + (Lv1~Curr 的副技能含有 `${SubSkill.skillLevelM._getName()}` ? 2 : 0)\n'
          '                                  + (Lv1~Curr 的副技能含有 `${SubSkill.skillLevelS._getName()}` ? 2 : 0)\n'
          '                                  + 3\n'
          '                                  - (如果有錯誤，回傳3；否則回傳目前寶可夢的進化階段，可能值為 1~3)';
    }),
    ('(Lv50) SSk10Ix', '', 'vv', (m) {
      return '';
    }),
    ('(Lv50) SSk25Ix', '', 'vv', (m) {
      return '';
    }),
    ('(Lv50) SSk50Ix', '', 'vv', (m) {
      return '';
    }),
    ('(Lv50) 樹果+1確認', '', 'vv', (m) {
      // =IF(OR($ES13=1,$ET13=1,$EU13=1,),AO13*1,0)
      return '如果後續計算錯誤，回傳0；\n'
          '                         公式: 如果 Lv 1~50 的副技能有 `${SubSkill.berryCountS._getName()}` ? `${m.gn('AL')}` : 0';
    }),
    ('(Lv50) 幫忙M確認', '', 'vv', (m) {
      // IF(OR($ES13=7,$ET13=7,$EU13=7,),0.86,1)
      return '如果後續計算錯誤，回傳0；\n'
          '                       公式: 如果 Lv 1~50 的副技能有 `${SubSkill.helpSpeedM._getName()}` ? 0.86 : 1';
    }),
    ('(Lv50) 幫忙S+M確認', '', 'vv', (m) {
      // IF(
      //    OR($ES13=8,$ET13=8,$EU13=8),
      //    IF(EW13=0.86,0.79,0.93),
      //    IF(EW13=0.86,0.86,1)
      // )
      return '如果後續計算錯誤，回傳0；\n'
          '                         公式: 1.0\n'
          '                              - (如果 Lv 1~50 的副技能有 `${SubSkill.helpSpeedM._getName()}` ? 0.14 : 0)\n'
          '                              - (如果 Lv 1~50 的副技能有 `${SubSkill.helpSpeedS._getName()}` ? 0.07 : 0)';
    }),
    ('(Lv50) 食材M確認', '', 'vv', (m) {
      // =IF(OR($ES13=9,$ET13=9,$EU13=9),1.36,1)
      return '如果後續計算錯誤，回傳0；\n'
          '                      公式: 如果 Lv 1~50 的副技能有 `${SubSkill.ingredientRateM._getName()}` ? 1.36 : 1';
    }),
    ('(Lv50) 食材S+M確認', '', 'vv', (m) {
      // IF(OR($FD13=10,$FE13=10,$FF13=10),IF(EY13=1.36,1.54,1.18),IF(EY13=1.36,1.36,1))
      return '如果後續計算錯誤，回傳0；\n'
          '                         公式: 1.0\n'
          '                              + (如果 Lv 1~50 的副技能有 `${SubSkill.ingredientRateM._getName()}` ? 0.36 : 0)\n'
          '                              + (如果 Lv 1~50 的副技能有 `${SubSkill.ingredientRateS._getName()}` ? 0.18 : 0)';
    }),
    ('(Lv50) 技能幾率M確認', '', 'vv', (m) {
      // IF(OR($ES13=17,$ET13=17,$EU13=17),1.36,1),
      return '如果後續計算錯誤，回傳0；\n'
          '                           如果 Lv 1~50 的副技能有 `${SubSkill.skillRateM._getName()}` ? 1.36 : 1';
    }),
    ('(Lv50) 技能幾率S+M確認', '', 'vv', (m) {
      // =IF(
      //      OR($FD13=18,$FE13=18,$FF13=18),
      //      IF(FA13=1.36,1.54,1.18),
      //      IF(FA13=1.36,1.36,1)
      // )
      return '如果後續計算錯誤，回傳0；\n'
          '                           公式: 1.0\n'
          '                                + (如果 Lv 1~50 的副技能有 `${SubSkill.skillRateM._getName()}` ? 0.36 : 0)\n'
          '                                + (如果 Lv 1~50 的副技能有 `${SubSkill.skillRateS._getName()}` ? 0.18 : 0)';
    }),
    ('(Lv50) 加成後主技能等級', '', 'vv', (m) {
      //=FW13
      // +IF(OR($ES13=15,$ET13=15,$EU13=15),2,0)
      // +IF(OR($ES13=16,$ET13=16,$EV13=16),1,0)
      // +3
      // -IFERROR(VLOOKUP($H13,'宝可梦'!$B$7:$Q$115,9,FALSE),3)
      return '公式: ${m.gn('FW')}\n'
          '                                  + (Lv1~50 的副技能含有 `${SubSkill.skillLevelM._getName()}` ? 2 : 0)\n'
          '                                  + (Lv1~50 的副技能含有 `${SubSkill.skillLevelS._getName()}` ? 2 : 0)\n'
          '                                  + 3\n'
          '                                  - (如果有錯誤，回傳3；否則回傳目前寶可夢的進化階段，可能值為 1~3)';
    }),
    ('(Lv100) SSk10Ix', '', 'vv', (m) {
      return '';
    }),
    ('(Lv100) SSk25Ix', '', 'vv', (m) {
      return '';
    }),
    ('(Lv100) SSk50Ix', '', 'vv', (m) {
      return '';
    }),
    ('(Lv100) SSk75Ix', '', 'vv', (m) {
      return '';
    }),
    ('(Lv100) SSk100Ix', '', 'vv', (m) {
      return '';
    }),
    /* FI */('(Lv100) 樹果+1確認', '', 'vv', (m) {
      return '如果後續計算錯誤，回傳0；\n'
          '                         公式: 如果 Lv 1~100 的副技能有 `${SubSkill.berryCountS._getName()}` ? `${m.gn('AL')}` : 0';
    }),
    /* FJ */('(Lv100) 幫忙M確認', '', 'vv', (m) {
      // =IF(OR($FD13=7,$FE13=7,$FF13=7,$FG13=7,$FH13=7),0.86,1)
      return '如果後續計算錯誤，回傳0；\n'
          '                       公式: 如果 Lv 1~100 的副技能有 `${SubSkill.helpSpeedM._getName()}` ? 0.86 : 1';
    }),
    /* FK */('(Lv100) 幫忙S+M確認', '', 'vv', (m) {
      // IF(
      //      OR($FD13=8,$FE13=8,$FF13=8,$FG13=8,$FH13=8),
      //      IF(FJ13=0.86,0.79,0.93),
      //      IF(FJ13=0.86,0.86,1)
      // )
      return '如果後續計算錯誤，回傳0；\n'
          '                        公式: 1.0\n'
          '                             - (如果 Lv 1~100 的副技能有 `${SubSkill.helpSpeedM._getName()}` ? 0.14 : 0)\n'
          '                             - (如果 Lv 1~100 的副技能有 `${SubSkill.helpSpeedS._getName()}` ? 0.07 : 0)';
    }),
    /* FL */('(Lv100) 食材M確認', '', 'vv', (m) {
      // =IF(OR($FD13=9,$FE13=9,$FF13=9,$FG13=9,$FH13=9),1.36,1)
      return '如果後續計算錯誤，回傳0；\n'
          '                       公式: 如果 Lv 1~100 的副技能有 `${SubSkill.ingredientRateM._getName()}` ? 1.36 : 1';
    }),
    ('(Lv100) 食材S+M確認', '', 'vv', (m) {
      // IF(
      //    OR($FD13=10,$FE13=10,$FF13=10,$FG13=10,$FH13=10),
      //    IF(FL13=1.36,1.54,1.18),
      //    IF(FL13=1.36,1.36,1)
      // )
      return '如果後續計算錯誤，回傳0；\n'
          '                        公式: 1.0\n'
          '                             + (如果 Lv 1~100 的副技能有 `${SubSkill.ingredientRateM._getName()}` ? 0.36 : 0)\n'
          '                             + (如果 Lv 1~100 的副技能有 `${SubSkill.ingredientRateS._getName()}` ? 0.18 : 0)';
    }),
    ('(Lv100) 技能幾率M確認', '', 'vv', (m) {
      // =IF(OR($FD13=17,$FE13=17,$FF13=17,$FG13=17,$FH13=17),1.36,1)
      return '如果後續計算錯誤，回傳0；\n'
          '                           如果 Lv 1~100 的副技能有 `${SubSkill.skillRateM._getName()}` ? 1.36 : 1';
    }),
    ('(Lv100) 技能幾率S+M確認', '', 'vv', (m) {
      // IF(
      //    OR($FD13=18,$FE13=18,$FF13=18,$FG13=18,$FH13=18),
      //    IF(FN13=1.36,1.54,1.18),
      //    IF(FN13=1.36,1.36,1)
      // )
      return '如果後續計算錯誤，回傳0；\n'
          '                           公式: 1.0\n'
          '                                + (如果 Lv 1~100 的副技能有 `${SubSkill.skillRateM._getName()}` ? 0.36 : 0)\n'
          '                                + (如果 Lv 1~100 的副技能有 `${SubSkill.skillRateS._getName()}` ? 0.18 : 0)';
    }),
    /* FP */ ('(Lv100) 加成後主技能等級', '', 'vv', (m) {
      // =FW13
      // + IF(OR($FD13=15,$FE13=15,$FF13=15,$FG13=15,$FH13=15),2,0)
      // + IF(OR($FD13=16,$FE13=16,$FF13=16,$FG13=16,$FH13=16),1,0)
      // +3
      // -IFERROR(VLOOKUP($H13,'宝可梦'!$B$7:$Q$115,9,FALSE),3)
      return '公式: ${m.gn('FW')}\n'
          '                                  + (Lv1~100 的副技能含有 `${SubSkill.skillLevelM._getName()}` ? 2 : 0)\n'
          '                                  + (Lv1~100 的副技能含有 `${SubSkill.skillLevelS._getName()}` ? 2 : 0)\n'
          '                                  + 3\n'
          '                                  - (如果有錯誤，回傳3；否則回傳目前寶可夢的進化階段，可能值為 1~3)';
    }),
    ('名稱', '', 'vv', (m) {
      return 'user_input';
    }),
    ('等級', '', 'vv', (m) {
      return 'user_input';
    }),
    ('食材2', '', 'vv', (m) {
      return 'user_input';
    }),
    ('個數', '', 'vv', (m) {
      return 'user_input';
    }),
    ('食材3', '', 'vv', (m) {
      return 'user_input';
    }),
    ('個數', '', 'vv', (m) {
      return 'user_input';
    }),
    ('主技能等級', '', 'vv', (m) {
      return 'user_input';
    }),
    ('10', '10副技能', 'vv', (m) {
      return 'user_input';
    }),
    ('25', '25副技能', 'vv', (m) {
      return 'user_input';
    }),
    ('50', '50副技能', 'vv', (m) {
      return 'user_input';
    }),
    ('75', '75副技能', 'vv', (m) {
      return 'user_input';
    }),
    ('100', '100副技能', 'vv', (m) {
      return 'user_input';
    }),
    ('性格', '', 'vv', (m) {
      return 'user_input';
    }),
    ('(Lv50) 樹果能量/h', '', 'vv', (m) {
      return m.gn('CH');
    }),
    ('(Lv50) 食材個/h', '', 'vv', (m) {
      return m.gn('CI');
    }),
    ('(Lv50) 食材能量/h', '', 'vv', (m) {
      return m.gn('CJ');
    }),
    ('(Lv50) 技能次數/d', '', 'vv', (m) {
      return m.gn('CK');
    }),
    ('(Lv50) 主技能效益/h', '', 'vv', (m) {
      return m.gn('CL');
    }),
    /* GI */('(Lv50) 50自身收益/h', '', 'vv', (m) {
      // CH13+CJ13+CL13
      // *IF(VLOOKUP(VLOOKUP(H13,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$16:$P$28,15,FALSE)>1,0,1)
      // +IF(OR(ES13=6,ET13=6,EU13=6),$GY$4/5,)
      return '如果後續計算錯誤，回傳0；\n'
          '                          公式: ${m.gn('CH')} + ${m.gn('CJ')} \n'
          '                                + ${m.gn('CL')} * (主技能是 `${MainSkill.vitalityAllS._getName()}` 或 `${MainSkill.vitalityS._getName()}` ? 0 : 1) \n'
          '                                + (如果 Lv1~50 的副技能有 `${SubSkill.helperBonus._getName()}` ? ${m.gn('GY_4')} / 5 : 0)';
    }),
    ('(Lv50) 50輔助隊友收益/h', '', 'vv', (m) {
      return '${m.gn('GK')}-${m.gn('GI')}';
    }),
    /* GK */('(Lv50) 50收益/h', '', 'vv', (m) {
      // =IFERROR(CH13+CJ13+CL13+IF(OR(ES13=6,ET13=6,EU13=6),$GY$4,),)
      // CH13+CJ13+CL13+  IF(OR(ES13=6,ET13=6,EU13=6),$GY$4,)
      return '如果後續計算出錯，回傳0；\n'
          '                     ${m.gn('CH')} + ${m.gn('CJ')} + ${m.gn('CL')} + (如果 Lv 1~50 的副技能有 `${SubSkill.helperBonus._getName()}` ? ${m.gn('GY_4')} : 0)';
    }),
    /* GL */('(Lv50) 50白板/h', '', 'vv', (m) {
      // =CT13+CV13+CX13
      return '${m.gn('CT')}+${m.gn('CV')}+${m.gn('CX')}';
    }),
    ('(Lv50) 影響', '', 'vv', (m) {
      // =IF(B13=0,0,(GK13-GL13)/GL13)
      return '如果 ${m.gn('B')} 等於 0，代表白板計算有問題?，會回傳0；\n'
          '                    否則，回傳 ${m.gn('GL')} 對 ${m.gn('GK')} 增加多少百分比；\n'
          '                    公式: (${m.gn('GK')} - ${m.gn('GL')}) / ${m.gn('GL')}';
    }),
    ('(Lv100) 樹果能量/h', '', 'vv', (m) {
      return m.gn('DF');
    }),
    ('(Lv100) 食材個/h', '', 'vv', (m) {
      return m.gn('DG');
    }),
    ('(Lv100) 食材能量/h', '', 'vv', (m) {
      return m.gn('DH');
    }),
    ('(Lv100) 技能次數/d', '', 'vv', (m) {
      return m.gn('DI');
    }),
    /* GR */('(Lv100) 主技能效益/h', '', 'vv', (m) {
      return m.gn('DJ');
    }),
    /* GS */('(Lv100) 自身收益/h', '', 'vv', (m) {
      // =IFERROR(DF13+DH13+DJ13*IF(VLOOKUP(VLOOKUP(H13,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$16:$P$28,15,FALSE)>1,0,1)+IF(OR(FD13=6,FE13=6,FF13=6,FG13=6,FH13=6),$HA$4/5,),)
      // DF13+DH13+DJ13*IF(VLOOKUP(VLOOKUP(H13,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$16:$P$28,15,FALSE)>1,0,1)+IF(OR(FD13=6,FE13=6,FF13=6,FG13=6,FH13=6),$HA$4/5,)
      return '如果後續計算錯誤，回傳0；\n'
      // IF(VLOOKUP(VLOOKUP(H13,'宝可梦'!$B$7:$S$115,17,FALSE),'主技能'!$B$16:$P$28,15,FALSE)>1,0,1)
      // +IF(OR(FD13=6,FE13=6,FF13=6,FG13=6,FH13=6),$HA$4/5,)
          '                          公式: ${m.gn('DF')} + ${m.gn('DH')} \n'
          '                               + ${m.gn('DJ')} * (主技能是 `${MainSkill.vitalityAllS._getName()}` 或 `${MainSkill.vitalityS._getName()}` ? 0 : 1) \n'
          '                               + (如果 Lv1~100 的副技能有 `${SubSkill.helperBonus._getName()}` ? ${m.gn('HA_4')} / 5 : 0)';
    }),
    /* GT */ ('(Lv100) 輔助隊友收益/h', '', 'vv', (m) {
      // =GU13-GS13
      return '${m.gn('GU')} - ${m.gn('GS')}';
    }),
    /* GU */('(Lv100) 收益/h', '', 'vv', (m) {
      // =IFERROR(DF14+DH14+DJ14+IF(OR(FD14=6,FE14=6,FF14=6,FG14=6,FH14=6),$HA$4,),)
      // DF14+DH14+DJ14+IF(OR(FD14=6,FE14=6,FF14=6,FG14=6,FH14=6),$HA$4,)
      return '如果後續計算錯誤，回傳0；\n'
          '                      ${m.gn('DF')} + ${m.gn('DH')} + ${m.gn('DJ')} + (如果 Lv1~100 的副技能有 `${SubSkill.helperBonus._getName()}` ? ${m.gn('HA_4')} : 0)';
      // +IF(OR(${m.gn('FD')}=6,${m.gn('FE')}=6,${m.gn('FF')}=6,${m.gn('FG')}=6,${m.gn('FH')}=6),${m.gn('HA')},)
    }),
    /* GV */ ('(Lv100) 白板/h', '', 'vv', (m) {
      // =DR14+DT14+DV14
      return '${m.gn('DR')}+${m.gn('DT')}+${m.gn('DV')}';
    }),
    /* GW */ ('(Lv100) 影響', '', 'vv', (m) {
      // =IF(B14=0,0,(GU14-GV14)/GV14)
      return '如果 ${m.gn('B')} 等於 0，代表白板計算有問題?，會回傳0；\n'
          '                     否則，回傳 ${m.gn('GV')} 對 ${m.gn('GU')} 增加多少百分比；\n'
          '                     公式: (${m.gn('GU')} - ${m.gn('GV')}) / ${m.gn('GV')}';
    }),
    ('50評級', '', 'vv', (m) {
      // =IF(B14=0,"-",
      // IFS(GM14>=1,"S",GM14>=0.8,"A",GM14>=0.6,"B",GM14>=0.4,"C",GM14>=0.2,"D",GM14>=0,"E",GM14<0,"F"))
      return '如果 ${m.gn('B')} 等於 0，代表白板計算有問題?；\n'
          '               否則，根據 ${m.gn('GM')} 計算評級';
    }),
    ('100評級', '', 'vv', (m) {
      // =IF(B14=0,"-",
      // IFS(GW14>=1.5,"S+",GW14>=1,"S",GW14>=0.8,"A",GW14>=0.6,"B",GW14>=0.4,"C",GW14>=0.2,"D",GW14>=0,"E",GW14<0,"F"))
      return '(與 ${m.gn('GX')} 計算公式一樣，但因為等級提高，評級的數值會更加嚴苛)';
    }),
    /* GZ */ ('100時收益', '100時收益 (評級星數表示)', 'vv', (m) {
      // =IFERROR(IFS(GU14>10000,"★★★★★",GU14>9000,"★★★★☆",GU14>8000,"★★★☆☆",
      // GU14>7000,"★★☆☆☆",GU14>6000,"★☆☆☆☆",GU14>5000,"☆☆☆☆☆",GU14>4000,"☆☆☆☆",GU14>3000,"☆☆☆",
      // GU14>2000,"☆☆",GU14>1000,"☆",GU14>0,""),"-")
      return '根據 ${m.gn('GU')} 決定評級';
    }),
  ].mapIndexed((index, element) {
    return DataColumn(index, element.$1, element.$2, element.$3, element.$4);
  }).toList();

  final columnCodeMapping = columns.toMap(
    (col) => col.columnCode,
    (col) => col,
  );

  for (final column in columns) {
    if (column.status == 'vv') {
      _successColumnCodeSet.add(column.columnCode);
    }
  }

  print('EF~EJ 都是跟 level 等級有關的副技能 (表上的副技能數值需要查表對應到的實際技能)');

  for (final column in columns) {
    if (_successColumnCodeSet.contains(column.columnCode)) {
      continue;
    }
    print('(${column.status}) ${column.columnCode} ${column.name}: ${column.formulaBuilder(columnCodeMapping)}');
    // print('${column.columnCode} ${column.name}');
  }

}

class DataColumn {
  DataColumn(this.index, this.name, this.tName, this.status, this.formulaBuilder);

  /// 欄位次序
  final int index;

  /// 可視化名稱 (中國用語)
  final String name;

  /// 可視化名稱 (台灣用語)
  final String tName;

  final String status;

  final SheetFormulaBuilder formulaBuilder;

  String? _columnCode;
  set columnCode(String v) {
    _columnCode = v;
  }
  String get columnCode {
    if (_columnCode != null) {
      return _columnCode!;
    }

    String res = '';
    var tmp = index;

    while (tmp >= 0) {
      res = String.fromCharCode(65 + tmp % 26).toString() + res;
      tmp = (tmp / 26).floor() - 1;
    }

    return res;
  }
}

/// 範例: 'HA_4' 代表 'HA4' 或 '$HA$4'，也就是「第 4 列的 HA 欄」
/// `$` 代表固定欄或列，不會因不同列而改變
final _fixedDataMapping = <String, _SpecialCell>{
  'GY_3': _SpecialCell(
    code: 'GY_3',
    cellName: '(Lv50幫手) 出場平均估分 (手動計算)',
    formulaBuilder: (m) {
      return '選上你要上場的五隻高分寶可夢「自身收益」平均數。';
    },
  ),
  'GY_4': _SpecialCell(
    code: 'GY_4',
    cellName: '(Lv50幫手) 幫手獎勵計算估分',
    formulaBuilder: (m) {
      //=HA3*5*0.05
      return '${m.gn('GY_3')} * 5 * 0.05';
    },
  ),
  'HA_3': _SpecialCell(
    code: 'HA_3',
    cellName: '(Lv100幫手) 出場平均估分 (手動計算)',
    formulaBuilder: (m) {
      return '選上你要上場的五隻高分寶可夢「自身收益」平均數。';
    },
  ),
  'HA_4': _SpecialCell(
    code: 'HA_4',
    cellName: '(Lv100幫手) 幫手獎勵計算估分',
    formulaBuilder: (m) {
      //=HA3*5*0.05
      return '${m.gn('HA_3')} * 5 * 0.05';
    },
  ),
};

extension _ColumnMappingX on Map<String, DataColumn> {
  /// gn = get name
  String gn(String columnCode) {
    String? text;

    // 固定欄列的資料
    final specialCell = _fixedDataMapping[columnCode];
    if (specialCell != null) {
      text = specialCell.cellName;
    }

    // 結構化資料 / tName
    if (text == null && _useTaiwanName && (this[columnCode]?.tName ?? '').isNotEmpty) {
      text = this[columnCode]!.tName;
    }

    // 結構化資料 / name
    text ??= this[columnCode]?.name;

    // 結果
    final success = _successColumnCodeSet.contains(columnCode);
    return '「$text($columnCode)${success ? '*' : ''}」';
  }
}

class _SpecialCell {
  _SpecialCell({
    required this.code,
    required this.cellName,
    required this.formulaBuilder,
  });

  final String code;
  final String cellName;
  final SheetFormulaBuilder formulaBuilder;
}
















