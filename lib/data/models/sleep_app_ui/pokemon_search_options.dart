import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonSearchOptions {
  PokemonSearchOptions({
    this.keyword = '',
    Map<Fruit, bool>? fruitOf,
    Map<MainSkill, bool>? mainSkillOf,
    Map<MainSkill, bool>? subSkillOf,
    Map<Ingredient, bool>? ingredientOf,
  }):
  fruitOf = fruitOf ?? {},
  mainSkillOf = mainSkillOf ?? {},
  subSkillOf = subSkillOf ?? {},
  ingredientOf = ingredientOf ?? {};

  String keyword;
  Map<Fruit, bool> fruitOf;
  Map<MainSkill, bool> mainSkillOf;
  Map<MainSkill, bool> subSkillOf;
  Map<Ingredient, bool> ingredientOf;

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
        (mainSkillOf.isEmpty || mainSkillOf.entries.every((e) => !e.value)) &&
        (subSkillOf.isEmpty || subSkillOf.entries.every((e) => !e.value)) &&
        (ingredientOf.isEmpty || ingredientOf.entries.every((e) => !e.value));
  }

}