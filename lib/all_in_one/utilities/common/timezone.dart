class MyTimezone {
  MyTimezone._();

  static late Duration _offset;

  static void init() {
    _offset = DateTime.now().timeZoneOffset;
  }

  static DateTime get now {
    return DateTime.now().add(_offset);
  }

}

extension DateTimeX on DateTime {
  DateTime toLocal() {
    return add(MyTimezone._offset);
  }

  DateTime toUTC() {
    return subtract(MyTimezone._offset);
  }
}