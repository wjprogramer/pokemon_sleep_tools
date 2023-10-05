import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel();

  PokemonProfileRepository get _profileRepo => getIt();

  MyCacheManager get _cache => getIt();

  StoredPokemonProfiles get _storedPokemonProfiles => _cache.storedPokemonProfiles;
  List<PokemonProfile> get profiles => _storedPokemonProfiles.profiles;

  Future<PokemonProfile> createProfile(CreatePokemonProfilePayload payload) async {
    final res = await _profileRepo.create(payload);
    notifyListeners();
    return res;
  }

  Future<PokemonProfile> updateProfile(PokemonProfile newPokemonProfile) async {
    await _profileRepo.update(newPokemonProfile);
    notifyListeners();
    return newPokemonProfile;
  }

  Future<void> deleteProfile(int profileId) async {
    await _profileRepo.delete(profileId);
    notifyListeners();
  }

  Future<List<PokemonProfile>> loadProfiles() async {
    await _profileRepo.findAll();
    notifyListeners();
    return profiles;
  }

}