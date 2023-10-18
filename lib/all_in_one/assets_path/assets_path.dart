import 'package:pokemon_sleep_tools/data/models/models.dart';

class AssetsPath {
  AssetsPath._();

  static const _prefix = 'assets/debug/images';

  static String pokemonPortrait(int boxNo) {
    return '$_prefix/pokemon/portrait/$boxNo.png';
  }

  static String pokemonIcon(int boxNo) {
    return '$_prefix/pokemon/icons/$boxNo.png';
  }

  static pokemonType(PokemonType pokemonType) {
    return '$_prefix/type/${pokemonType.id}.png';
  }

  static mealIcon(int dishId) {
    return '$_prefix/meal/icons/$dishId.png';
  }

  static mealPortrait(int dishId) {
    return '$_prefix/meal/portrait/$dishId.png';
  }

  static fruit(Fruit fruit) {
    return '$_prefix/berry/${fruit.id}.png';
  }

  static ingredient(Ingredient ingredient) {
    return '$_prefix/ingredient/${ingredient.id}.png';
  }

  static field(PokemonField field) {
    return '$_prefix/field/${field.id}.png';
  }

}