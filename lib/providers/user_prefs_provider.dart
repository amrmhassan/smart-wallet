// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/shared_pref_constants.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/models/day_start_model.dart';
import 'package:smart_wallet/models/profile_model.dart';

class UserPrefsProvider extends ChangeNotifier {
  Themes userTheme = Themes.dark;
  DayStartModel dayStart = DayStartModel(hour: 6, minute: 0);
  String _activatedProfileId = '';

  //? getting the active profile id
  String get activatedProfileId {
    return _activatedProfileId;
  }

  void setUserTheme(Themes newTheme) {
    userTheme = newTheme;
    notifyListeners();
  }

  void setActiveProfile(String profileId) {
    _activatedProfileId = profileId;
    notifyListeners();
  }

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

  Future<void> fetchAndSetDayStart() async {
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

  //? setting the active profile id
  Future<void> setActivatedProfile(
      String id,
      Future<void> Function(String activatedProfileId)
          editLastActivatedForProfile,
      [BuildContext? context]) async {
    try {
      await SharedPrefHelper.setString(kActivatedProfileIdKey, id);

      _activatedProfileId = id;

      notifyListeners();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }

    //* edit the lastActivated property in the profile
    // add that code to the first created profile
    return editLastActivatedForProfile(id);
  }

  //? getting the active profile id from the shared preferences
  Future<void> fetchAndUpdateActivatedProfileId(
    List<ProfileModel> profiles,
    Future<void> Function(String activatedProfileId)
        editLastActivatedForProfile,
  ) async {
    String activatedId;

    try {
      String? savedActivatedId =
          await SharedPrefHelper.getString(kActivatedProfileIdKey);
      if (savedActivatedId == null) {
        activatedId = profiles[0].id;
        await setActivatedProfile(activatedId, editLastActivatedForProfile);
      } else {
        activatedId = savedActivatedId;
      }
      _activatedProfileId = activatedId;
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }
}
