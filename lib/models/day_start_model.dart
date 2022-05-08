//
//* this will be used in calculating the start date

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/models_properties_constants.dart';

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

  Map<String, String> toJSON() {
    return {
      dayStartHoursString: hour.toString(),
      dayStartMinutesString: minute.toString(),
    };
  }

  static DayStartModel fromJSON(Map<String, dynamic> dayStartJSON) {
    return DayStartModel(
      hour: int.parse(dayStartJSON[dayStartHoursString] as String),
      minute: int.parse(dayStartJSON[dayStartMinutesString] as String),
    );
  }
}

enum HoursPeriods { am, pm }
