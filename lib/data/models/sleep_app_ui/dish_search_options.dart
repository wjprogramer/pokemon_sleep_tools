import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

// TODO: 料理 => 食譜一覽
// 篩選：容量、食材、料理種類

class DishSearchOptions {
  DishSearchOptions({
    List<DishType>? dishTypes,
    this.potCapacity,
    Map<Ingredient, bool>? ingredientOf,
  }): dishTypes = dishTypes ?? [],
        ingredientOf = ingredientOf ?? {};

  final List<DishType> dishTypes;

  /// [POT_CAPACITIES_OPTIONS]
  final int? potCapacity;

  Map<Ingredient, bool> ingredientOf;

  DishSearchOptions clone() {
    return DishSearchOptions(
      dishTypes: dishTypes,
      potCapacity: potCapacity,
      ingredientOf: ingredientOf,
    );
  }

  bool isEmptyOptions() {
    return dishTypes.isEmpty &&
        potCapacity != null &&
        (ingredientOf.isEmpty || ingredientOf.entries.every((e) => !e.value));
  }

}
