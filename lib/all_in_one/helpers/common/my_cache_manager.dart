import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/persistent/local_storage/models/stored_pokemon_profiles.dart';

class MyCacheManager implements MyInjectable {
  MyCacheManager();

  bool checkSet(Type type) {
    if (!_statusOf.containsKey(type)) {
      _statusOf[type] = false;
      return false;
    }
    return _statusOf[type]!;
  }

  final _statusOf = <Type, bool>{};

  StoredPokemonProfiles _storedPokemonProfiles = StoredPokemonProfiles.empty();
  StoredPokemonProfiles get storedPokemonProfilesXXX => _storedPokemonProfiles;
  set storedPokemonProfilesXXX(StoredPokemonProfiles value) {
    _storedPokemonProfiles = value;
    _statusOf[StoredPokemonProfiles] = true;
  }

}