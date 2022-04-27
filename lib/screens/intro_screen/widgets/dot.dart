// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/durations.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class Dot extends StatelessWidget {
  final bool active;
  const Dot({
    Key? key,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      duration: kAnimationsDuration,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: active
            ? themeProvider.getThemeColor(ThemeColors.kMainColor)
            : themeProvider
                .getThemeColor(ThemeColors.kMainColor)
                .withOpacity(.2),
        borderRadius: BorderRadius.circular(1000),
      ),
      width: 5,
      height: 5,
    );
  }
}
