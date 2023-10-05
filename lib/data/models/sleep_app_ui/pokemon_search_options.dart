import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonSearchOptions {
  PokemonSearchOptions({
    this.keyword = '',
    Map<Fruit, bool>? fruitOf,
    Set<MainSkill>? mainSkillOf,
    Set<MainSkill>? subSkillOf,
    Set<Ingredient>? ingredientOf,
  }):
  fruitOf = fruitOf ?? {},
  mainSkillOf = mainSkillOf ?? {},
  subSkillOf = subSkillOf ?? {},
  ingredientOf = ingredientOf ?? {};

  String keyword;
  Map<Fruit, bool> fruitOf;
  Set<MainSkill> mainSkillOf;
  Set<MainSkill> subSkillOf;
  Set<Ingredient> ingredientOf;

  PokemonSearchOptions clone() {
    return PokemonSearchOptions(
      keyword: keyword,
      fruitOf: fruitOf,
      mainSkillOf: mainSkillOf,
      subSkillOf: subSkillOf,
      ingredientOf: ingredientOf,
    );
  }

  bool isEmptyOptions() {
    return keyword.trim().isEmpty &&
        (fruitOf.isEmpty || fruitOf.entries.every((e) => !e.value)) &&
        (fruitOf.isEmpty || fruitOf.entries.every((e) => !e.value)) &&
        mainSkillOf.isEmpty &&
        subSkillOf.isEmpty &&
        ingredientOf.isEmpty;
  }

  void clear() {
    keyword = '';
    fruitOf.clear();
    mainSkillOf.clear();
    subSkillOf.clear();
    ingredientOf.clear();
  }

}