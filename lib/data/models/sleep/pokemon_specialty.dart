/// 專長
enum PokemonSpecialty {
  t1(1, '技能型'),
  t2(2, '食材型'),
  t3(3, '樹果型');

  const PokemonSpecialty(this.id, this.nameI18nKey);

  final int id;

  final String nameI18nKey;
}