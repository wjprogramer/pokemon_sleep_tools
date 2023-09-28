import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonProfile {
  PokemonProfile({
    this.id = -1,
    required this.basicProfileId,
    required this.character,
    required this.subSkillLv10,
    required this.subSkillLv25,
    required this.subSkillLv50,
    required this.subSkillLv75,
    required this.subSkillLv100,
    required this.ingredient2,
    required this.ingredientCount2,
    required this.ingredient3,
    required this.ingredientCount3,
  });

  // TODO:
  int id = -1;
  final int basicProfileId;
  late PokemonBasicProfile basicProfile;
  final PokemonCharacter character;

  final SubSkill subSkillLv10;
  final SubSkill subSkillLv25;
  final SubSkill subSkillLv50;
  final SubSkill subSkillLv75;
  final SubSkill subSkillLv100;

  Ingredient get ingredient1 => basicProfile.ingredient1;
  int get ingredientCount1 => basicProfile.ingredientCount1;
  final Ingredient ingredient2;
  final int ingredientCount2;
  final Ingredient ingredient3;
  final int ingredientCount3;

  List<SubSkill> get subSkills => [
    subSkillLv10,
    subSkillLv25,
    subSkillLv50,
    subSkillLv75,
    subSkillLv100,
  ];

  factory PokemonProfile.fromJson(Map<String, dynamic> json) {
    final subSkillMapping = SubSkill.values.toMap(
        (e) => e.id, (e) => e,
    );

    getIngredientById(int id) {
      return Ingredient.values.firstWhere((ingredient) => ingredient.id == id);
    }

    return PokemonProfile(
      basicProfileId: json['basicProfileId'],
      character: PokemonCharacter.values
          .firstWhere((e) => e.id == json['characterId']),
      subSkillLv10: subSkillMapping[json['subSkillIds'][0]]!,
      subSkillLv25: subSkillMapping[json['subSkillIds'][1]]!,
      subSkillLv50: subSkillMapping[json['subSkillIds'][2]]!,
      subSkillLv75: subSkillMapping[json['subSkillIds'][3]]!,
      subSkillLv100: subSkillMapping[json['subSkillIds'][4]]!,
      ingredient2: getIngredientById(json['ingredient2Id']),
      ingredientCount2: json['ingredientCount2'],
      ingredient3: getIngredientById(json['ingredient3Id']),
      ingredientCount3: json['ingredientCount3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basicProfileId': basicProfileId,
      'characterId': character.id,
      'id': id,
      'subSkillIds': subSkills.map((e) => e.id).toList(),
      'ingredient2Id': ingredient2.id,
      'ingredientCount2': ingredientCount2,
      'ingredient3Id': ingredient3.id,
      'ingredientCount3': ingredientCount3,
    };
  }

  String getConstructorCode() {
    return
      'PokemonProfile(\n'
          '   basicProfileId: $basicProfileId,\n'
          '   character: $character,\n'
          '   subSkillLv10: $subSkillLv10,\n'
          '   subSkillLv25: $subSkillLv25,\n'
          '   subSkillLv50: $subSkillLv50,\n'
          '   subSkillLv75: $subSkillLv75,\n'
          '   subSkillLv100: $subSkillLv100,\n'
          '   ingredient2: $ingredient2,\n'
          '   ingredientCount2: $ingredientCount2,\n'
          '   ingredient3: $ingredient3,\n'
          '   ingredientCount3: $ingredientCount3,\n'
          ')';
  }

  String info() {
    return '';
  }

}