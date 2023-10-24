import 'package:pokemon_sleep_tools/data/models/sleep/ingredient.dart';

class IngredientChain {
  const IngredientChain(this.id, this.ingredientOptions2, this.ingredientOptions3);

  final int id;
  final List<(Ingredient, int)> ingredientOptions2;
  final List<(Ingredient, int)> ingredientOptions3;
}