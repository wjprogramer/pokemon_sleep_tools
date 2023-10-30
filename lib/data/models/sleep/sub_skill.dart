/// ID 不能亂動，[PokemonProfile] 會儲存副技能的 ID
enum SubSkill {
  berryCountS(1, 't_sub_skill_8', '一次撿來的樹果數量會增加1個', 3),
  helperBonus(2, 't_sub_skill_2', '全隊成員的幫忙間隔都會縮短5%', 3),
  helpSpeedM(3, 't_sub_skill_7', '幫忙間隔會縮短14%', 2),
  helpSpeedS(4, 't_sub_skill_6', '幫忙間隔會縮短7%', 1),
  ingredientRateM(5, 't_sub_skill_13', '帶回食材的機率會提升36%', 2),
  ingredientRateS(6, 't_sub_skill_12', '帶回食材的機率會提升18%', 1),
  skillLevelM(7, 't_sub_skill_18', '主技能等級會提升2', 3),
  skillLevelS(8, 't_sub_skill_11', '主技能等級會提升1', 2),
  skillRateM(9, 't_sub_skill_15', '發動主技能的機率會提升36%', 2),
  skillRateS(10, 't_sub_skill_14', '發動主技能的機率會提升18%', 1),
  holdMaxL(11, 't_sub_skill_19', '樹果、食材的持有上限會增加18個', 2),
  holdMaxM(12, 't_sub_skill_10', '樹果、食材的持有上限會增加12個', 2),
  holdMaxS(13, 't_sub_skill_9', '樹果、食材的持有上限會增加6個', 1),
  energyRecoverBonus(14, 't_sub_skill_3', '全隊成員透過睡眠回復的活力都會變成1.12倍', 3),
  sleepExpBonus(15, 't_sub_skill_1', '全隊成員透過睡眠獲得的EXP都會增加14%', 3),
  researchExpBonus(16, 't_sub_skill_5', '透過睡眠研究獲得的研究EXP都會增加6%', 3),
  dreamChipBonus(17, 't_sub_skill_4', '透過睡眠研究獲得的夢之碎片會增加6%', 3);

  const SubSkill(this.id, this.nameI18nKey, this.intro, this.rarity);

  final int id;
  final String nameI18nKey;
  final String intro;

  /// 遊戲內有黃藍灰背景的副技能，應該是用於區分稀有度?
  final int rarity;

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
