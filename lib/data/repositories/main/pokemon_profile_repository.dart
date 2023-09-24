import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_repository.dart';

class PokemonProfileRepository {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  create(CreatePokemonProfilePayload payload) {
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



}