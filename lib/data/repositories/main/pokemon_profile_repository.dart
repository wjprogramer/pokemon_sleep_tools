import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class PokemonProfileRepository implements MyInjectable {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();
  MyLocalStorage get _localStorage => getIt();
  MyCacheManager get _cache => getIt();

  Future<PokemonProfile> create(CreatePokemonProfilePayload payload) async {
    final profile = PokemonProfile(
      basicProfileId: payload.basicProfileId,
      character: payload.character,
      customName: payload.customName?.trim(),
      customNote: payload.customNote?.trim(),
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
    await _postProcessProfile(profile);

    await _localStorage.use(_cache.storedPokemonProfiles, (stored) async {
      await stored.insert(profile);
      await _localStorage.writePokemonProfiles(stored);
    });

    return profile;
  }

  Future<List<PokemonProfile>> findAll({
    bool force = false,
  }) async {
    final stored = await _localStorage.readPokemonFile(force: force);
    await _postProcessProfiles(stored.profiles);
    return stored.profiles;
  }

  Future<void> update(PokemonProfile newProfile) async {
    await _localStorage.use(_cache.storedPokemonProfiles, (stored) async {
      await stored.update(newProfile);
      await _localStorage.writePokemonProfiles(stored);
    });
  }

  Future<void> delete(int profileId) async {
    await _localStorage.use(_cache.storedPokemonProfiles, (stored) async {
      await stored.delete(profileId);
      await _localStorage.writePokemonProfiles(stored);
    });
  }

  Future<PokemonProfile> getDemoProfile() async {
    final profile = PokemonProfile(
      basicProfileId: 18,
      character: PokemonCharacter.restrained,
      customName: null,
      customNote: null,
      subSkillLv10: SubSkill.ingredientRateS,
      subSkillLv25: SubSkill.helpSpeedS,
      subSkillLv50: SubSkill.holdMaxS,
      subSkillLv75: SubSkill.dreamChipBonus,
      subSkillLv100: SubSkill.holdMaxM,
      ingredient2: Ingredient.i11,
      ingredientCount2: 2,
      ingredient3: Ingredient.i11,
      ingredientCount3: 3,
    );
    await _postProcessProfile(profile);
    return profile;
  }

  Future<List<PokemonProfile>> getDemoProfiles() async {
    final profiles = getAllDemoProfiles();
    await _postProcessProfiles(profiles);
    return profiles;
  }

  Future<void> _postProcessProfiles(List<PokemonProfile> profiles) async {
    for (final profile in profiles) {
      await _postProcessProfile(profile);
    }
  }

  Future<void> _postProcessProfile(PokemonProfile profile) async {
    final basicProfile = (await _basicProfileRepo.getBasicProfile(profile.basicProfileId))!;
    profile.basicProfile = basicProfile;
  }

}