import 'package:flutter/material.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/themes/dark_theme/dark_theme.dart';
import 'package:smart_wallet/themes/default_theme/default_theme.dart';

import 'basic_theme/basic_theme.dart';

//* in this class i will use the current active theme to choose between the themes folders
//* if the current active theme is basic i will choose the basic theme colors and styles

class ChooseColorTheme extends ChangeNotifier {
  static Themes currentActiveTheme = Themes.basic;
  static void changeCurrentActiveTheme(Themes theme) {
    currentActiveTheme = theme;
  }

  static Color get kMainColor {
    if (currentActiveTheme == Themes.basic) {
      return BasicTheme.kMainColor;
    } else if (currentActiveTheme == Themes.dark) {
      return DarkTheme.kMainColor;
    } else {
      return DefaultTheme.kMainColor;
    }
  }

  static Color get kInactiveColor {
    if (currentActiveTheme == Themes.basic) {
      return BasicTheme.kInactiveColor;
    } else if (currentActiveTheme == Themes.dark) {
      return DarkTheme.kInactiveColor;
    } else {
      return DefaultTheme.kInactiveColor;
    }
  }

  static Color get kTextFieldInputColor {
    if (currentActiveTheme == Themes.basic) {
      return BasicTheme.kTextFieldInputColor;
    } else if (currentActiveTheme == Themes.dark) {
      return DarkTheme.kTextFieldInputColor;
    } else {
      return DefaultTheme.kTextFieldInputColor;
    }
  }

  static Color get kMainBackgroundColor {
    if (currentActiveTheme == Themes.basic) {
      return BasicTheme.kMainBackgroundColor;
    } else if (currentActiveTheme == Themes.dark) {
      return DarkTheme.kMainBackgroundColor;
    } else {
      return DefaultTheme.kMainBackgroundColor;
    }
  }
}
