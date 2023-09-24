import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel();

  PokemonProfileRepository get _profileRepo => getIt();

  Future<void> create() async {
    _profileRepo.create();
    notifyListeners();
  }

}