import 'package:pokemon_sleep_tools/data/models/models.dart';

class CreatePokemonProfilePayload {
  CreatePokemonProfilePayload({
    required this.basicProfileId,
    required this.subSkills,
    required this.character,
    required this.customName,
    required this.customNote,
    required this.isFavorite,
    required this.isShiny,
    required this.customDate,
    this.evolveCount,
    this.useGoldSeedCount,
    required this.ingredient2,
    required this.ingredientCount2,
    required this.ingredient3,
    required this.ingredientCount3,
  });

  final int basicProfileId;

  /// [subSkills]
  /// - Length fixed to 5
  /// - Lv. 10, 25, 50, 75, 100
  final List<SubSkill?> subSkills;
  final PokemonCharacter character;
  final String? customName;
  final String? customNote;
  final bool? isFavorite;
  final bool? isShiny;
  final DateTime? customDate;
  final int? evolveCount;
  final int? useGoldSeedCount;
  final Ingredient? ingredient2;
  final int ingredientCount2;
  final Ingredient? ingredient3;
  final int ingredientCount3;

}