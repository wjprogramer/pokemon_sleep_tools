import 'package:pokemon_sleep_tools/data/models/models.dart';

class CreatePokemonTeamPayload {
  CreatePokemonTeamPayload({
    required this.name,
    required this.profileIdList,
  });

  final String? name;
  final List<int> profileIdList;

}