import 'package:pokemon_sleep_tools/data/models/models.dart';

class AssetsPath {
  AssetsPath._();

  static const _prefix = 'assets/debug/images';

  static String _convertPokemonId(int boxNo, int basicProfileId) {
    return boxNo.toString();
  }

  static String pokemonPortrait(int boxNo) {
    final pId = _convertPokemonId(boxNo, -1);
    return '$_prefix/pokemon/portrait/$pId.png';
  }

  static String pokemonPortraitShiny(int boxNo, {
    int? basicProfileId,
  }) {
    final pId = _convertPokemonId(boxNo, basicProfileId ?? -1);
    return '$_prefix/pokemon/portrait/shiny/$pId.png';
  }

  static String pokemonIcon(int boxNo, {
    int? basicProfileId,
  }) {
    final pId = _convertPokemonId(boxNo, basicProfileId ?? -1);
    return '$_prefix/pokemon/icons/$pId.png';
  }

  static String pokemonSleepFace(int boxNo, int style, {
    int? basicProfileId,
  }) {
    final pId = _convertPokemonId(boxNo, basicProfileId ?? -1);
    final styleFolder = style == -1 ? 'onSnorlax' : style.toString();
    print('$_prefix/sleep/$styleFolder/$pId.png');
    return '$_prefix/sleep/$styleFolder/$pId.png';
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

  static mood(int value) {
    return '$_prefix/mood/$value.png';
  }

  static candy(int pokemonBoxNo) {
    pokemonBoxNo = switch (pokemonBoxNo) {
      447 => 448,
      _ => pokemonBoxNo,
    };
    return '$_prefix/candy/$pokemonBoxNo.png';
  }

  static gameItem(GameItem item) {
    return '$_prefix/item/${item.id}.png';
  }

  // region generic
  static String generic(String name) {
    return '$_prefix/generic/$name.png';
  }
  // endregion generic

}