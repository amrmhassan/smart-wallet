// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/goole_signin_button.dart';
import 'package:smart_wallet/widgets/global/line.dart';

class LogInUserOptions extends StatelessWidget {
  final Future<void> Function() googleLogin;
  // final bool isOnline;
  const LogInUserOptions({
    Key? key,
    required this.googleLogin,
    // required this.isOnline,
  }) : super(key: key);

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
              child: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) => Text(
                  snapshot.hasData
                      ? 'Sign In with another email?'
                      : 'Sign In Using',
                  style: themeProvider.getTextStyle(
                    ThemeTextStyles.kInActiveParagraphTextStyle,
                  ),
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
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) => GoogleSignInButton(
                onTap: () async => await googleLogin(),
              ),
            )
          ],
        ),
      ],
    );
  }
}
