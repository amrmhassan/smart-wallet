// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class MainLoading extends StatelessWidget {
  const MainLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Smart Wallet',
            style: TextStyle(
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: kDefaultPadding * 2,
          ),
          Container(
            alignment: Alignment.center,
            child: SpinKitCubeGrid(
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              size: 100,
              duration: Duration(seconds: 1),
            ),
          ),
        ],
      ),
    );
  }
}
