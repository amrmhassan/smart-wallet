// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/shared_pref_constants.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/models/day_start_model.dart';

//? this provider is responsible for collecting the user settings to update them to the firebase
class UserPrefsProvider extends ChangeNotifier {
  Themes userTheme = Themes.dark;
  DayStartModel dayStart = DayStartModel(hour: 6, minute: 0);
  String activeProfile = '';

  Future<void> setDayStart(DayStartModel newDayStart) async {
    dayStart = newDayStart;
    //* save it to the shared preferences
    await SharedPrefHelper.setString(
      kDayStartKey,
      json.encode(
        dayStart.toJSON(),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetUserSettings() async {
    //? for the dayStart
    try {
      String? dayStartString = await SharedPrefHelper.getString(kDayStartKey);
      if (dayStartString != null) {
        var dayStartJSON = json.decode(dayStartString);
        DayStartModel fetchedDayStartModel =
            DayStartModel.fromJSON(dayStartJSON);
        dayStart = fetchedDayStartModel;
      }
      notifyListeners();
    } catch (error) {
      CustomError.log(
        error: error,
        rethrowError: true,
      );
    }
  }
}
