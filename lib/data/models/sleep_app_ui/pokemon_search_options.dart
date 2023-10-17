import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonSearchOptions implements BaseSearchOptions {
  PokemonSearchOptions({
    String keyword = '',
    Set<Fruit>? fruitOf,
    Set<PokemonType>? typeof,
    Set<MainSkill>? mainSkillOf,
    Set<MainSkill>? subSkillOf,
    Set<Ingredient>? ingredientOf,
  }) : _keyword = keyword,
    fruitOf = fruitOf ?? {},
    typeof = typeof ?? {},
    mainSkillOf = mainSkillOf ?? {},
    subSkillOf = subSkillOf ?? {},
    ingredientOf = ingredientOf ?? {};

  Set<Fruit> fruitOf;
  Set<PokemonType> typeof;
  Set<MainSkill> mainSkillOf;
  Set<MainSkill> subSkillOf;
  Set<Ingredient> ingredientOf;

  String _keyword = '';
  String get keyword => _keyword;
  /// Will trigger listeners
  set keyword(String v) {
    _keyword = v;
    for (final listener in _keywordListeners) {
      listener(v);
    }
  }

  final _keywordListeners = <ValueChanged<String>>[];

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
        fruitOf.isEmpty &&
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

  void setKeywordWithoutListen(String value) {
    _keyword = value;
  }

  void addKeywordListener(ValueChanged<String> listener) {
    _keywordListeners.add(listener);
  }

  void removeKeywordListener(ValueChanged<String> listener) {
    _keywordListeners.remove(listener);
  }

  @override
  void dispose() {
    _keywordListeners.clear();
  }

  List<PokemonProfile> filterProfiles(List<PokemonProfile> profiles) {
    Iterable<PokemonProfile> results = [...profiles];
    if (isEmptyOptions()) {
      return results.toList();
    }

    if (fruitOf.isNotEmpty) {
      results = results
          .where((p) => fruitOf.contains(p.basicProfile.fruit));
    }

    final newKeyword = keyword.trim();
    if (newKeyword.isNotEmpty) {
      results = results
          .where((p) => p.basicProfile.nameI18nKey.xTr.contains(newKeyword));
    }
    if (mainSkillOf.isNotEmpty) {
      results = results
          .where((p) => mainSkillOf.contains(p.basicProfile.mainSkill));
    }

    return results.toList();
  }

  filterBasicProfiles() {

  }

}