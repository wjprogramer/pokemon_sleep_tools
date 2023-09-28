import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';
import 'package:pokemon_sleep_tools/persistent/local_storage/models/base_local_file.dart';
import 'package:pokemon_sleep_tools/persistent/local_storage/models/stored_pokemon_profiles.dart';

export 'models/app_meta.dart';
export 'models/base_local_file.dart';
export 'models/stored_pokemon_profiles.dart';
export 'models/stored_pokemon_teams.dart';

class MyLocalStorage implements MyInjectable {
  MyCacheManager get _cache => getIt();

  late Directory _parent;

  Future<void> init() async {
    _parent = await getApplicationSupportDirectory();
  }

  // region Common
  Future<R> use<T extends BaseLocalFile, R>(T resource, Future<R> Function(T resource) callback) async {
    try {
      final res = await callback(resource);

      if (resource is StoredPokemonProfiles) {
        writePokemonProfiles(resource);
      }

      return res;
    } catch (e) {
      rethrow;
    }
  }
  // endregion

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
    if (_cache.checkSet(StoredPokemonProfiles)) {
      return _cache.storedPokemonProfilesXXX;
    }
    final file = File(_pokemonProfileFilePath);
    StoredPokemonProfiles result;
    if (file.notExistsSync()) {
      result = StoredPokemonProfiles.empty();
    } else {
      result = StoredPokemonProfiles.fromJson(json.decode(file.readAsStringSync()));
    }
    _cache.storedPokemonProfilesXXX = result;
    return result;
  }

  Future<void> writePokemonProfiles(StoredPokemonProfiles data) async {
    final file = File(_pokemonProfileFilePath);
    file.writeAsStringSync(jsonEncode(data.toJson()));
  }
  // endregion Pokemon Profiles

}