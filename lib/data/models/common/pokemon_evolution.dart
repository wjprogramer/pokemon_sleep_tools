class PokemonEvolution {
  PokemonEvolution({
    required this.id,
    required this.pokemonIdList,
  });

  /// Custom id from this app
  final int id;

  /// [PokemonBasicProfile.id] list
  final List<int> pokemonIdList;
}