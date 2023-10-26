// 研究 宝可梦sleep期望计算20231004v2土豆版 请用WPS打开
// https://bbs.nga.cn/read.php?tid=37305277
// 此 .dart 檔案為理解試算表公式用的

import 'package:collection/collection.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/basic/collection.dart';

const _useTaiwanName = true;

typedef SheetFormulaBuilder = String Function(Map<String, DataColumn> columnCodeMapping);

final _successColumnCodeSet = <String>{};

// note: sheet IFERROR => 如果沒給錯誤的值，發生錯誤時，預設會給予零
void main() {
  final columns = <(String, String, String, SheetFormulaBuilder)>[
    ('評級', '', '', (m) {
      // =IF(B7=0,"-",IFS(C7>=0.3,"S",C7>=0.24,"A",C7>=0.18,"B",C7>=0.12,"C",C7>=0.06,"D",C7>=0,"E",C7<0,"F")&GX7&GY7&CHAR(10)&GZ7)
      return '';
    }),
    /* B */ ('白板收益/h', '', 'v', (m) {
      return '${m.gn('BV')} + ${m.gn('BX')} + ${m.gn('BZ')}';
    }),
    ('性格技能影響', '', 'v', (m) {
      // =IF(B7=0,0,(E7-B7)/B7)
      return '${m.gn('B')} == 0 ? 0 : (${m.gn('E')} - ${m.gn('B')}) / ${m.gn('B')}'; // 為比例，呈現上可以乘上 100 加上 %
    }),
    ('活力檔', '', 'v', (m) {
      return 'int, 值為 1~5';
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
    ('樹果', '', 'v', (m) {
      return '_';
    }),
    ('樹果', '', 'v', (m) {
      return '_';
    }),
    ('樹果能量/h', '', 'v', (m) {
      return '${m.gn('BI')} * ${m.gn('AN')}';
    }),
    ('食材1/1級', '', 'v', (m) {
      return '';
    }),
    ('食材1/1級', '', 'v', (m) {
      return '';
    }),
    ('食材2/30級', '', 'v', (m) {
      return '';
    }),
    ('食材2/30級', '', 'v', (m) {
      return '';
    }),
    ('個數', '', 'v', (m) {
      return '';
    }),
    ('食材3/60級', '', 'v', (m) {
      return '';
    }),
    ('食材3/60級', '', 'v', (m) {
      return '';
    }),
    ('個數', '', 'v', (m) {
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
    ('專長編號', '', 'v', (m) {
      return '查表：根據寶可夢決定 （表上的編號：樹果1, 食材2, 技能3）';
    }),
    /* AV */ ('喜愛的果子', '卡比獸喜愛的樹果', 'v', (m) {
      return '為布林值，是否為當週卡比的喜愛樹果，會有全域變數決定是否要將其納入考量；如果不考慮，恆等於 false';
    }),
    ('基礎間隔', '', 'v', (m) {
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
    ('果子機率', '', '', (m) {
      return '';
    }),
    ('果實預期次數/h', '', '', (m) {
      return '';
    }),
    ('食材機率', '', '', (m) {
      return '';
    }),
    ('食材預期次數/h', '', '', (m) {
      return '';
    }),
    ('食材1個數/h', '', '', (m) {
      return '';
    }),
    ('食材2個數/h', '', '', (m) {
      return '';
    }),
    ('食材3個數/h', '', '', (m) {
      return '';
    }),
    ('樹果能量/h', '', '', (m) {
      return '';
    }),
    ('食材個/h', '', '', (m) {
      return '';
    }),
    ('食材能量/h', '', '', (m) {
      return '';
    }),
    ('次數/h', '', '', (m) {
      return '';
    }),
    ('主技能效益/h', '', '', (m) {
      return '';
    }),
    ('果子機率', '', '', (m) {
      return '';
    }),
    ('果實預期次數/h', '', '', (m) {
      return '';
    }),
    ('食材機率', '', '', (m) {
      return '';
    }),
    ('食材預期次數/h', '', '', (m) {
      return '';
    }),
    ('食材1個數/h', '', '', (m) {
      return '';
    }),
    ('食材2個數/h', '', '', (m) {
      return '';
    }),
    ('食材3個數/h', '', '', (m) {
      return '';
    }),
    ('樹果能量/h', '', '', (m) {
      return '';
    }),
    ('食材個/h', '', '', (m) {
      return '';
    }),
    ('食材能量/h', '', '', (m) {
      return '';
    }),
    ('次數/h', '', '', (m) {
      return '';
    }),
    ('主技能效益/h', '', '', (m) {
      return '';
    }),
    ('食材1售價', '', '', (m) {
      return '';
    }),
    ('食材2售價', '', '', (m) {
      return '';
    }),
    ('食材3售價', '', '', (m) {
      return '';
    }),
    ('食材1能量', '', '', (m) {
      return '';
    }),
    ('食材2能量', '', '', (m) {
      return '';
    }),
    ('食材3能量', '', '', (m) {
      return '';
    }),
    ('性格編號', '', '', (m) {
      return '';
    }),
    ('性格增', '', '', (m) {
      return '';
    }),
    ('性格減', '', '', (m) {
      return '';
    }),
    ('SSk10Ix', '', '', (m) {
      return '';
    }),
    ('SSk25Ix', '', '', (m) {
      return '';
    }),
    ('SSk50Ix', '', '', (m) {
      return '';
    }),
    ('SSk75Ix', '', '', (m) {
      return '';
    }),
    ('SSk100Ix', '', '', (m) {
      return '';
    }),
    ('樹果+1確認', '', 'v', (m) {
      // 1. 「目前等級中」，所有的副技能有沒有樹果數量 S
      // 2. 只會有最多一個樹果數量Ｓ！（因為是最高階副技能）

      // IF(
      //    OR(
      //      $EF7=1,$EG7=1,$EH7=1,$EI7=1,$EJ7=1
      //    ),
      //    AL7*1,
      //    0
      // ),
      return '目前等級中，已開放的副技能，如果有數果數量 S 的副技能，則回傳 ${m.gn('AL')}，否則為零';
    }),
    ('幫忙M確認', '', 'v', (m) {
      //=IF(
      //    OR(
      //      $EF7=7,$EG7=7,$EH7=7,$EI7=7,$EJ7=7
      //    ),
      //    0.86,
      //    1
      // )
      return '';
    }),
    ('幫忙S+M確認', '', 'v', (m) {
      // EM 幫忙S+M確認:
      // 8 => 幫忙速度S

      // IF(
      //    OR($EF7=8,$EG7=8,$EH7=8,$EI7=8,$EJ7=8),
      //    IF(EL7=0.86,0.79,0.93),
      //    IF(EL7=0.86,0.86,1)
      // )
      return '';
    }),
    ('食材M確認', '', 'v', (m) {
      // =IFERROR(IF(OR($EF7=9,$EG7=9,$EH7=9,$EI7=9,$EJ7=9),1.36,1),)
      // EN 食材M確認:
      return '';
    }),
    /* EO */ ('食材S+M確認', '', 'v', (m) {
      // IF(
      //    OR($EF7=10,$EG7=10,$EH7=10,$EI7=10,$EJ7=10),
      //    IF(EN7=1.36,1.54,1.18),
      //    IF(EN7=1.36,1.36,1)
      // ),
      return '';
    }),
    ('技能幾率M確認', '', '', (m) {
      return '';
    }),
    ('技能幾率S+M確認', '', '', (m) {
      // IF(
      //      OR($EF7=18,$EG7=18,$EH7=18,$EI7=18,$EJ7=18),
      //      IF(EP7=1.36,1.54,1.18),
      //      IF(EP7=1.36,1.36,1)
      // ),
      return '';
    }),
    ('加成後主技能等級', '', '', (m) {
      // ER
      // =FW7 + IF(OR($EF7=15,$EG7=15,$EH7=15,$EI7=15,$EJ7=15),2,0)+IF(OR($EF7=16,$EG7=16,$EH7=16,$EI7=16,$EJ7=16),1,0)
      return '';
    }),
    ('SSk10Ix', '', '', (m) {
      return '';
    }),
    ('SSk25Ix', '', '', (m) {
      return '';
    }),
    ('SSk50Ix', '', '', (m) {
      return '';
    }),
    ('樹果+1確認', '', '', (m) {
      return '';
    }),
    ('幫忙M確認', '', '', (m) {
      return '';
    }),
    ('幫忙S+M確認', '', '', (m) {
      return '';
    }),
    ('食材M確認', '', '', (m) {
      return '';
    }),
    ('食材S+M確認', '', '', (m) {
      return '';
    }),
    ('技能幾率M確認', '', '', (m) {
      return '';
    }),
    ('技能幾率S+M確認', '', '', (m) {
      return '';
    }),
    ('加成後主技能等級', '', '', (m) {
      return '';
    }),
    ('SSk10Ix', '', '', (m) {
      return '';
    }),
    ('SSk25Ix', '', '', (m) {
      return '';
    }),
    ('SSk50Ix', '', '', (m) {
      return '';
    }),
    ('SSk75Ix', '', '', (m) {
      return '';
    }),
    ('SSk100Ix', '', '', (m) {
      return '';
    }),
    ('樹果+1確認', '', '', (m) {
      return '';
    }),
    ('幫忙M確認', '', '', (m) {
      return '';
    }),
    ('幫忙S+M確認', '', '', (m) {
      return '';
    }),
    ('食材M確認', '', '', (m) {
      return '';
    }),
    ('食材S+M確認', '', '', (m) {
      return '';
    }),
    ('技能幾率M確認', '', '', (m) {
      return '';
    }),
    ('技能幾率S+M確認', '', '', (m) {
      return '';
    }),
    ('加成後主技能等級', '', '', (m) {
      return '';
    }),
    ('名稱', '', 'v', (m) {
      return 'user_input';
    }),
    ('等級', '', 'v', (m) {
      return 'user_input';
    }),
    ('食材2', '', 'v', (m) {
      return 'user_input';
    }),
    ('個數', '', 'v', (m) {
      return 'user_input';
    }),
    ('食材3', '', 'v', (m) {
      return 'user_input';
    }),
    ('個數', '', 'v', (m) {
      return 'user_input';
    }),
    ('主技能等級', '', 'v', (m) {
      return 'user_input';
    }),
    ('10', '10副技能', 'v', (m) {
      return 'user_input';
    }),
    ('25', '25副技能', 'v', (m) {
      return 'user_input';
    }),
    ('50', '50副技能', 'v', (m) {
      return 'user_input';
    }),
    ('75', '75副技能', 'v', (m) {
      return 'user_input';
    }),
    ('100', '100副技能', 'v', (m) {
      return 'user_input';
    }),
    ('性格', '', 'v', (m) {
      return 'user_input';
    }),
    ('樹果能量/h', '', 'v', (m) {
      return m.gn('CH');
    }),
    ('食材個/h', '', 'v', (m) {
      return m.gn('CI');
    }),
    ('食材能量/h', '', 'v', (m) {
      return m.gn('CJ');
    }),
    ('技能次數/d', '', 'v', (m) {
      return m.gn('CK');
    }),
    ('主技能效益/h', '', 'v', (m) {
      return m.gn('CL');
    }),
    ('50自身收益/h', '', '', (m) {
      return '';
    }),
    ('50輔助隊友收益/h', '', 'v', (m) {
      return '${m.gn('GK')}-${m.gn('GI')}';
    }),
    ('50收益/h', '', '', (m) {
      return '';
    }),
    ('50白板/h', '', '', (m) {
      return '';
    }),
    ('影響', '', '', (m) {
      return '';
    }),
    ('樹果能量/h', '', '', (m) {
      return '';
    }),
    ('食材個/h', '', '', (m) {
      return '';
    }),
    ('食材能量/h', '', '', (m) {
      return '';
    }),
    ('技能次數/d', '', '', (m) {
      return '';
    }),
    ('主技能效益/h', '', '', (m) {
      return '';
    }),
    ('100自身收益/h', '', '', (m) {
      return '';
    }),
    ('100輔助隊友收益/h', '', '', (m) {
      return '';
    }),
    ('100收益/h', '', '', (m) {
      return '';
    }),
    ('100白板/h', '', '', (m) {
      return '';
    }),
    ('影響', '', '', (m) {
      return '';
    }),
    ('50評級', '', '', (m) {
      return '';
    }),
    ('100評級', '', '', (m) {
      return '';
    }),
    ('100時收益', '', '', (m) {
      return '';
    }),
  ].mapIndexed((index, element) {
    return DataColumn(index, element.$1, element.$2, element.$3, element.$4);
  }).toList();

  final columnCodeMapping = columns.toMap(
    (col) => col.columnCode,
    (col) => col,
  );

  for (final column in columns) {
    if (column.status == 'v') {
      _successColumnCodeSet.add(column.columnCode);
    }
  }

  print('EF~EJ 都是跟 level 等級有關的副技能 (表上的副技能數值需要查表對應到的實際技能)');

  final calcSuccess = {
    'AX', 'DW', 'DX', 'DY', 'BQ', 'BO',  'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'D', 'T', 'EK'
    'AL', 'AO', 'AR', 'AM', 'EF', 'EG', 'EH', 'EI', 'EJ', 'EM', 'EN', 'EK', 'EO', 'AL', 'AN', 'EV', 'AP', 'AQ', 'FI', 'AS', 'AT', 'CC',
    'FQ', 'FR', 'FS', 'FT', 'FU', 'FV', 'FW', 'FX', 'FY', 'FZ', 'GA', 'GB', 'GC', 'CA', 'AV', 'AW', 'BB',
  };

  for (final column in columns) {
    // if (calcSuccess.contains(column.columnCode)) {
    //   continue;
    // }
    // if (column.status == 'v') {
    //   continue;
    // }
    // print('(${column.status}) ${column.columnCode} ${column.name}: ${column.formulaBuilder(columnCodeMapping)}');
    print('${column.columnCode} ${column.name}');
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

extension _ColumnMappingX on Map<String, DataColumn> {
  /// gn = get name
  String gn(String columnCode) {
    String text = this[columnCode]!.name;
    if (_useTaiwanName && this[columnCode]!.tName.isNotEmpty) {
      text = this[columnCode]!.tName;
    }
    final success = _successColumnCodeSet.contains(columnCode);
    return '「$text($columnCode)${success ? '*' : ''}」';
  }
}
















