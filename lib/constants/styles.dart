import 'package:flutter/cupertino.dart';

import 'colors.dart';

const TextStyle kHeadingTextStyle = TextStyle(
  color: kMainColor,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const TextStyle kParagraphTextStyle = TextStyle(
  color: kMainColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

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
