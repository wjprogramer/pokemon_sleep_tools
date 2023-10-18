import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

class TeamViewModel extends ChangeNotifier {
  TeamViewModel();

  PokemonTeamRepository get _teamRepo => getIt();

  List<PokemonTeam?> _teams = [];
  List<PokemonTeam?> get teams => _teams;

  Future<PokemonTeam> createTeam(CreatePokemonTeamPayload payload) async {
    final tmpTeam = PokemonTeam(
      id: payload.index,
      name: payload.name,
      profileIdList: payload.profileIdList,
      comment: payload.comment,
      tags: [],
    );
    final res = await _teamRepo.create(payload.index, tmpTeam);
    _teams = await _teamRepo.findAll();
    notifyListeners();
    return res;
  }

  Future<PokemonTeam> updateTeam(int index, PokemonTeam pokemonTeam) async {
    await _teamRepo.update(index, pokemonTeam);
    _teams = await _teamRepo.findAll();
    notifyListeners();
    return pokemonTeam;
  }

  Future<List<PokemonTeam?>> loadTeams() async {
    _teams = await _teamRepo.findAll();
    notifyListeners();
    return _teams;
  }

}