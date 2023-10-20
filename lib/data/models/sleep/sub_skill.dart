import 'dart:ui';

import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

enum SubSkill {
  berryCountS(1, '樹果數量s', '一次撿來的樹果數量會增加1個', 3),
  helperBonus(2, '幫手獎勵', '全隊成員的幫忙間隔都會縮短5%', 3),
  helpSpeedM(3, '幫忙速度M', '幫忙間隔會縮短14%', 2),
  helpSpeedS(4, '幫忙速度S', '幫忙間隔會縮短7%', 1),
  ingredientRateM(5, '食材機率M', '帶回食材的機率會提升36%', 2),
  ingredientRateS(6, '食材機率S', '帶回食材的機率會提升18%', 1),
  skillLevelM(7, '技能等級M', '主技能等級會提升2', 3),
  skillLevelS(8, '技能等級S', '主技能等級會提升1', 2),
  skillRateM(9, '技能機率M', '發動主技能的機率會提升36%', 2),
  skillRateS(10, '技能機率S', '發動主技能的機率會提升18%', 1),
  holdMaxL(11, '持有上限L', '樹果、食材的持有上限會增加18個', 2),
  holdMaxM(12, '持有上限M', '樹果、食材的持有上限會增加12個', 2),
  holdMaxS(13, '持有上限S', '樹果、食材的持有上限會增加6個', 1),
  energyRecoverBonus(14, '活力回復獎勵', '全隊成員透過睡眠回復的活力都會變成1.12倍', 3),
  sleepExpBonus(15, '睡眠EXP獎勵', '全隊成員透過睡眠獲得的EXP都會增加14%', 3),
  researchExpBonus(16, '研究EXP獎勵', '透過睡眠研究獲得的研究EXP都會增加6%', 3),
  dreamChipBonus(17, '夢之碎片獎勵', '透過睡眠研究獲得的夢之碎片會增加6%', 3);

  const SubSkill(this.id, this.nameI18nKey, this.intro, this.rarity);

  final int id;
  final String nameI18nKey;
  final String intro;

  /// 遊戲內有黃藍灰背景的副技能，應該是用於區分稀有度?
  final int rarity;

  Color get bgColor {
    switch (rarity) {
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

/*

### TODO 待查證

https://forum.gamer.com.tw/Co.php?bsn=36685&sn=6715

這邊可以發現幫忙速度下降的結果大概是原本正常幫忙速度的1.10倍。
然後以副技能來講的話[幫忙速度S]的效果是-0.07倍，
上位技能[幫忙速度M]的效果是-0.14倍，
所以可以把個性的影響當成對應的1.3倍的S等級副技能，
這邊不負責任推測，食材機率上升和主技能機率上升的機率都是原先機率上提升25%。

這邊建議一下個性的選擇方向，首先幫忙速度下降的都不好，
另外++能力不推薦活力回復量(反正睡爆都是回到100還有枕頭等道具和其它技能能回...)，
再來就是看專長選擇要上升的東西了。

 */
