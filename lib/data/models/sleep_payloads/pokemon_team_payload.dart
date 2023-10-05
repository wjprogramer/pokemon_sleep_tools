

class CreatePokemonTeamPayload {
  CreatePokemonTeamPayload({
    required this.index,
    required this.name,
    required this.profileIdList,
  });

  final int index;
  final String? name;
  final List<int> profileIdList;

}