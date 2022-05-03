import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';
import 'basic_theme.dart';
import 'dark_theme.dart';

Map<Themes, Map<ThemeColors, Color>> colorThemes = {
  Themes.basic: basicColors,
  Themes.dark: darkColors,
};

Map<Themes, Map<ThemeBoxShadow, BoxShadow>> boxShadowThemes = {
  Themes.basic: basicBoxShadows,
  Themes.dark: darkBoxShadows,
};

Map<Themes, Map<ThemeTextStyles, TextStyle>> textStylesThemes = {
  Themes.basic: basicTextStyles,
  Themes.dark: darkTextStyles,
};
