import 'package:pokemon_sleep_tools/data/models/models.dart';

class CreatePokemonProfilePayload {
  CreatePokemonProfilePayload({
    required this.basicProfileId,
    required this.subSkills,
    required this.character,
    required this.ingredient2,
    required this.ingredientCount2,
    required this.ingredient3,
    required this.ingredientCount3,
  });

  final int basicProfileId;

  /// [subSkills]
  /// - Length fixed to 5
  /// - Lv. 10, 25, 50, 75, 100
  final List<SubSkill> subSkills;
  final PokemonCharacter character;
  final Ingredient ingredient2;
  final int ingredientCount2;
  final Ingredient ingredient3;
  final int ingredientCount3;

}