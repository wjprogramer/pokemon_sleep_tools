import 'dart:collection';

import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FruitValueAccessor extends ControlValueAccessor<Fruit, String> {
  FruitValueAccessor();

  /// name to instance
  final _cache = ListQueue<Fruit>(3);

  @override
  String modelToViewValue(Fruit? modelValue) {
    if (modelValue == null) {
      return '';
    }
    _cache.add(modelValue);
    return modelValue.name;
  }

  @override
  Fruit? viewToModelValue(String? viewValue) {
    final trimmedViewValue = viewValue?.trim();
    if (trimmedViewValue == null || trimmedViewValue.isEmpty) {
      return null;
    }

    return _cache
        .lastWhere((element) => element.name == trimmedViewValue);
  }
}