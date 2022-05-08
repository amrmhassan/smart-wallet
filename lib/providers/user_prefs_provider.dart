// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/models/day_start_model.dart';

class UserPrefsProvider extends ChangeNotifier {
  Themes userTheme = Themes.dark;
  DayStartModel dayStart = DayStartModel(hour: 6, minute: 0);
  String? activeProfile;

  void setUserTheme(Themes newTheme) {
    userTheme = newTheme;
    notifyListeners();
  }

  void setActiveProfile(String profileId) {
    activeProfile = profileId;
    notifyListeners();
  }

  void setDayStart(DayStartModel newDayStart) {
    dayStart = newDayStart;
    notifyListeners();
  }
}
