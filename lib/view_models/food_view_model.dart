import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class FoodViewModel extends ChangeNotifier {
  FoodViewModel();

  FoodRepository get _repo => getIt();

  StoredFood? _stored;
  StoredFood get stored => _stored!;

  Future<void> init() async {
    _stored = await _repo.getStored();
    notifyListeners();
  }

  Future<void> updateIngredientAmount(Ingredient ingredient, int amount) async {
    final newStored = await _repo.updateIngredientAmount(ingredient, amount);
    _stored = newStored;
    notifyListeners();
  }

}
