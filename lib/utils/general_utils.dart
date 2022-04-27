import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import '../constants/theme_constants.dart';
import '../constants/types.dart';

String doubleToString(double amount) {
  try {
    String string = amount.toStringAsFixed(2);
    return string.replaceFirst('.00', '');
  } catch (error, stackTrace) {
    CustomError.log(error, stackTrace);
    return 'error converting double to string';
  }
}

void showSnackBar(
    BuildContext context, String message, SnackBarType snackBarType,
    [bool aboveBottomNavBar = false]) {
  var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // margin: aboveBottomNavBar
      //     ? const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 50)
      //     : null,
      behavior: aboveBottomNavBar ? SnackBarBehavior.floating : null,
      content: Text(
        message,
      ),
      backgroundColor: snackBarType == SnackBarType.success
          ? Colors.green
          : snackBarType == SnackBarType.error
              ? themeProvider.getThemeColor(ThemeColors.kOutcomeColor)
              : null,
      action: SnackBarAction(
        label: 'Ok',
        textColor: snackBarType == SnackBarType.error ||
                snackBarType == SnackBarType.success ||
                snackBarType == SnackBarType.info
            ? Colors.white
            : null,
        onPressed: () {},
      ),
    ),
  );
}

void showStackedSnackBar(
  BuildContext? context,
  String message, [
  SnackBarType snackBarType = SnackBarType.info,
  bool aboveBottomNavBar = false,
]) {
  if (!showHelperSnackBars) {
    return;
  }
  if (context == null) {
    return;
  }
  var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // margin: aboveBottomNavBar
      //     ? const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 50)
      //     : null,
      behavior: aboveBottomNavBar ? SnackBarBehavior.floating : null,
      content: Text(
        message,
      ),
      backgroundColor: snackBarType == SnackBarType.success
          ? Colors.green
          : snackBarType == SnackBarType.error
              ? themeProvider.getThemeColor(ThemeColors.kOutcomeColor)
              : null,
      action: SnackBarAction(
        label: 'Ok',
        textColor: snackBarType == SnackBarType.error ||
                snackBarType == SnackBarType.success ||
                snackBarType == SnackBarType.info
            ? Colors.white
            : null,
        onPressed: () {},
      ),
    ),
  );
}

Future<bool> isOnline() async {
  bool online = false;
  try {
    var result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      online = true;
    }
  } catch (error, stackTrace) {
    CustomError.log(error, stackTrace);
    online = false;
  }
  return online;
}
