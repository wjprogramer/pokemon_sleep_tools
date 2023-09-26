import 'package:pokemon_sleep_tools/all_in_one/form/validation/validators/iterable_validator.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// ref [Validators]
class MyValidators {
  MyValidators._();

  static Validator<dynamic> iterableLength(int value) => IterableLengthValidator(value);


}

