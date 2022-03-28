import 'package:flutter/material.dart';

import 'colors.dart';

//* for text styles
const TextStyle kHeadingTextStyle = TextStyle(
  color: kMainColor,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const TextStyle kCalcTextStyle = TextStyle(
  color: kMainColor,
  fontSize: 26,
  fontWeight: FontWeight.bold,
);
const TextStyle kWhiteTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);
const TextStyle kWhiteProfileStatusTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const TextStyle kLinkTextStyle = TextStyle(
  color: kMainColor,
  decoration: TextDecoration.underline,
  fontSize: 16,
);
const TextStyle kParagraphTextStyle = TextStyle(
  color: kMainColor,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
const TextStyle kInActiveParagraphTextStyle = TextStyle(
  color: kInactiveColor,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
const TextStyle kSmallInActiveParagraphTextStyle = TextStyle(
  color: kInactiveColor,
  fontSize: 14,
  fontWeight: FontWeight.normal,
);
const TextStyle kSmallTextPrimaryColorStyle = TextStyle(
  color: kMainColor,
  fontSize: 14,
  fontWeight: FontWeight.normal,
);
const TextStyle kMediumTextPrimaryColorStyle = TextStyle(
  color: kMainColor,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
const TextStyle kSmallTextWhiteColorStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.normal,
);
TextStyle kSmallTextOpaqueColorStyle = TextStyle(
  color: kMainColor.withOpacity(0.6),
  fontSize: 18,
  fontWeight: FontWeight.normal,
);

//* for shadows
BoxShadow kDefaultBoxShadow = BoxShadow(
  offset: const Offset(3, 3),
  blurRadius: 25,
  color: kMainColor.withOpacity(0.2),
);

BoxShadow kBottomNavBarShadow = BoxShadow(
  offset: const Offset(0, -3),
  color: kMainColor.withOpacity(0.2),
  blurRadius: 25,
);
BoxShadow kIconBoxShadow = BoxShadow(
  offset: const Offset(0, 0),
  color: kMainColor.withOpacity(0.2),
  blurRadius: 6,
);

BoxShadow kCardBoxShadow = BoxShadow(
  offset: const Offset(3, 3),
  blurRadius: 6,
  color: kMainColor.withOpacity(0.2),
);
BoxShadow kCardHeavyBoxShadow = BoxShadow(
  offset: const Offset(3, 3),
  blurRadius: 6,
  color: kMainColor.withOpacity(0.5),
);
