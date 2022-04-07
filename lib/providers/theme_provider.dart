// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Themes currentTheme = Themes.basic;
  void setTheme(Themes theme) {
    currentTheme = theme;
    notifyListeners();
  }

  Color getThemeColor(ThemeColors themeColor) {
    return colorThemes[currentTheme]![themeColor] as Color;
  }
}

enum Themes {
  basic,
  dark,
  light,
}

enum ThemeColors {
  kMainColor,
  kInactiveColor,
  kTextFieldInputColor,
  kMainBackgroundColor,
  kCardBackgroundColor,
}

Map<Themes, Map<ThemeColors, Color>> colorThemes = {
  Themes.basic: {
    ThemeColors.kMainColor: Color(0xff565D94),
    ThemeColors.kInactiveColor: Color(0xffC3C3C3),
    ThemeColors.kTextFieldInputColor: Color(0xffDEDEEA),
    ThemeColors.kMainBackgroundColor: Color(0xffffffff),
    ThemeColors.kCardBackgroundColor: Color(0xffffffff),
  },
  Themes.dark: {
    ThemeColors.kMainColor: Color(0xffffffff),
    ThemeColors.kInactiveColor: Color(0xff9A9CA3),
    ThemeColors.kTextFieldInputColor: Color(0xff2A2D3E),
    ThemeColors.kMainBackgroundColor: Color(0xff212332),
    ThemeColors.kCardBackgroundColor: Color(0xff2A2D3E),
  },
  Themes.light: {
    ThemeColors.kMainColor: Color(0xff565D94),
    ThemeColors.kInactiveColor: Color(0xffC3C3C3),
    ThemeColors.kTextFieldInputColor: Color(0xffDEDEEA),
    ThemeColors.kMainBackgroundColor: Color(0xffDEDEEA),
    ThemeColors.kCardBackgroundColor: Color(0xffffffff),
  }
};
