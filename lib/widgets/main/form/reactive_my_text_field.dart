import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef FieldBuilder<T> = Function(BuildContext context, FormControl<T> field);

typedef WrapFieldBuilder<T> = Function(BuildContext context, Widget fieldWidget);

class ReactiveMyTextField<T> extends StatelessWidget {
  const ReactiveMyTextField({
    super.key,
    required this.formControl,
    this.wrapFieldBuilder,
    this.label,
    this.validationMessages,
  });

  final FormControl<T> formControl;
  final WrapFieldBuilder<T>? wrapFieldBuilder;
  final String? label;
  final Map<String, ValidationMessageFunction>? validationMessages;

  @override
  Widget build(BuildContext context) {
    Widget field = _buildField();

    if (wrapFieldBuilder != null) {
      field = wrapFieldBuilder!(context, field);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Text(label!),
        field,
      ],
    );
  }

  Widget _buildField() {
    return ReactiveTextField(
      formControl: formControl,
      validationMessages: validationMessages,
      valueAccessor: _getValueAccessor(),
    );
  }

  ControlValueAccessor<T, String>? _getValueAccessor() {
    if (formControl is FormControl<Fruit>) {
      return FruitValueAccessor() as ControlValueAccessor<T, String>;
    }
    if (formControl is FormControl<PokemonBasicProfile>) {
      return PokemonBasicProfileValueAccessor() as ControlValueAccessor<T, String>;
    }
    if (formControl is FormControl<PokemonCharacter>) {
      return PokemonCharacterValueAccessor() as ControlValueAccessor<T, String>;
    }
    if (formControl is FormControl<Ingredient>) {
      return IngredientValueAccessor() as ControlValueAccessor<T, String>;
    }
    return null;
  }

}
