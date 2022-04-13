// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.only(right: kDefaultPadding / 2),
      child: GestureDetector(
        onTap: () async {
          await Provider.of<AuthenticationProvider>(
            context,
            listen: false,
          ).googleLogout();
        },
        child: Text(
          'Log Out',
          style: TextStyle(
            color: themeProvider.getThemeColor(
              ThemeColors.kMainColor,
            ),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
