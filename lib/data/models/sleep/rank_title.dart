enum RankTitle {
  t1(1, '普通'),
  t2(2, '超級'),
  t3(3, '高級'),
  t4(4, '大師');

  const RankTitle(this.id, this.nameI18nKey);

  final int id;
  final String nameI18nKey;
}