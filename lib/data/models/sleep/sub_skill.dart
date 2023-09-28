import 'dart:ui';

import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

enum SubSkill {
  s1(1, '樹果數量s', '一次撿來的樹果數量會增加1個', 3),
  s2(2, '幫手獎勵', '全隊成員的幫忙間隔都會縮短5%', 3),
  s3(3, '幫忙速度M', '幫忙間隔會縮短14%', 2),
  s4(4, '幫忙速度S', '幫忙間隔會縮短7%', 1),
  s5(5, '食材機率M', '帶回食材的機率會提升36%', 2),
  s6(6, '食材機率S', '帶回食材的機率會提升18%', 1),
  s7(7, '技能等級M', '主技能等級會提升2', 3),
  s8(8, '技能等級S', '主技能等級會提升1', 2),
  s9(9, '技能機率M', '發動主技能的機率會提升36%', 2),
  s10(10, '技能機率S', '發動主技能的機率會提升18%', 1),
  s11(11, '持有上限L', '樹果、食材的持有上限會增加18個', 2),
  s12(12, '持有上限M', '樹果、食材的持有上限會增加12個', 2),
  s13(13, '持有上限S', '樹果、食材的持有上限會增加6個', 1),
  s14(14, '活力回復獎勵', '全隊成員透過睡眠回復的活力都會變成1.12倍', 3),
  s15(15, '睡眠EXP獎勵', '全隊成員透過睡眠獲得的EXP都會增加14%', 3),
  s16(16, '研究EXP獎勵', '透過睡眠研究獲得的研究EXP都會增加6%', 3),
  s17(17, '夢之碎片獎勵', '透過睡眠研究獲得的夢之碎片會增加6%', 3);

  const SubSkill(this.id, this.nameI18nKey, this.intro, this.level);

  final int id;
  final String nameI18nKey;
  final String intro;

  /// 自己設定的
  final int level;

  Color get bgColor {
    switch (level) {
      case 1: return greyColor;
      case 2: return blueColor;
      case 3: return yellowColor;
    }
    return greyColor;
  }

  static const maxCount = 5;

  /// length is [maxCount]
  static List<int> levelList = [10, 25, 50, 75, 100];

}
