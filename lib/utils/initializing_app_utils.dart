import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/checkers/theme_checker.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/holder_screen/holder_screen.dart';
import 'package:smart_wallet/screens/intro_screen/intro_screen.dart';
import 'package:smart_wallet/utils/synced_data_utils.dart';

//? fetching user photo and set the file in the provider
Future<void> fetchUserPhoto(BuildContext context) async {
  await Provider.of<AuthenticationProvider>(
    context,
    listen: false,
  ).fetchAndUpdateUserPhoto();
}

//? initializing required data for the app on the first load
Future<void> handleInitialzingApp(BuildContext context) async {
  bool firstTimeOpenApp = await SharedPrefHelper.firstTimeRunApp();
  bool loggedIn =
      Provider.of<AuthenticationProvider>(context, listen: false).loggedIn();

  //* checking themes
  checkThemes();

  //* logging out if first time open the app then continue
  if (firstTimeOpenApp && loggedIn) {
    await logOut(
      context,
    );

    await handleDeleteUserPhoto(context);
  }

  //* if logged in set the user photo file to be viewed
  if (Provider.of<AuthenticationProvider>(context, listen: false).loggedIn()) {
    //* 0] fetching the user photo from the( should be run here before any returns that come next)
    await fetchUserPhoto(context);
  }

  //* if first time open the app go to the intro screen
  if (firstTimeOpenApp) {
    await fetchAndUpdatingDataFromSqlite(context);
    await Navigator.pushReplacementNamed(context, IntroScreen.routeName);
    return;
  }

  await fetchAndUpdatingDataFromSqlite(context);
  await Navigator.pushReplacementNamed(context, HolderScreen.routeName);
}

//? fetching and updating the data from the sqlite
Future<void> fetchAndUpdatingDataFromSqlite(BuildContext context) async {
  //* 1]  fetching the active theme
  await Provider.of<ThemeProvider>(context, listen: false)
      .fetchAndSetActiveTheme();

  //* 2] fetching the profiles
  await Provider.of<ProfilesProvider>(context, listen: false)
      .fetchAndUpdateProfiles(context);

  //* 3] fetching the active profile id
  await Provider.of<ProfilesProvider>(context, listen: false)
      .fetchAndUpdateActivatedProfileId();

  String activeProfileId =
      Provider.of<ProfilesProvider>(context, listen: false).activatedProfileId;

  //* 4] fetching the transactions from the database
  await Provider.of<TransactionProvider>(context, listen: false)
      .fetchAndUpdateProfileTransactions(activeProfileId);

  //* 5] fetching the quick actions
  await Provider.of<QuickActionsProvider>(context, listen: false)
      .fetchAndUpdateProfileQuickActions(activeProfileId);
  //*6] fetch user debts
  await Provider.of<DebtsProvider>(context, listen: false)
      .fetchAndUpdateDebts();
  //* 7] updating profiles data
  await Provider.of<ProfilesProvider>(context, listen: false).calcProfilesData(
    Provider.of<TransactionProvider>(context, listen: false),
    Provider.of<DebtsProvider>(context, listen: false),
  );
}

//? syncing data from the firestore
Future<void> syncDown(BuildContext context) async {
  //* never delete the data or make the delete to be true

//* here load the data form the firestore if there is internet connection and the user is logged in and it the first time to open the app
  var profilesProvider = Provider.of<ProfilesProvider>(context, listen: false);

  var transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

  var quickActionsProvider =
      Provider.of<QuickActionsProvider>(context, listen: false);

  //* 0] getting all the data if online, first time open the app, and logged in
  //* deleting the data
  return Provider.of<SyncedDataProvider>(context, listen: false).getAllData(
    profilesProvider,
    transactionProvider,
    quickActionsProvider,
  );
}
