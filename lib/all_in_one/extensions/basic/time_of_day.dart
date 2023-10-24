import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  // TimeOfDay addHour(int hour) {
  //   return this.replacing(hour: this.hour + hour, minute: this.minute);
  // }

  TimeOfDay add({int hour = 0, int minute = 0}) {
    var newHour = this.hour + hour;
    var newMinute = this.minute + minute;

    newHour += (newMinute ~/ 60) % 24;
    newMinute = newMinute % 60;

    return replacing(hour: newHour % 24, minute: newMinute);
  }

  int toMinutes() {
    return hour * 60 + minute;
  }
}
