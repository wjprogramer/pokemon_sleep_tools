import 'dart:collection';

import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PokemonCharacterValueAccessor extends ControlValueAccessor<PokemonCharacter, String> {
  PokemonCharacterValueAccessor();

  /// name to instance
  final _cache = ListQueue<PokemonCharacter>(3);

  @override
  String modelToViewValue(PokemonCharacter? modelValue) {
    if (modelValue == null) {
      return '';
    }
    _cache.add(modelValue);
    return modelValue.name;
  }

  @override
  PokemonCharacter? viewToModelValue(String? viewValue) {
    final trimmedViewValue = viewValue?.trim();
    if (trimmedViewValue == null || trimmedViewValue.isEmpty) {
      return null;
    }

    return _cache
        .lastWhere((element) => element.name == trimmedViewValue);
  }
}