// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/goole_signin_button.dart';
import 'package:smart_wallet/widgets/global/line.dart';

class LogInUserOptions extends StatelessWidget {
  const LogInUserOptions({
    Key? key,
  }) : super(key: key);

  Future googleLogin(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //* this means there is already a user signed in so sign out first then sign in with another user
      await Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      ).googleLogout();
    }
    //! here i want to implement the loading of logging in
    await Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    ).googleLogin();

    var profileProvider = Provider.of<ProfilesProvider>(context, listen: false);

    var transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    var quickActionsProvider =
        Provider.of<QuickActionsProvider>(context, listen: false);

    await Provider.of<SyncedDataProvider>(context, listen: false).getAllData(
      profileProvider,
      transactionProvider,
      quickActionsProvider,
    );
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
                onTap: snapshot.hasData
                    ? () async => await googleLogin(context)
                    : () async => await googleLogin(context),
              ),
            )
          ],
        ),
      ],
    );
  }
}
