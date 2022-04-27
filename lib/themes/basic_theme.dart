import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';

Map<ThemeColors, Color> basicColors = {
  ThemeColors.kMainColor: const Color(0xff565D94),
  ThemeColors.kSavingsColor: const Color(0xff565D94),
  ThemeColors.kInactiveColor: const Color(0xffC3C3C3),
  ThemeColors.kTextFieldInputColor: const Color(0xffDEDEEA),
  ThemeColors.kMainBackgroundColor: const Color(0xffffffff),
  ThemeColors.kCardBackgroundColor: const Color(0xffffffff),
  ThemeColors.kIncomeColor: const Color(0xff01AD01),
  ThemeColors.kOutcomeColor: const Color(0xffD60000),
  ThemeColors.kDeleteColor: const Color.fromARGB(255, 204, 24, 11),
  ThemeColors.kActiveButtonColor: const Color(0xff565D94),
  ThemeColors.kInActiveButtonColor: const Color(0xff565D94),
};

Map<ThemeBoxShadow, BoxShadow> basicBoxShadows = {
  ThemeBoxShadow.kDefaultBoxShadow: BoxShadow(
    offset: const Offset(3, 3),
    blurRadius: 25,
    color: basicColors[ThemeColors.kMainColor]!.withOpacity(0.2),
  ),
  ThemeBoxShadow.kBottomNavBarShadow: const BoxShadow(),
  ThemeBoxShadow.kIconBoxShadow: BoxShadow(
    offset: const Offset(0, 0),
    color: basicColors[ThemeColors.kMainColor]!.withOpacity(0.2),
    blurRadius: 6,
  ),
  ThemeBoxShadow.kCardBoxShadow: BoxShadow(
    offset: const Offset(3, 3),
    blurRadius: 6,
    color: basicColors[ThemeColors.kMainColor]!.withOpacity(0.2),
  ),
  ThemeBoxShadow.kCardHeavyBoxShadow: BoxShadow(
    offset: const Offset(3, 3),
    blurRadius: 6,
    color: basicColors[ThemeColors.kMainColor]!.withOpacity(0.5),
  ),
};

Map<ThemeTextStyles, TextStyle> basicTextStyles = {
  ThemeTextStyles.kHeadingTextStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kExtraLargeHeadingTextStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kCalcTextStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor],
    fontSize: 26,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kActivatedProfileTextStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!.withOpacity(0.5),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kLinkTextStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!,
    decoration: TextDecoration.underline,
    fontSize: 16,
  ),
  ThemeTextStyles.kParagraphTextStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kSmallTextPrimaryColorStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  ThemeTextStyles.kMediumTextPrimaryColorStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
  ThemeTextStyles.kSmallTextOpaqueColorStyle: TextStyle(
    color: basicColors[ThemeColors.kMainColor]!.withOpacity(0.6),
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
    color: basicColors[ThemeColors.kInactiveColor]!,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  ThemeTextStyles.kSmallInActiveParagraphTextStyle: TextStyle(
    color: basicColors[ThemeColors.kInactiveColor]!,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  ThemeTextStyles.kSmallTextWhiteColorStyle: const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
};
