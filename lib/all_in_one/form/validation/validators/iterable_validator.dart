import 'package:pokemon_sleep_tools/all_in_one/form/validation/validation.dart';
import 'package:reactive_forms/reactive_forms.dart';

class IterableLengthValidator extends Validator<dynamic> {
  const IterableLengthValidator(this.specifyLength): super();

  final int specifyLength;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    if (control.value == null || control.value is Iterable) {
      return null;
    }

    if ((control.value as Iterable).length == specifyLength) {
      return null;
    }

    return {
      MyValidationMessage.iterableLength: <String, dynamic>{
        'length': specifyLength,
        'actual': control.value,
        'actualLength': (control.value as Iterable).length,
      },
    };
  }

}