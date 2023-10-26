import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images_private/ingredient_image.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef FieldBuilder<T> = Function(BuildContext context, FormControl<T> field);

typedef WrapFieldBuilder<T> = Function(BuildContext context, Widget fieldWidget);

class ReactiveMyTextField<T> extends StatelessWidget {
  const ReactiveMyTextField({
    super.key,
    required this.formControl,
    this.wrapFieldBuilder,
    this.fieldWidget,
    this.label,
    this.validationMessages,
    this.decoration = const InputDecoration(),
    this.valueAccessor,
  });

  final FormControl<T> formControl;
  final WrapFieldBuilder<T>? wrapFieldBuilder;
  final Widget? fieldWidget;
  final String? label;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final InputDecoration decoration;
  final ControlValueAccessor<T, String>? valueAccessor;

  static List<Widget> labelField({
    required Widget? label,
    required Widget field,
  }) {
    return [
      if (label != null)
        label,
      field,
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget field = fieldWidget ?? _buildField();

    if (wrapFieldBuilder != null) {
      field = wrapFieldBuilder!(context, field);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: labelField(
        label: label == null ? null : Text(label!),
        field: field,
      ),
    );
  }

  Widget _buildField() {
    final newDecoration = decoration.copyWith(
      prefixIcon: _getPrefixIcon(),
    );

    return ReactiveTextField(
      formControl: formControl,
      validationMessages: validationMessages,
      valueAccessor: valueAccessor ?? _getValueAccessor(),
      keyboardType: _getKeyboardType(),
      inputFormatters: _getInputFormatters(),
      decoration: newDecoration,
    );
  }

  Widget? _getPrefixIcon() {
    if (MyEnv.USE_DEBUG_IMAGE) {
      if (formControl is FormControl<Ingredient> && formControl.value != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IngredientImage(
            ingredient: formControl.value as Ingredient,
            width: 24,
            disableTooltip: true,
          ),
        );
      }
    }
    return null;
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

  TextInputType? _getKeyboardType() {
    if (formControl is FormControl<num>) {
      return const TextInputType.numberWithOptions(signed: true);
    }
    return null;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (formControl is FormControl<int>) {
      return [
        FilteringTextInputFormatter.digitsOnly,
      ];
    }
    return null;
  }

}
