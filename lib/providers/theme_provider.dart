import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/constants/shared_pref_constants.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';

import '../themes/theme_controller.dart';

class ThemeProvider extends ChangeNotifier {
  Themes currentTheme = Themes.dark;
  Future<void> setTheme(Themes theme) async {
    currentTheme = theme;
    await SharedPrefHelper.setString(kCurrentActiveTheme, currentTheme.name);
    notifyListeners();
  }

  Future<void> fetchAndSetActiveTheme() async {
    String themeName =
        await SharedPrefHelper.getString(kCurrentActiveTheme) as String;
    if (themeName == Themes.basic.name) {
      currentTheme = Themes.basic;
    } else if (themeName == Themes.dark.name) {
      currentTheme = Themes.dark;
    }
    notifyListeners();
  }

  Color getThemeColor(ThemeColors themeColor) {
    return colorThemes[currentTheme]![themeColor] as Color;
  }

  TextStyle getTextStyle(ThemeTextStyles themeTextStyles) {
    //? this is because i will have only one version of textStyle
    return textStylesThemes[currentTheme]![themeTextStyles] as TextStyle;
  }

  BoxShadow getBoxShadow(ThemeBoxShadow themeBoxShadow) {
    //? this is because i will have only one version of boxshadow
    return boxShadowThemes[currentTheme]![themeBoxShadow] as BoxShadow;
  }
}
