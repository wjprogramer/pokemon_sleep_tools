import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_repository.dart';

class PokemonProfileRepository {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  PokemonProfile create(CreatePokemonProfilePayload payload) {
    final profile = PokemonProfile(
      basicProfileId: payload.basicProfileId,
      character: payload.character,
      subSkillLv10: payload.subSkills[0],
      subSkillLv25: payload.subSkills[1],
      subSkillLv50: payload.subSkills[2],
      subSkillLv75: payload.subSkills[3],
      subSkillLv100: payload.subSkills[4],
      ingredient2: payload.ingredient2,
      ingredientCount2: payload.ingredientCount2,
      ingredient3: payload.ingredient3,
      ingredientCount3: payload.ingredientCount3,
    );

    final basicProfile = _basicProfileRepo.getBasicProfile(profile.basicProfileId)!;
    profile.basicProfile = basicProfile;

    return profile;
  }

  PokemonProfile getDemoProfile() {
    final profile = PokemonProfile(
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
    );

    final basicProfile = _basicProfileRepo.getBasicProfile(profile.basicProfileId)!;
    profile.basicProfile = basicProfile;

    return profile;
  }

  List<PokemonProfile> getDemoProfiles() {
    final results = getAllDemoProfiles();

    for (final result in results) {
      final basicProfile = _basicProfileRepo.getBasicProfile(result.basicProfileId)!;
      result.basicProfile = basicProfile;
    }


    return results;
  }

}