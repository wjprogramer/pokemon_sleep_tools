/// 性格
///
/// TODO: 需要實際將版本切換至英文確認翻譯文本
enum PokemonCharacter {
  afraidLoneliness(1, '怕寂寞', '幫忙速度', '活力回復'),
  stubborn(2, '固執', '幫忙速度', '食材發現'),
  mischievous(3, '頑皮', '幫忙速度', '主技能'),
  brave(4, '勇敢', '幫忙速度', 'EXP'),
  bold(5, '大膽', '活力回復', '幫忙速度'),
  naughty(6, '淘氣', '活力回復', '食材發現'),
  optimism(7, '樂天', '活力回復', '主技能'),
  laidBack(8, '悠閒', '活力回復', 'EXP'),
  restrained(9, '內斂', '食材發現', '幫忙速度'),
  c10(10, '慢吞吞', '食材發現', '活力回復'),
  c11(11, '馬虎', '食材發現', '主技能'),
  c12(12, '冷靜', '食材發現', 'EXP'),
  c13(13, '溫和', '主技能', '幫忙速度'),
  c14(14, '溫順', '主技能', '活力回復'),
  c15(15, '慎重', '主技能', '食材發現'),
  c16(16, '自大', '主技能', 'EXP'),
  c17(17, '膽小', 'EXP', '幫忙速度'),
  c18(18, '急躁', 'EXP', '活力回復'),
  c19(19, '爽朗', 'EXP', '食材發現'),
  c20(20, '天真', 'EXP', '主技能'),
  c21(21, '害羞', null, null),
  c22(22, '勤奮', null, null),
  c23(23, '坦率', null, null),
  c24(24, '浮躁', null, null),
  c25(25, '認真', null, null);

  const PokemonCharacter(this.id, this.nameI18nKey, this.positive, this.negative);

  final int id;
  final String nameI18nKey;
  final String? positive;
  final String? negative;
}