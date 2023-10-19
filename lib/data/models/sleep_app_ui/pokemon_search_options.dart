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
    Set<Ingredient>? ingredientOfLv1,
    Set<Ingredient>? ingredientOfLv30,
    Set<Ingredient>? ingredientOfLv60,
    Set<PokemonField>? fieldOf,
    Set<PokemonSpecialty>? specialtyOf,
    Set<SleepType>? sleepTypeOf,
    Set<int>? currEvolutionStageOf,
    Set<int>? maxEvolutionStageOf,
  }) :_keyword = keyword,
        fruitOf = fruitOf ?? {},
        typeof = typeof ?? {},
        mainSkillOf = mainSkillOf ?? {},
        subSkillOf = subSkillOf ?? {},
        ingredientOf = ingredientOf ?? {},
        ingredientOfLv1 = ingredientOfLv1 ?? {},
        ingredientOfLv30 = ingredientOfLv30 ?? {},
        ingredientOfLv60 = ingredientOfLv60 ?? {},
        fieldOf = fieldOf ?? {},
        specialtyOf = specialtyOf ?? {},
        sleepTypeOf = sleepTypeOf ?? {},
        currEvolutionStageOf = currEvolutionStageOf ?? {},
        maxEvolutionStageOf = maxEvolutionStageOf ?? {};

  /// 搜尋樹果
  Set<Fruit> fruitOf;
  /// 搜尋屬性
  Set<PokemonType> typeof;
  /// 搜尋主技能
  Set<MainSkill> mainSkillOf;
  /// 搜尋副技能
  Set<MainSkill> subSkillOf;
  /// 搜尋食材
  Set<Ingredient> ingredientOf;
  /// 只搜尋 1 等的食材
  Set<Ingredient> ingredientOfLv1;
  /// 只搜尋 30 等的食材
  Set<Ingredient> ingredientOfLv30;
  /// 只搜尋 60 等的食材
  Set<Ingredient> ingredientOfLv60;
  /// 可以在哪個島嶼上發現其睡姿
  Set<PokemonField> fieldOf = {};
  /// 搜尋專長
  Set<PokemonSpecialty> specialtyOf = {};
  /// 搜尋睡眠類型
  Set<SleepType> sleepTypeOf = {};
  /// 當前進化階段 (1, 2, 3)
  Set<int> currEvolutionStageOf = {};
  /// 最終進化階段 (1, 2, 3)
  Set<int> maxEvolutionStageOf = {};

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
      typeof: typeof,
      mainSkillOf: mainSkillOf,
      subSkillOf: subSkillOf,
      ingredientOf: ingredientOf,
      ingredientOfLv1: ingredientOfLv1,
      ingredientOfLv30: ingredientOfLv30,
      ingredientOfLv60: ingredientOfLv60,
      fieldOf: fieldOf,
      specialtyOf: specialtyOf,
      sleepTypeOf: sleepTypeOf,
      currEvolutionStageOf: currEvolutionStageOf,
      maxEvolutionStageOf: maxEvolutionStageOf,
    );
  }

  @override
  bool isEmptyOptions() {
    return !(keyword.trim().isNotEmpty ||
        fruitOf.isNotEmpty ||
        typeof.isNotEmpty ||
        mainSkillOf.isNotEmpty ||
        subSkillOf.isNotEmpty ||
        ingredientOf.isNotEmpty ||
        ingredientOfLv1.isNotEmpty ||
        ingredientOfLv30.isNotEmpty ||
        ingredientOfLv60.isNotEmpty ||
        fieldOf.isNotEmpty ||
        specialtyOf.isNotEmpty ||
        sleepTypeOf.isNotEmpty ||
        currEvolutionStageOf.isNotEmpty ||
        maxEvolutionStageOf.isNotEmpty
    );
  }

  @override
  void clear() {
    keyword = '';
    fruitOf.clear();
    typeof.clear();
    mainSkillOf.clear();
    subSkillOf.clear();
    ingredientOf.clear();
    ingredientOfLv1.clear();
    ingredientOfLv30.clear();
    ingredientOfLv60.clear();
    fieldOf.clear();
    specialtyOf.clear();
    sleepTypeOf.clear();
    currEvolutionStageOf.clear();
    maxEvolutionStageOf.clear();
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

    void filterIngredients(Set<Ingredient> ingredientSetParam, Function(PokemonProfile profile) gettingIngredients) {
      if (ingredientSetParam.isEmpty) {
        return;
      }
      results = results.where((p) {
        return ingredientSetParam.contains(gettingIngredients(p));
      });
    }

    filterIngredients(ingredientOfLv1, (p) => p.ingredient1);
    filterIngredients(ingredientOfLv30, (p) => p.ingredient2);
    filterIngredients(ingredientOfLv60, (p) => p.ingredient3);

    if (ingredientOf.isNotEmpty) {
      results = results.where((p) {
        return ingredientOf.contains(p.ingredient1) ||
            ingredientOf.contains(p.ingredient3) ||
            ingredientOf.contains(p.ingredient3);
      });
    }

    if (typeof.isNotEmpty) {
      results = results
          .where((p) => typeof.contains(p.basicProfile.pokemonType));
    }

    if (mainSkillOf.isNotEmpty) {
      results = results
          .where((p) => mainSkillOf.contains(p.basicProfile.mainSkill));
    }

    final newKeyword = keyword.trim();
    if (newKeyword.isNotEmpty) {
      results = results
          .where((p) => p.basicProfile.nameI18nKey.xTr.contains(newKeyword));
    }

    if (sleepTypeOf.isNotEmpty) {
      results = results
          .where((p) => sleepTypeOf.contains(p.basicProfile.sleepType));
    }

    if (specialtyOf.isNotEmpty) {
      results = results
          .where((p) => specialtyOf.contains(p.basicProfile.specialty));
    }

    return results.toList();
  }

  List<PokemonBasicProfile> filterBasicProfiles(List<PokemonBasicProfile> profiles) {
    return [];
  }

}