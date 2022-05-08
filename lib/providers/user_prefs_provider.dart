// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/shared_pref_constants.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/models/day_start_model.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';

//? this provider is responsible for collecting the user settings to update them to the firebase
class UserPrefsProvider extends ChangeNotifier {
  Themes userTheme = Themes.dark;
  DayStartModel dayStart = DayStartModel(hour: 6, minute: 0);
  String activeProfile = '';
  bool userPrefsNeedSyncing = true;

  //? setting the need syncing
  Future<void> setUserPrefsNeedSyncing(bool value) async {
    await SharedPrefHelper.setBool(kUserPrefsNeedSyncingKey, value);
    userPrefsNeedSyncing = value;
    notifyListeners();
  }

  //? fetching and setting the user prefs need syncing
  Future<void> fetchAndUpdateUserPrefsNeedSyncing() async {
    bool? value = await SharedPrefHelper.getBool(kUserPrefsNeedSyncingKey);
    if (value == null) {
      await setUserPrefsNeedSyncing(true);
    } else {
      userPrefsNeedSyncing = value;
    }

    notifyListeners();
  }

//? for converting all user data to a string that will be stored in firestore
  String getUserPrefs(
    String activeProfileId,
    Themes activeUserTheme,
  ) {
    String dayStartModelString = json.encode(dayStart.toJSON());
    Map<String, String> data = {
      'activeProfileId': activeProfileId,
      'activeUserTheme': activeUserTheme.name,
      'dayStart': dayStartModelString,
    };
    String dataString = json.encode(data);
    return dataString;
  }

//? for setting user data after getting them from the firestore
  Future<void> setUserPrefsFromString(
    String userPrefs,
    Future<void> Function(String id) setActivatedProfile,
    Future<void> Function(Themes theme) setTheme,
  ) async {
    Map<String, dynamic> dataJSON = json.decode(userPrefs);
    String activeProfileId = dataJSON['activeProfileId'] as String;
    Themes activeUserTheme =
        stringToThemes(dataJSON['activeUserTheme'] as String);
    Map<String, dynamic> dayStartJSON =
        json.decode(dataJSON['dayStart'] as String);
    DayStartModel dayStartModel = DayStartModel.fromJSON(dayStartJSON);

    await setActivatedProfile(activeProfileId);
    await setTheme(activeUserTheme);
    await setDayStart(dayStartModel);
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
