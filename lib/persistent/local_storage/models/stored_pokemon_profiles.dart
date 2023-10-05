part of '../local_storage.dart';

final class StoredPokemonProfiles implements BaseLocalFile {
  StoredPokemonProfiles({
    int? lastIndex,
    List<PokemonProfile>? profiles,
  })  {
    _lastIndex = lastIndex ?? _lastIndex;
    _profiles = profiles ?? _profiles;
  }

  factory StoredPokemonProfiles.fromJson(Map<String, dynamic> json) {
    return StoredPokemonProfiles(
      lastIndex: json['lastIndex'],
      profiles: (json['profiles'] as List)
          .map((e) => PokemonProfile.fromJson(e))
          .toList(),
    );
  }

  factory StoredPokemonProfiles.empty() {
    return StoredPokemonProfiles();
  }

  int _lastIndex = -1;
  int get lastIndex => _lastIndex;

  var _profiles = <PokemonProfile>[];
  List<PokemonProfile> get profiles => _profiles;

  Map<String, dynamic> toJson() {
    return {
      'lastIndex': _lastIndex,
      'profiles': _profiles
          .map((profile) => profile.toJson())
          .toList(),
    };
  }

  Future<int> insert(PokemonProfile profile) async {
    _lastIndex++;

    try {
      final index = _lastIndex;

      profile.id = index;
      _profiles.add(profile);

      return index;
    } catch (e) {
      _lastIndex--;
      rethrow;
    }
  }

  Future<void> update(PokemonProfile profile) async {
    final index = _profiles.indexOrNullWhere((e) => e.id == profile.id);
    if (index == null) {
      throw Exception(); // Not found
    }

    _profiles[index] = profile;
  }

  Future<void> delete(int profileId) async {
    _profiles.removeFirstWhere((e) => e.id == profileId);
  }

}