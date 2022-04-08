// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';

class DrawerLogo extends StatelessWidget {
  const DrawerLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Center(
            child: Text(
              's',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 200,
                color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                fontFamily: 'Rubik',
              ),
            ),
          ),
          Text(
            'Smart Wallet',
            style: TextStyle(
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
