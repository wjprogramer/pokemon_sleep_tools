import 'package:intl/intl.dart';

enum DateFormatType {
  date('yyyy/MM/dd', '----/--/--'),
  time('HH:mm:ss', '--:--:--'),
  dateTime('yyyy/MM/dd HH:mm:ss', '----/--/-- --:--:--'),
  /// For file name
  fileDateTime('yyyy-MM-dd_HH-mm-ss', '0000-00-00_00-00-00');

  const DateFormatType(this.pattern, this.placeholder);

  final String pattern;

  final String placeholder;
}

class MyFormatter {
  MyFormatter._();

  static String date(DateTime? date, {
    DateFormatType? type,
  }) {
    final newType = type ?? DateFormatType.date;
    if (date == null) {
      return newType.placeholder;
    }
    return DateFormat(newType.pattern).format(date);
  }

  static String dateTime(DateTime? date, {
    DateFormatType? type,
  }) {
    final newType = type ?? DateFormatType.date;
    if (date == null) {
      return newType.placeholder;
    }
    return DateFormat(newType.pattern).format(date);
  }

}