import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MyDateTimeValueAccessor extends ControlValueAccessor<DateTime, String> {
  MyDateTimeValueAccessor(this.formatType);

  final DateFormatType formatType;

  @override
  String modelToViewValue(DateTime? modelValue) {
    if (modelValue == null) {
      return '';
    }
    return MyFormatter.date(modelValue, type: formatType);
  }

  @override
  DateTime? viewToModelValue(String? viewValue) {
    return MyTimezone.tryParseZero(viewValue);
  }
}