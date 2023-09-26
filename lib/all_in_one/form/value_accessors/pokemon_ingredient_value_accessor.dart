import 'dart:collection';

import 'package:pokemon_sleep_tools/data/models/common/common.dart';
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
    return modelValue.name;
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