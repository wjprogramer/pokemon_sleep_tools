

class CreatePokemonTeamPayload {
  CreatePokemonTeamPayload({
    required this.name,
    required this.profileIdList,
  });

  final String? name;
  final List<int> profileIdList;

}