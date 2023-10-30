import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class FoodRepository implements MyInjectable {
  MyLocalStorage get _localStorage => getIt();

  Future<StoredFood> getStored() async {
    return await _localStorage.readFood();
  }

  Future<StoredFood> updateIngredientAmount(Ingredient ingredient, int amount) async {
    final newStored = await _localStorage.readWrite<StoredFood>(StoredFood, (stored) async {
      await stored.updateIngredientAmount(
        ingredient, amount,
      );
      return stored;
    });
    return newStored;
  }

}