import 'package:intl/intl.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';

class Display {
  Display._();

  static String get placeHolder => 't_none'.xTr;

  // https://stackoverflow.com/questions/14865568/currency-format-in-dart
  static final _numDoubleFormat = NumberFormat("#,##0.00", "en_US");

  static final _numIntFormat = NumberFormat("#,##0", "en_US");

  static String text(dynamic v) {
    if (v == null) {
      return placeHolder;
    }
    if (v is String) {
      return v;
    }
    return '';
  }

  static String numInt(num value) {
    return _numIntFormat.format(value.toInt());
  }

  static String date(DateTime? date) {
    if (date == null) {
      return '----/--/--';
    }
    return DateFormat('yyyy/MM/dd').format(date);
  }
}