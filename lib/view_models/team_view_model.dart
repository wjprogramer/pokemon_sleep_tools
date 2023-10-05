import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

class TeamViewModel extends ChangeNotifier {
  TeamViewModel();

  PokemonTeamRepository get _teamRepo => getIt();

  List<PokemonTeam> _teams = [];
  List<PokemonTeam> get teams => _teams;

  Future<PokemonTeam> createTeam(CreatePokemonTeamPayload payload) async {
    final tmpTeam = PokemonTeam(
      id: -1,
      name: payload.name,
      profileIdList: payload.profileIdList,
    );
    final res = await _teamRepo.create(tmpTeam);
    _teams = await _teamRepo.findAll();
    notifyListeners();
    return res;
  }

  Future<PokemonTeam> updateTeam(PokemonTeam pokemonTeam) async {
    await _teamRepo.update(pokemonTeam);
    _teams = await _teamRepo.findAll();
    notifyListeners();
    return pokemonTeam;
  }

  Future<void> loadTeams() async {
    _teams = await _teamRepo.findAll();
    notifyListeners();
  }

}