enum PokemonSpecialty {
  t1(1, '技能型'),
  t2(2, '食材型'),
  t3(3, '樹果型');

  const PokemonSpecialty(this.id, this.name);

  final int id;

  final String name;
}