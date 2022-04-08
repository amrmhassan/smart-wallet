// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeProvider themeProvider = ThemeProvider();

class ThemeProvider extends ChangeNotifier {
  Themes currentTheme = Themes.dark;
  void setTheme(Themes theme) {
    currentTheme = theme;
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
  kIncomeColor,
  kOutcomeColor,
  kSavingsColor,
  kDeleteColor,
  kButtonColor,
}

enum ThemeTextStyles {
  kHeadingTextStyle,
  kCalcTextStyle,
  kActivatedProfileTextStyle,
  kLinkTextStyle,
  kParagraphTextStyle,
  kSmallTextPrimaryColorStyle,
  kMediumTextPrimaryColorStyle,
  kSmallTextOpaqueColorStyle,
  kWhiteTextStyle,
  kWhiteProfileStatusTextStyle,
  kActivateProfileTextStyle,
  kInActiveParagraphTextStyle,
  kSmallInActiveParagraphTextStyle,
  kSmallTextWhiteColorStyle,
}

enum ThemeBoxShadow {
  kDefaultBoxShadow,
  kBottomNavBarShadow,
  kIconBoxShadow,
  kCardBoxShadow,
  kCardHeavyBoxShadow,
}

Map<Themes, Map<ThemeColors, Color>> colorThemes = {
  Themes.basic: {
    ThemeColors.kMainColor: Color(0xff565D94),
    ThemeColors.kSavingsColor: Color(0xff565D94),
    ThemeColors.kInactiveColor: Color(0xffC3C3C3),
    ThemeColors.kTextFieldInputColor: Color(0xffDEDEEA),
    ThemeColors.kMainBackgroundColor: Color(0xffffffff),
    ThemeColors.kCardBackgroundColor: Color(0xffffffff),
    ThemeColors.kIncomeColor: Color(0xff01AD01),
    ThemeColors.kOutcomeColor: Color(0xffD60000),
    ThemeColors.kDeleteColor: Color.fromARGB(255, 204, 24, 11),
    ThemeColors.kButtonColor: Color(0xff565D94),
  },
  Themes.dark: {
    ThemeColors.kMainColor: Color(0xffffffff).withOpacity(0.7),
    ThemeColors.kSavingsColor: Color(0xffF39F2A),
    ThemeColors.kInactiveColor: Color(0xff9A9CA3),
    ThemeColors.kTextFieldInputColor: Color(0xff3C4854),
    ThemeColors.kMainBackgroundColor: Color(0xff3C4854),
    ThemeColors.kCardBackgroundColor: Color(0xff283949),
    ThemeColors.kIncomeColor: Color(0xffAEE607),
    ThemeColors.kOutcomeColor: Color(0xffEF2D2D),
    ThemeColors.kDeleteColor: Color.fromARGB(255, 204, 24, 11),
    ThemeColors.kButtonColor: Color.fromARGB(255, 22, 46, 67),
  },
  Themes.light: {
    ThemeColors.kMainColor: Color(0xff565D94),
    ThemeColors.kSavingsColor: Color(0xff8A51E8),
    ThemeColors.kInactiveColor: Color(0xffC3C3C3),
    ThemeColors.kTextFieldInputColor: Color(0xffDEDEEA),
    ThemeColors.kMainBackgroundColor: Color(0xffDEDEEA),
    ThemeColors.kCardBackgroundColor: Color(0xffffffff),
    ThemeColors.kIncomeColor: Color(0xff01AD01),
    ThemeColors.kOutcomeColor: Color(0xffD60000),
    ThemeColors.kDeleteColor: Color.fromARGB(255, 204, 24, 11),
    ThemeColors.kButtonColor: Color.fromARGB(255, 11, 79, 134),
  }
};

Map<Themes, Map<ThemeBoxShadow, BoxShadow>> boxShadowThemes = {
  Themes.basic: {
    ThemeBoxShadow.kDefaultBoxShadow: BoxShadow(
      offset: const Offset(3, 3),
      blurRadius: 25,
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.2),
    ),
    ThemeBoxShadow.kBottomNavBarShadow: BoxShadow(),
    ThemeBoxShadow.kIconBoxShadow: BoxShadow(
      offset: const Offset(0, 0),
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.2),
      blurRadius: 6,
    ),
    ThemeBoxShadow.kCardBoxShadow: BoxShadow(
      offset: const Offset(3, 3),
      blurRadius: 6,
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.2),
    ),
    ThemeBoxShadow.kCardHeavyBoxShadow: BoxShadow(
      offset: const Offset(3, 3),
      blurRadius: 6,
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.5),
    ),
  },
  Themes.dark: {
    ThemeBoxShadow.kDefaultBoxShadow: BoxShadow(),
    ThemeBoxShadow.kBottomNavBarShadow: BoxShadow(),
    ThemeBoxShadow.kIconBoxShadow: BoxShadow(
      offset: const Offset(0, 0),
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.2),
      blurRadius: 6,
    ),
    ThemeBoxShadow.kCardBoxShadow: BoxShadow(
      offset: const Offset(3, 3),
      blurRadius: 6,
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.2),
    ),
    ThemeBoxShadow.kCardHeavyBoxShadow: BoxShadow(
      offset: const Offset(3, 3),
      blurRadius: 6,
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.5),
    ),
  },
};

Map<Themes, Map<ThemeTextStyles, TextStyle>> textStylesThemes = {
  //? basic theme text styles
  Themes.basic: {
    ThemeTextStyles.kHeadingTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kCalcTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kActivatedProfileTextStyle: TextStyle(
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.5),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kLinkTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      decoration: TextDecoration.underline,
      fontSize: 16,
    ),
    ThemeTextStyles.kParagraphTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kSmallTextPrimaryColorStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kMediumTextPrimaryColorStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kSmallTextOpaqueColorStyle: TextStyle(
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.6),
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kWhiteTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kWhiteProfileStatusTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kActivateProfileTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kInActiveParagraphTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kInactiveColor),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kSmallInActiveParagraphTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kInactiveColor),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kSmallTextWhiteColorStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  },
  //? dark theme text styles
  Themes.dark: {
    ThemeTextStyles.kHeadingTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kCalcTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kActivatedProfileTextStyle: TextStyle(
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.5),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kLinkTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      decoration: TextDecoration.underline,
      fontSize: 16,
    ),
    ThemeTextStyles.kParagraphTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kSmallTextPrimaryColorStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kMediumTextPrimaryColorStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kMainColor),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kSmallTextOpaqueColorStyle: TextStyle(
      color:
          themeProvider.getThemeColor(ThemeColors.kMainColor).withOpacity(0.6),
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kWhiteTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kWhiteProfileStatusTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kActivateProfileTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kInActiveParagraphTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kInactiveColor),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    ThemeTextStyles.kSmallInActiveParagraphTextStyle: TextStyle(
      color: themeProvider.getThemeColor(ThemeColors.kInactiveColor),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    ThemeTextStyles.kSmallTextWhiteColorStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  },
};
