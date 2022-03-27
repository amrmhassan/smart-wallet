import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/types.dart';

String doubleToString(double amount) {
  try {
    String string = amount.toStringAsFixed(2);
    return string.replaceFirst('.00', '');
  } catch (error) {
    return 'error converting double to string';
  }
}

void showSnackBar(
    BuildContext context, String message, SnackBarType snackBarType,
    [bool aboveBottomNavBar = false]) {
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
              ? kOutcomeColor
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
