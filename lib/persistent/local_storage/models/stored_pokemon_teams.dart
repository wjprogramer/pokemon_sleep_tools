part of '../local_storage.dart';

/// TODO: 需設定最上數量, [MAX_TEAM_COUNT]
final class StoredPokemonTeams implements BaseLocalFile {
  StoredPokemonTeams({
    int? lastIndex,
    List<PokemonTeam>? teams,
  }) {
    _lastIndex = lastIndex ?? _lastIndex;
    _teams = teams ?? _teams;
  }

  factory StoredPokemonTeams.fromJson(Map<String, dynamic> json) {
    return StoredPokemonTeams(
      lastIndex: json['lastIndex'],
      teams: (json['teams'] as Iterable)
          .map((e) => PokemonTeam.fromJson(e))
          .toList(),
    );
  }

  int _lastIndex = -1;
  int get lastIndex => _lastIndex;

  var _teams = <PokemonTeam>[];
  List<PokemonTeam> get teams => _teams;

  Map<String, dynamic> toJson() {
    return {
      'lastIndex': _lastIndex,
      'teams': _teams
          .map((e) => e.toJson())
          .toList(),
    };
  }

  Future<PokemonTeam> insert(PokemonTeam team) async {
    _lastIndex++;

    try {
      final index = _lastIndex;

      final newTeam = team.copyWith(id: index);
      _teams.add(newTeam);
      return newTeam;
    } catch (e) {
      _lastIndex--;
      rethrow;
    }
  }

  Future<void> replace(PokemonTeam team) async {
    final index = _teams.indexOrNullWhere((t) => t.id == team.id);
    if (index == null) {
      // TODO: improvement
      throw Exception();
    }
    _teams[index] = team;
  }

}
