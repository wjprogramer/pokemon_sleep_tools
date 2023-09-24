import 'package:pokemon_sleep_tools/data/models/models.dart';

class StoredPokemonProfiles {
  StoredPokemonProfiles();

  factory StoredPokemonProfiles.fromJson() {
    return StoredPokemonProfiles();
  }

  factory StoredPokemonProfiles.empty() {
    return StoredPokemonProfiles();
  }

  int _lastIndex = 0;
  int get lastIndex => _lastIndex;

  final profiles = <PokemonProfile>[];

  Map<String, dynamic> toJson() {
    return {};
  }

  insert(PokemonProfile profile) async {
    profiles.add(profile);
  }

}