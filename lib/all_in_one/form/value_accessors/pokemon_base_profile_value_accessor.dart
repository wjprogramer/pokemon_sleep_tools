import 'dart:collection';

import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PokemonBasicProfileValueAccessor extends ControlValueAccessor<PokemonBasicProfile, String> {
  PokemonBasicProfileValueAccessor();

  /// name to instance
  final _cache = ListQueue<PokemonBasicProfile>(3);

  @override
  String modelToViewValue(PokemonBasicProfile? modelValue) {
    if (modelValue == null) {
      return '';
    }
    _cache.add(modelValue);
    return modelValue.nameI18nKey;
  }

  @override
  PokemonBasicProfile? viewToModelValue(String? viewValue) {
    final trimmedViewValue = viewValue?.trim();
    if (trimmedViewValue == null || trimmedViewValue.isEmpty) {
      return null;
    }

    return _cache
        .lastWhere((element) => element.nameI18nKey == trimmedViewValue);
  }
}