import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';

class Display {
  Display._();

  static String get placeHolder => 't_none'.xTr;

  static String text(dynamic v) {
    if (v == null) {
      return placeHolder;
    }
    if (v is String) {
      return v;
    }
    return '';
  }
}