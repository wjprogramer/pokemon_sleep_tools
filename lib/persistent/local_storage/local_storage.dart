import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/persistent/local_storage/models/stored_pokemon_profiles.dart';

class MyLocalStorage {

  late Directory _parent;

  Future<void> init() async {
    _parent = await getApplicationSupportDirectory();
  }

  // region Meta
  String get _metaFilePath {
    return path.join(_parent.path, 'meta.json');
  }

  Future<String?> readRawMetaFile() async {
    final file = File(_metaFilePath);
    if (file.notExistsSync()) {
      file.createSync();
    }
    file.readAsStringSync();
    return null;
  }

  Future writeMetaFile(String value) async {
  }
  // endregion Meta

  // region Pokemon Profiles
  String get _pokemonProfileFilePath {
    return path.join(_parent.path, 'pokemon_profiles.json');
  }

  Future<StoredPokemonProfiles> readPokemonFile() async {
    final file = File(_pokemonProfileFilePath);
    if (file.notExistsSync()) {
      return StoredPokemonProfiles.empty();
    }
    return StoredPokemonProfiles();
  }

  Future<void> writePokemonProfiles(StoredPokemonProfiles data) async {
    final file = File(_pokemonProfileFilePath);
    file.writeAsStringSync(jsonEncode(data.toJson()));
  }
  // endregion Pokemon Profiles

}