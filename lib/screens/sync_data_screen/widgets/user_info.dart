// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';

import '../../../constants/theme_constants.dart';
import '../../../providers/theme_provider.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(
              width: 2,
              color: themeProvider.getThemeColor(
                ThemeColors.kMainColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: kDefaultPadding / 2,
        ),
        Text(
          'User Name',
          style: themeProvider.getTextStyle(
            ThemeTextStyles.kHeadingTextStyle,
          ),
        ),
      ],
    );
  }
}
