import 'package:reactive_forms/reactive_forms.dart';

extension AbstractControlX<T> on AbstractControl<T> {
  String? getAnyErrorKey() {
    return errors.entries.firstOrNull?.key;
  }
}