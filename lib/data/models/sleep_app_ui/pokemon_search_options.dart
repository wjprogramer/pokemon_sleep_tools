import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonSearchOptions implements BaseSearchOptions {
  PokemonSearchOptions({
    String keyword = '',
    Map<Fruit, bool>? fruitOf,
    Set<MainSkill>? mainSkillOf,
    Set<MainSkill>? subSkillOf,
    Set<Ingredient>? ingredientOf,
  }) : _keyword = keyword,
  fruitOf = fruitOf ?? {},
  mainSkillOf = mainSkillOf ?? {},
  subSkillOf = subSkillOf ?? {},
  ingredientOf = ingredientOf ?? {};

  String _keyword = '';
  String get keyword => _keyword;
  set keyword(String v) {
    // TODO:
    _keyword = v;
  }

  Map<Fruit, bool> fruitOf;
  Set<MainSkill> mainSkillOf;
  Set<MainSkill> subSkillOf;
  Set<Ingredient> ingredientOf;

  @override
  PokemonSearchOptions clone() {
    return PokemonSearchOptions(
      keyword: keyword,
      fruitOf: fruitOf,
      mainSkillOf: mainSkillOf,
      subSkillOf: subSkillOf,
      ingredientOf: ingredientOf,
    );
  }

  @override
  bool isEmptyOptions() {
    return keyword.trim().isEmpty &&
        (fruitOf.isEmpty || fruitOf.entries.every((e) => !e.value)) &&
        mainSkillOf.isEmpty &&
        subSkillOf.isEmpty &&
        ingredientOf.isEmpty;
  }

  @override
  void clear() {
    keyword = '';
    fruitOf.clear();
    mainSkillOf.clear();
    subSkillOf.clear();
    ingredientOf.clear();
  }

  setKeywordWithoutListener() {

  }

}