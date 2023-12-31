import 'dart:collection';

import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
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
    return modelValue.nameI18nKey.xTr;
  }

  @override
  PokemonCharacter? viewToModelValue(String? viewValue) {
    final trimmedViewValue = viewValue?.trim();
    if (trimmedViewValue == null || trimmedViewValue.isEmpty) {
      return null;
    }

    return _cache
        .lastWhere((element) => element.nameI18nKey.xTr == trimmedViewValue.xTr);
  }
}