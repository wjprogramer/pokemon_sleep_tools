library my_local_storage;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

export 'models/app_meta.dart';

part 'models/base_local_file.dart';
part 'models/stored_pokemon_profiles.dart';
part 'models/stored_pokemon_teams.dart';

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

      final writeFuture = switch (resource) {
        StoredPokemonProfiles() => writePokemonProfiles(resource),
        StoredPokemonTeams() => writePokemonTeams(resource),
      };
      await writeFuture;

      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> readWrite<T extends BaseLocalFile>(Type resource, Future<T> Function(T stored) callback) async {
    try {
      T? stored;
      // if (T == StoredPokemonProfiles) {
      //   stored = (await readPokemonFile()) as T;
      // } else if (T == StoredPokemonTeams) {
      //   stored = (await readPokemonTeams()) as T;
      // }
      stored = switch (T) {
        StoredPokemonProfiles => (await readPokemonFile()) as T,
        StoredPokemonTeams => (await readPokemonTeams()) as T,
        Type() => null,
      };

      final res = await callback(stored!);

      final writeFuture = switch (res) {
        StoredPokemonProfiles() => writePokemonProfiles(res),
        StoredPokemonTeams() => writePokemonTeams(res),
      };
      await writeFuture;
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
      return _cache.storedPokemonProfiles;
    }
    final file = File(_pokemonProfileFilePath);
    StoredPokemonProfiles result;
    if (file.notExistsSync()) {
      result = StoredPokemonProfiles.empty();
    } else {
      result = StoredPokemonProfiles.fromJson(json.decode(file.readAsStringSync()));
    }
    _cache.storedPokemonProfiles = result;
    return result;
  }

  Future<void> writePokemonProfiles(StoredPokemonProfiles data) async {
    final file = File(_pokemonProfileFilePath);
    file.writeAsStringSync(jsonEncode(data.toJson()));
  }
  // endregion Pokemon Profiles

  // region Pokemon Teams
  String get _pokemonTeamsFilePath {
    return path.join(_parent.path, 'pokemon_teams.json');
  }

  Future<StoredPokemonTeams> readPokemonTeams() async {
    final file = File(_pokemonTeamsFilePath);
    StoredPokemonTeams result;
    if (file.notExistsSync()) {
      result = StoredPokemonTeams();
    } else {
      result = StoredPokemonTeams.fromJson(json.decode(file.readAsStringSync()));
    }
    return result;
  }

  Future<void> writePokemonTeams(StoredPokemonTeams data) async {
    final file = File(_pokemonTeamsFilePath);
    file.writeAsStringSync(jsonEncode(data.toJson()));
  }
  // endregion Pokemon Teams

}