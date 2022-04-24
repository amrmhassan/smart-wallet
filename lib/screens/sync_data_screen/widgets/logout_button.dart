// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    Key? key,
  }) : super(key: key);

  Future<void> logOut(
    BuildContext context,
    ProfilesProvider profileProvider,
    TransactionProvider transactionProvider,
    QuickActionsProvider quickActionsProvider,
  ) async {
    await Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    ).googleLogout();
    profileProvider.clearAllProfiles();
    transactionProvider.clearAllTransactions();
    quickActionsProvider.clearAllQuickActions();
    await DBHelper.deleteDatabase(dbName);
    await profileProvider.clearActiveProfileId();
    await profileProvider.fetchAndUpdateProfiles();
    await profileProvider.fetchAndUpdateActivatedProfileId();
    String activeProfileId = profileProvider.activatedProfileId;
    await transactionProvider
        .fetchAndUpdateProfileTransactions(activeProfileId);
    await quickActionsProvider
        .fetchAndUpdateProfileQuickActions(activeProfileId);
    await transactionProvider.fetchAndUpdateAllTransactions();
    await quickActionsProvider.fetchAndUpdateAllQuickActions();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.only(right: kDefaultPadding / 2),
      child: GestureDetector(
        onTap: () async {
          //! here check if there is any data that needs to be synced first and show a dialog to the user to check for that action
          var profileProvider =
              Provider.of<ProfilesProvider>(context, listen: false);

          var transactionProvider =
              Provider.of<TransactionProvider>(context, listen: false);

          var quickActionsProvider =
              Provider.of<QuickActionsProvider>(context, listen: false);

          if (profileProvider.notSyncedProfiles.isNotEmpty ||
              transactionProvider.notSyncedTransactions.isNotEmpty ||
              quickActionsProvider.notSyncedQuickActions.isNotEmpty) {
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Data needs to be synced first, Logout anyway?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async => await logOut(
                context,
                profileProvider,
                transactionProvider,
                quickActionsProvider,
              ),
            ).show();
          } else {
            await logOut(
              context,
              profileProvider,
              transactionProvider,
              quickActionsProvider,
            );
          }
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
