part of '../local_storage.dart';

final class StoredPokemonSleepFaceStyles implements BaseLocalFile {
  StoredPokemonSleepFaceStyles({
    Map<int, List<int>>? markStylesOf,
  }) {
    _markStylesOf = markStylesOf ?? {};
  }

  factory StoredPokemonSleepFaceStyles.fromJson(Map<String, dynamic> json) {
    final rawMarkStylesOf = json['markStylesOf'] as Map;
    final markStylesOf = <int, List<int>>{};

    for (var entry in rawMarkStylesOf.entries) {
      final basicProfileId = int.parse(entry.key);
      markStylesOf[basicProfileId] = (entry.value as List).whereType<int>().toList();
    }

    return StoredPokemonSleepFaceStyles(markStylesOf: markStylesOf);
  }

  late Map<int, List<int>> _markStylesOf;
  Map<int, List<int>> get markStylesOf => _markStylesOf;

  Map<String, dynamic> toJson() {
    final markStylesOfJsonObj = {};

    for (var entry in _markStylesOf.entries) {
      markStylesOfJsonObj[entry.key.toString()] = entry.value;
    }

    return {
      'markStylesOf': markStylesOfJsonObj,
    };
  }

  Future<Map<int, List<int>>> mark(int basicProfileId, int style) async {
    if (!_markStylesOf.containsKey(basicProfileId)) {
      _markStylesOf[basicProfileId] = [];
    }
    if (_markStylesOf[basicProfileId]!.contains(style)) {
      return _markStylesOf;
    }
    _markStylesOf[basicProfileId]!.add(style);
    return _markStylesOf;
  }

  Future<Map<int, List<int>>> removeMark(int basicProfileId, int style) async {
    if (!_markStylesOf.containsKey(basicProfileId)) {
      return _markStylesOf;
    }
    if (_markStylesOf[basicProfileId]!.contains(style)) {
      _markStylesOf[basicProfileId]!.remove(style);
    }
    if (_markStylesOf[basicProfileId]!.isEmpty) {
      _markStylesOf.remove(basicProfileId);
    }
    return _markStylesOf;
  }

}