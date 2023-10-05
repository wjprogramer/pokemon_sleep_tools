import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

class SleepFaceViewModel extends ChangeNotifier {
  SleepFaceViewModel();

  SleepFaceRepository get _repo => getIt();

  /// [PokemonBasicProfile.id] to [SleepFace.style]
  Map<int, List<int>> _markStylesOf = {};
  Map<int, List<int>> get markStylesOf => _markStylesOf;

  Future<void> init() async {
    _markStylesOf = await _repo.getMarkStyles();
    notifyListeners();
  }

  Future<void> mark(int basicProfileId, int style) async {
    _markStylesOf = await _repo.markStyle(basicProfileId, style);
    notifyListeners();
  }

  Future<void> removeMark(int basicProfileId, int style) async {
    _markStylesOf = await _repo.removeStyleMark(basicProfileId, style);
    notifyListeners();
  }

}
