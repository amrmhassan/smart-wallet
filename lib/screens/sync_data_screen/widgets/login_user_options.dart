// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/goole_signin_button.dart';
import 'package:smart_wallet/widgets/global/line.dart';

class LogInUserOptions extends StatelessWidget {
  const LogInUserOptions({
    Key? key,
  }) : super(key: key);

  Future googleLogin(BuildContext context) async {
    await Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    ).googleLogin();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Line(
                lineType: LineType.horizontal,
                thickness: 1,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kDefaultHorizontalPadding / 3),
              child: Text(
                'Sign In Using',
                style: themeProvider.getTextStyle(
                  ThemeTextStyles.kInActiveParagraphTextStyle,
                ),
              ),
            ),
            Expanded(
              child: Line(
                lineType: LineType.horizontal,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: kDefaultPadding / 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleSignInButton(
              onTap: () async => await googleLogin(context),
            )
          ],
        ),
      ],
    );
  }
}
