

class CreatePokemonTeamPayload {
  CreatePokemonTeamPayload({
    required this.index,
    required this.name,
    required this.profileIdList,
    required this.comment,
  });

  final int index;
  final String? name;
  final List<int> profileIdList;
  final String? comment;

}