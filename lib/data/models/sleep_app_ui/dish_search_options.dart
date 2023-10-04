import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

// TODO: 料理 => 食譜一覽
// 篩選：容量、食材、料理種類

class DishSearchOptions {
  DishSearchOptions({
    List<DishType>? dishTypes,
    this.potCapacity,
    Set<Ingredient>? ingredientOf,
  }): dishTypes = dishTypes ?? [],
        ingredientOf = ingredientOf ?? {};

  final List<DishType> dishTypes;

  /// [POT_CAPACITIES_OPTIONS]
  int? potCapacity;

  Set<Ingredient> ingredientOf;

  DishSearchOptions clone() {
    return DishSearchOptions(
      dishTypes: dishTypes,
      potCapacity: potCapacity,
      ingredientOf: ingredientOf,
    );
  }

  bool isEmptyOptions() {
    return dishTypes.isEmpty &&
        potCapacity == null &&
        ingredientOf.isEmpty;
  }

  void clear() {
    dishTypes.clear();
    ingredientOf.clear();
    potCapacity = null;
  }


}
