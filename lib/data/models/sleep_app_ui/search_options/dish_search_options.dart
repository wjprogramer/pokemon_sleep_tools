import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class DishSearchOptions implements BaseSearchOptions {
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

  @override
  DishSearchOptions clone() {
    return DishSearchOptions(
      dishTypes: dishTypes,
      potCapacity: potCapacity,
      ingredientOf: ingredientOf,
    );
  }

  @override
  bool isEmptyOptions() {
    return dishTypes.isEmpty &&
        potCapacity == null &&
        ingredientOf.isEmpty;
  }

  @override
  void clear() {
    dishTypes.clear();
    ingredientOf.clear();
    potCapacity = null;
  }

  @override
  void dispose() {
  }

  List<Dish> filter(List<Dish> dishes) {
    Iterable<Dish> results = [...dishes];
    if (isEmptyOptions()) {
      return results.toList();
    }

    if (potCapacity != null) {
      results = results.where((dish) => dish.capacity <= potCapacity!);
    }
    if (dishTypes.isNotEmpty) {
      results = results.where((dish) => dishTypes.contains(dish.dishType));
    }
    if (ingredientOf.isNotEmpty) {
      results = results.where((dish) {
        // 部分符合
        // final ingredients = dish.getIngredients().map((e) => e.$1);
        // return ingredients.any((e) => ingredientOf.contains(e));
        // 完全符合
        final ingredients = dish.getIngredients().map((e) => e.$1).toList();
        ingredients.removeWhere((e) => ingredientOf.contains(e));
        return ingredients.isEmpty;
      });
    }

    return results.toList();
  }


}
