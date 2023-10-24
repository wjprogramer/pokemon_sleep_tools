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

  /// [fieldToBasicProfileIdSet]
  ///
  /// - is for [fieldOf] searching
  /// - map [PokemonField] to [PokemonBasicProfile.id] set
  List<PokemonProfile> filterProfiles(List<PokemonProfile> profiles, {
    required Map<PokemonField, Set<int>> fieldToBasicProfileIdSet,
  }) {
    Iterable<PokemonProfile> results = [...profiles];
    if (isEmptyOptions()) {
      return results.toList();
    }

    results = results
        .where((profile) => _basicProfileWhere(profile.basicProfile, fieldToBasicProfileIdSet));

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

    final newKeyword = keyword.trim().toLowerCase();
    if (newKeyword.isNotEmpty) {
      results = results.where((p) {
        return _basicProfileKeywordWhere(p.basicProfile, newKeyword) ||
            (p.customName?.toLowerCase() ?? '').contains(newKeyword) ||
            (p.customNote?.toLowerCase() ?? '').contains(newKeyword);
      });
    }

    return results.toList();
  }

  List<PokemonBasicProfile> filterBasicProfiles(List<PokemonBasicProfile> profiles, {
    required Map<PokemonField, Set<int>> fieldToBasicProfileIdSet,
  }) {
    Iterable<PokemonBasicProfile> results = [...profiles];
    if (isEmptyOptions()) {
      return results.toList();
    }

    // ingredient
    void filterIngredients(Set<Ingredient> ingredientSetParam, Iterable<Ingredient> Function(PokemonBasicProfile profile) gettingIngredients) {
      if (ingredientSetParam.isEmpty) {
        return;
      }
      results = results.where((p) {
        for (final currIngredient in gettingIngredients(p)) {
          if (ingredientSetParam.contains(currIngredient)) {
            return true;
          }
        }
        return false;
      });
    }

    filterIngredients(ingredientOfLv1, (p) => [ p.ingredient1 ]);
    filterIngredients(ingredientOfLv30, (p) => p.ingredientOptions2.map((e) => e.$1));
    filterIngredients(ingredientOfLv60, (p) => p.ingredientOptions3.map((e) => e.$1));

    if (ingredientOf.isNotEmpty) {
      filterIngredients(ingredientOf, (p) => {
        p.ingredient1,
        ...p.ingredientOptions2.map((e) => e.$1),
        ...p.ingredientOptions3.map((e) => e.$1),
      });
    }

    // keyword
    final newKeyword = keyword.trim();
    if (newKeyword.isNotEmpty) {
      results = results.where((p) {
        return _basicProfileKeywordWhere(p, newKeyword);
      });
    }

    return results
        .where((e) => _basicProfileWhere(e, fieldToBasicProfileIdSet))
        .toList();
  }

  bool _basicProfileWhere(PokemonBasicProfile basicProfile, Map<PokemonField, Set<int>> fieldToBasicProfileIdSet) {
    if (fruitOf.isNotEmpty &&
        !fruitOf.contains(basicProfile.fruit)) {
      return false;
    }

    if (typeof.isNotEmpty &&
        !typeof.contains(basicProfile.pokemonType)) {
      return false;
    }

    if (mainSkillOf.isNotEmpty &&
        !mainSkillOf.contains(basicProfile.mainSkill)) {
      return false;
    }

    if (sleepTypeOf.isNotEmpty &&
        !sleepTypeOf.contains(basicProfile.sleepType)) {
      return false;
    }

    if (specialtyOf.isNotEmpty &&
        !specialtyOf.contains(basicProfile.specialty)) {
      return false;
    }

    if (currEvolutionStageOf.isNotEmpty &&
        !currEvolutionStageOf.contains(basicProfile.currentEvolutionStage)) {
      return false;
    }

    if (maxEvolutionStageOf.isNotEmpty &&
        !maxEvolutionStageOf.contains(basicProfile.evolutionMaxCount)) {
      return false;
    }

    if (fieldOf.isNotEmpty) {
      var found = false;
      for (final field in fieldOf) {
        final idSet = fieldToBasicProfileIdSet[field];
        if (idSet == null) {
          continue;
        }
        if (idSet.contains(basicProfile.id)) {
          found = true;
          break;
        }
      }
      if (!found) {
        return false;
      }
    }

    return true;
  }

  bool _basicProfileKeywordWhere(PokemonBasicProfile basicProfile, String keyword) {
    return basicProfile.nameI18nKey.xTr.toLowerCase().contains(keyword);
  }


}