import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

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
  StoredPokemonProfiles get storedPokemonProfiles => _storedPokemonProfiles;
  set storedPokemonProfiles(StoredPokemonProfiles value) {
    _storedPokemonProfiles = value;
    _statusOf[StoredPokemonProfiles] = true;
  }

}