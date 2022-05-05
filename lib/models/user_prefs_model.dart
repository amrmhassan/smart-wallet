// ignore_for_file: prefer_const_constructors

import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/models/day_start_model.dart';

class UserPrefsModel {
  final Themes activeTheme;
  final String? activeProfileId;
  late DayStartModel defaultPeriod;

  UserPrefsModel({
    this.activeTheme = Themes.dark,
    this.activeProfileId,
  }) {
    defaultPeriod = DayStartModel(hours: 0, minutes: 0);
  }
}
