// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/themes/basic_theme.dart';
import 'package:smart_wallet/themes/dark_theme.dart';

//* this should throw an error if a key does exist but doesn't exist in either themes
void checkThemes() {
  if (kDebugMode) {
    _checkColors();
    print('Colors Checked');

    _checkBoxShadows();
    print('box shadows Checked');

    _checkTextStyles();
    print('text styles Checked');
  }
}

void _checkColors() {
  for (var colorKey in ThemeColors.values) {
    try {
      Color darkColor = darkColors[colorKey] as Color;
    } catch (error) {
      CustomError.log(
          rethrowError: true,
          error: 'error occurred at $colorKey for dark theme');
    }
    try {
      Color basicColor = basicColors[colorKey] as Color;
    } catch (error) {
      CustomError.log(
          rethrowError: true,
          error: 'error occurred at $colorKey for basic theme');
    }
  }
}

void _checkBoxShadows() {
  for (var colorKey in ThemeBoxShadow.values) {
    try {
      BoxShadow darkBoxShadow = darkBoxShadows[colorKey] as BoxShadow;
    } catch (error) {
      CustomError.log(
          rethrowError: true,
          error: 'error occurred at $colorKey for dark theme');
    }
    try {
      BoxShadow basicBoxShadow = basicBoxShadows[colorKey] as BoxShadow;
    } catch (error) {
      CustomError.log(
          rethrowError: true,
          error: 'error occurred at $colorKey for basic theme');
    }
  }
}

void _checkTextStyles() {
  for (var colorKey in ThemeTextStyles.values) {
    try {
      TextStyle darkBoxShadow = darkTextStyles[colorKey] as TextStyle;
    } catch (error) {
      CustomError.log(
          rethrowError: true,
          error: 'error occurred at $colorKey for dark theme');
    }
    try {
      TextStyle basicBoxShadow = basicTextStyles[colorKey] as TextStyle;
    } catch (error) {
      CustomError.log(
          rethrowError: true,
          error: 'error occurred at $colorKey for basic theme');
    }
  }
}
