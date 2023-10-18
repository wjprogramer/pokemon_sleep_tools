import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class FieldViewModel extends ChangeNotifier {
  FieldViewModel();

  MyLocalStorage get _localStorage => getIt();
  FieldRepository get _repo => getIt();

  StoredPokemonFields? _stored;

  Future<void> init() async {
    _stored = await _repo.getStored();
    notifyListeners();
  }

  Future<void> save(PokemonField field, {
    List<Fruit>? fruits,
  }) async {
    final newStored = await _repo.updateField(
      field, fruits: fruits,
    );
    _stored = newStored;
    notifyListeners();
  }

  StoredPokemonFieldItem getItem(PokemonField field) {
    return _stored!.fields[field] ?? StoredPokemonFieldItem.empty();
  }

}