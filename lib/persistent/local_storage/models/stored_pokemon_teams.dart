part of '../local_storage.dart';

/// TODO: 需設定最上數量, [MAX_TEAM_COUNT]
final class StoredPokemonTeams implements BaseLocalFile {
  StoredPokemonTeams({
    List<PokemonTeam?>? teams,
  }) {
    _teams = teams ?? _teams;
  }

  factory StoredPokemonTeams.fromJson(Map<String, dynamic> json) {
    final rawTeams = json['teams'] as Iterable;
    final remainCount = MAX_TEAM_COUNT - rawTeams.length;

    return StoredPokemonTeams(
      teams: [
        ...rawTeams.map((e) => e != null ? PokemonTeam.fromJson(e) : null),
        if (remainCount > 0)
          ...List.generate(remainCount, (index) => null),
      ],
    );
  }

  List<PokemonTeam?> _teams = List.generate(MAX_TEAM_COUNT, (index) => null);
  List<PokemonTeam?> get teams => _teams;

  Map<String, dynamic> toJson() {
    return {
      'teams': _teams
          .map((e) => e?.toJson())
          .toList(),
    };
  }

  Future<PokemonTeam> insert(int index, PokemonTeam team) async {
    try {
      final newTeam = team.copyWith(id: index);
      _teams[index] = newTeam;
      return newTeam;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> replace(int index, PokemonTeam team) async {
    // final index = _teams.indexOrNullWhere((t) => t?.id == team.id);
    // if (index == null) {
    //   // TODO: improvement
    //   throw Exception();
    // }
    _teams[index] = team;
  }

}
