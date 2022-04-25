import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

//? 1] google login
Future googleLogin(BuildContext context) async {
  bool deleteAfterLoggingIn = false;
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
  //? here asking the user to delete the current existing data or not
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Delete existing data before logging in ?',
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      deleteAfterLoggingIn = true;
    },
  ).show();

  await Provider.of<SyncedDataProvider>(context, listen: false).getAllData(
    profileProvider,
    transactionProvider,
    quickActionsProvider,
    deleteAfterLoggingIn,
  );
}

//? 2] google logout
Future<void> logOut(BuildContext context) async {
  bool keepData = false;
  await Provider.of<AuthenticationProvider>(
    context,
    listen: false,
  ).googleLogout();

  //? keeping the data of the logged out user will cause a problem of the syncing flags of his data will be none
  //? so i will delete the data from the local storage after the user is logged out
  //? to implement this
  //? one option is to edit all  the kept data flags to be add
  //? but as i said this will cause another problem of duplicate data if the user logged in with the same user after logging out
  //? ------ Don't implement keeping the logged out user data --------------

  // await AwesomeDialog(
  //   context: context,
  //   dialogType: DialogType.WARNING,
  //   animType: AnimType.BOTTOMSLIDE,
  //   title: 'Keep data of logged out user?',
  //   btnCancelOnPress: () {},
  //   btnOkOnPress: () {
  //     keepData = true;
  //   },
  // ).show();

  var profileProvider = Provider.of<ProfilesProvider>(context, listen: false);

  var transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

  var quickActionsProvider =
      Provider.of<QuickActionsProvider>(context, listen: false);

  if (!keepData) {
    profileProvider.clearAllProfiles();
    transactionProvider.clearAllTransactions();
    quickActionsProvider.clearAllQuickActions();
    await DBHelper.deleteDatabase(dbName);
    await profileProvider.clearActiveProfileId();
  }

  await profileProvider.fetchAndUpdateProfiles();
  await profileProvider.fetchAndUpdateActivatedProfileId();
  String activeProfileId = profileProvider.activatedProfileId;
  await transactionProvider.fetchAndUpdateProfileTransactions(activeProfileId);
  await quickActionsProvider.fetchAndUpdateProfileQuickActions(activeProfileId);
  await transactionProvider.fetchAndUpdateAllTransactions();
  await quickActionsProvider.fetchAndUpdateAllQuickActions();
}
