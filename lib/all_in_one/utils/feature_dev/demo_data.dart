import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

/// Need set basic profile
List<PokemonProfile> getAllDemoProfiles() {
  final results = <PokemonProfile>[
    PokemonProfile(
      basicProfileId: 18,
      character: PokemonCharacter.restrained,
      subSkillLv10: SubSkill.s6,
      subSkillLv25: SubSkill.s4,
      subSkillLv50: SubSkill.s13,
      subSkillLv75: SubSkill.s17,
      subSkillLv100: SubSkill.s12,
      ingredient2: Ingredient.i11,
      ingredientCount2: 2,
      ingredient3: Ingredient.i11,
      ingredientCount3: 3,
    ),
    PokemonProfile(
       basicProfileId: 7,
       character: PokemonCharacter.c14,
       subSkillLv10: SubSkill.s6,
       subSkillLv25: SubSkill.s9,
       subSkillLv50: SubSkill.s3,
       subSkillLv75: SubSkill.s5,
       subSkillLv100: SubSkill.s10,
       ingredient2: Ingredient.i8,
       ingredientCount2: 5,
       ingredient3: Ingredient.i8,
       ingredientCount3: 7,
    ),
    PokemonProfile(
       basicProfileId: 47,
       character: PokemonCharacter.c17,
       subSkillLv10: SubSkill.s13,
       subSkillLv25: SubSkill.s9,
       subSkillLv50: SubSkill.s12,
       subSkillLv75: SubSkill.s4,
       subSkillLv100: SubSkill.s7,
       ingredient2: Ingredient.i2,
       ingredientCount2: 4,
       ingredient3: Ingredient.i2,
       ingredientCount3: 6,
    ),
    PokemonProfile(
       basicProfileId: 20,
       character: PokemonCharacter.c25,
       subSkillLv10: SubSkill.s6,
       subSkillLv25: SubSkill.s10,
       subSkillLv50: SubSkill.s4,
       subSkillLv75: SubSkill.s13,
       subSkillLv100: SubSkill.s13,
       ingredient2: Ingredient.i10,
       ingredientCount2: 2,
       ingredient3: Ingredient.i13,
       ingredientCount3: 2,
    ),
    PokemonProfile(
       basicProfileId: 33,
       character: PokemonCharacter.c15,
       subSkillLv10: SubSkill.s16,
       subSkillLv25: SubSkill.s3,
       subSkillLv50: SubSkill.s17,
       subSkillLv75: SubSkill.s5,
       subSkillLv100: SubSkill.s13,
       ingredient2: Ingredient.i4,
       ingredientCount2: 4,
       ingredient3: Ingredient.i12,
       ingredientCount3: 7,
    )
  ];

  return results;
}