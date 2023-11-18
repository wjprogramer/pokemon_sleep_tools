import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/data_sources/data_sources.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class SleepFaceRepository implements MyInjectable {
  MyLocalStorage get _localStorage => getIt();

  Future<Map<int, Map<int, String>>> findAllNames() async {
    return DataSources.findSleepFaceNames();
  }

  Future<List<SleepFace>> findAll() async {
    return _findAll();
  }

  Future<Map<PokemonField, List<SleepFace>>> findAllGroupByField() async {
    final sleepFaces = await _findAll();
    final mapping = PokemonField.values.toMap(
          (field) => field,
          (field) => <SleepFace>[],
    );
    for (final sleepFace in sleepFaces) {
      mapping[sleepFace.field]!.add(sleepFace);
    }

    return mapping;
  }

  String? getCommonSleepFaceName(int style) {
    if (style == -1) {
      return 't_sleep_face_206'.xTr;
    }
    return null;
  }

  Future<Map<int, List<int>>> getMarkStyles() async {
    return (await _localStorage.readPokemonSleepFaces()).markStylesOf;
  }

  Future<Map<int, List<int>>> markStyle(int basicProfileId, int style) async {
    var res = <int, List<int>>{};
    await _localStorage.readWrite<StoredPokemonSleepFaceStyles>(StoredPokemonSleepFaceStyles, (stored) async {
      res = await stored.mark(basicProfileId, style);
      return stored;
    });
    return res;
  }

  Future<Map<int, List<int>>> removeStyleMark(int basicProfileId, int style) async {
    var res = <int, List<int>>{};
    await _localStorage.readWrite<StoredPokemonSleepFaceStyles>(StoredPokemonSleepFaceStyles, (stored) async {
      res = await stored.removeMark(basicProfileId, style);
      return stored;
    });
    return res;
  }

  Future<List<SleepFace>> _findAll() async {
    return DataSources.findSleepFaces();
  }

}