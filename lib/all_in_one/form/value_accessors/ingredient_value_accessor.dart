import 'dart:collection';

import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IngredientValueAccessor extends ControlValueAccessor<Ingredient, String> {
  IngredientValueAccessor();

  /// name to instance
  final _cache = ListQueue<Ingredient>(3);

  @override
  String modelToViewValue(Ingredient? modelValue) {
    if (modelValue == null) {
      return '';
    }
    _cache.add(modelValue);
    return modelValue.nameI18nKey.xTr;
  }

  @override
  Ingredient? viewToModelValue(String? viewValue) {
    final trimmedViewValue = viewValue?.trim();
    if (trimmedViewValue == null || trimmedViewValue.isEmpty) {
      return null;
    }

    return _cache
        .lastWhere((element) => element.name == trimmedViewValue);
  }
}