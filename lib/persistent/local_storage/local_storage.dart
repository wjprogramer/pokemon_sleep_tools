library my_local_storage;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path/path.dart' as path;

export 'models/app_meta.dart';

part 'models/base_local_file.dart';
part 'models/stored_pokemon_profiles.dart';
part 'models/stored_pokemon_sleep_face_styles.dart';
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
        StoredPokemonSleepFaceStyles() => writePokemonSleepFaces(resource),
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
        StoredPokemonSleepFaceStyles => (await readPokemonSleepFaces()) as T,
        Type() => null,
      };

      final res = await callback(stored!);

      final writeFuture = switch (res) {
        StoredPokemonProfiles() => writePokemonProfiles(res),
        StoredPokemonTeams() => writePokemonTeams(res),
        StoredPokemonSleepFaceStyles() => writePokemonSleepFaces(res),
      };
      await writeFuture;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> exportData() async {
    final dir = await getTemporaryDirectory();
    final filePath = path.join(dir.path, 'pokemon_sleep.json');

    final res = _LocalStoredDocumentResult(
      profiles: await readPokemonFile(),
      faceStyles: await readPokemonSleepFaces(),
      teams: await readPokemonTeams(),
    );

    final file = File(filePath)
      ..createSync()
      ..writeAsStringSync(json.encode(res.toJson()));

    await FileSaver.instance.saveAs(
      name: 'sleep_data',
      ext: 'json',
      mimeType: MimeType.text,
      file: file,
    );
  }

  Future<void> importData() async {
    final file = await FileUtility.pickSingleFile();
    if (file == null) {
      return;
    }

    final content = file.readAsStringSync();
    final jsonObj = json.decode(content);
    final result = _LocalStoredDocumentResult.fromJson(jsonObj);

    final profiles = result.profiles;
    final faceStyles = result.faceStyles;
    final teams = result.teams;

    if (profiles != null) { await writePokemonProfiles(profiles); }
    if (faceStyles != null) { await writePokemonSleepFaces(faceStyles); }
    if (teams != null) { await writePokemonTeams(teams); }
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

  // region Pokemon Sleep Faces
  String get _pokemonSleepFacesFilePath {
    return path.join(_parent.path, 'pokemon_sleep_faces.json');
  }

  Future<StoredPokemonSleepFaceStyles> readPokemonSleepFaces() async {
    final file = File(_pokemonSleepFacesFilePath);
    StoredPokemonSleepFaceStyles result;
    if (file.notExistsSync()) {
      result = StoredPokemonSleepFaceStyles();
    } else {
      result = StoredPokemonSleepFaceStyles.fromJson(json.decode(file.readAsStringSync()));
    }
    return result;
  }

  Future<void> writePokemonSleepFaces(StoredPokemonSleepFaceStyles data) async {
    final file = File(_pokemonSleepFacesFilePath);
    file.writeAsStringSync(jsonEncode(data.toJson()));
  }
  // endregion Pokemon Sleep Faces

}

/// 完整本地端匯入、匯出檔案結構
class _LocalStoredDocumentResult {
  _LocalStoredDocumentResult({
    required this.profiles,
    required this.faceStyles,
    required this.teams,
  });

  StoredPokemonProfiles? profiles;
  StoredPokemonSleepFaceStyles? faceStyles;
  StoredPokemonTeams? teams;

  factory _LocalStoredDocumentResult.fromJson(Map<String, dynamic> json) {
    return _LocalStoredDocumentResult(
      profiles: json['profiles'] == null ? null : StoredPokemonProfiles.fromJson(json['profiles']),
      faceStyles: json['faceStyles'] == null ? null : StoredPokemonSleepFaceStyles.fromJson(json['faceStyles']),
      teams: json['teams'] == null ? null : StoredPokemonTeams.fromJson(json['teams']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profiles': profiles?.toJson(),
      'faceStyles': faceStyles?.toJson(),
      'teams': teams?.toJson(),
    };
  }

}
