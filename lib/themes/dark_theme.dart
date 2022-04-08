import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';

Map<ThemeColors, Color> darkColors = {
  ThemeColors.kMainColor: const Color(0xffffffff).withOpacity(0.7),
  ThemeColors.kSavingsColor: const Color(0xffF39F2A),
  ThemeColors.kInactiveColor: const Color(0xff9A9CA3),
  ThemeColors.kTextFieldInputColor: const Color(0xff3C4854),
  ThemeColors.kMainBackgroundColor: const Color(0xff3C4854),
  ThemeColors.kCardBackgroundColor: const Color(0xff283949),
  ThemeColors.kIncomeColor: const Color(0xffAEE607),
  ThemeColors.kOutcomeColor: const Color(0xffEF2D2D),
  ThemeColors.kDeleteColor: const Color.fromARGB(255, 204, 24, 11),
  ThemeColors.kButtonColor: const Color.fromARGB(255, 22, 46, 67),
};

Map<ThemeBoxShadow, BoxShadow> darkBoxShadows = {
  ThemeBoxShadow.kDefaultBoxShadow: const BoxShadow(),
  ThemeBoxShadow.kBottomNavBarShadow: const BoxShadow(),
  ThemeBoxShadow.kIconBoxShadow: const BoxShadow(),
  ThemeBoxShadow.kCardBoxShadow: BoxShadow(
    offset: const Offset(3, 3),
    blurRadius: 6,
    color: darkColors[ThemeColors.kMainColor]!.withOpacity(0.2),
  ),
  ThemeBoxShadow.kCardHeavyBoxShadow: BoxShadow(
    offset: const Offset(3, 3),
    blurRadius: 6,
    color: darkColors[ThemeColors.kMainColor]!.withOpacity(0.5),
  ),
};

Map<ThemeTextStyles, TextStyle> darkTextStyles = {
  ThemeTextStyles.kHeadingTextStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kCalcTextStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kActivatedProfileTextStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!.withOpacity(0.5),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kLinkTextStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!,
    decoration: TextDecoration.underline,
    fontSize: 16,
  ),
  ThemeTextStyles.kParagraphTextStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kSmallTextPrimaryColorStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  ThemeTextStyles.kMediumTextPrimaryColorStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
  ThemeTextStyles.kSmallTextOpaqueColorStyle: TextStyle(
    color: darkColors[ThemeColors.kMainColor]!.withOpacity(0.6),
    fontSize: 18,
    fontWeight: FontWeight.normal,
  ),
  ThemeTextStyles.kWhiteTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kWhiteProfileStatusTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kActivateProfileTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kInActiveParagraphTextStyle: TextStyle(
    color: darkColors[ThemeColors.kInactiveColor],
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kSmallInActiveParagraphTextStyle: TextStyle(
    color: darkColors[ThemeColors.kInactiveColor],
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  ThemeTextStyles.kSmallTextWhiteColorStyle: const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
};
