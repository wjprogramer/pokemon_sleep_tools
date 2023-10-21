import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/all_in_one/utilities/common/formatter.dart';

class Display {
  Display._();

  static String get placeHolder => 't_none'.xTr;

  // https://stackoverflow.com/questions/14865568/currency-format-in-dart
  // static final _numDoubleFormat = NumberFormat("#,##0.00", "en_US");
  static final _numDoubleFormat = NumberFormat("#,###.##", "en_US");

  static final _numIntFormat = NumberFormat("#,##0", "en_US");

  static String text(dynamic v, { String? emptyText }) {
    if (v == null) {
      return emptyText ?? placeHolder;
    }
    if (v is String) {
      return v;
    }
    return '';
  }

  static String numInt(num value) {
    return _numIntFormat.format(value.toInt());
  }

  static String numDouble(num value) {
    return _numDoubleFormat.format(value);
  }

  /// TODO: timezone
  static String date(DateTime? date) {
    return MyFormatter.date(date);
  }

  static String seconds(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds.remainder(60);

    // TODO: i18n
    final locale = SupportLang.zhTW.toLocale();
    // final locale = Localizations.localeOf(context);
    final intl = DateFormat('HH:mm:ss', locale.toLanguageTag());
    final timeString = intl.format(DateTime(0, 0, 0, 0, minutes, remainingSeconds));

    return timeString;
  }
}