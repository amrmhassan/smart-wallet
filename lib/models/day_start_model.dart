//
//* this will be used in calculating the start date

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class DayStartModel extends TimeOfDay {
  const DayStartModel({required int hour, required int minute})
      : super(hour: hour, minute: minute);

  String numToString(int num) {
    if (num < 10) {
      return '0$num';
    } else {
      return '$num';
    }
  }

  @override
  String toString() {
    return '${numToString(hourOfPeriod)}:${numToString(minute)} ${period.name.toUpperCase()}';
  }
}

enum HoursPeriods { am, pm }
