// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/holder_screen/holder_screen.dart';
import 'package:smart_wallet/screens/intro_screen/intro_screen.dart';
import 'package:smart_wallet/utils/general_utils.dart';
import 'package:smart_wallet/widgets/global/main_loading.dart';
import 'package:smart_wallet/widgets/global/open_logging_screen.dart';

class LoadingDataScreen extends StatefulWidget {
  static const String routeName = '/loading-data-screen';
  const LoadingDataScreen({Key? key}) : super(key: key);

  @override
  State<LoadingDataScreen> createState() => _LoadingDataScreenState();
}

class _LoadingDataScreenState extends State<LoadingDataScreen> {
  Future<void> syncDown([bool delete = false]) async {
    //* never delete the data or make the delete to be true
    if (delete) {
      throw CustomError(
          'Don\'t delete the data cause the user might have some ', null);
    }
//* here load the data form the firestore if there is internet connection and the user is logged in and it the first time to open the app
    var profilesProvider =
        Provider.of<ProfilesProvider>(context, listen: false);

    var transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    var quickActionsProvider =
        Provider.of<QuickActionsProvider>(context, listen: false);

    //? 0] getting all the data if online, first time open the app, and logged in
    //* deleting the data
    return Provider.of<SyncedDataProvider>(context, listen: false).getAllData(
      profilesProvider,
      transactionProvider,
      quickActionsProvider,
    );
  }

  Future<void> fetchData() async {
    bool online = await isOnline();
    bool firstTimeOpenApp = await SharedPrefHelper.firstTimeRunApp();
    bool loggedIn =
        Provider.of<AuthenticationProvider>(context, listen: false).loggedIn();

    if (firstTimeOpenApp && !loggedIn) {
      await Navigator.pushReplacementNamed(context, IntroScreen.routeName);
      return;
    }
    if (loggedIn) {
      //? 0] fetching the user photo from the( should be run here before any returns that come next)
      await Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      ).fetchAndUpdateUserPhoto();
    }

    if (online && firstTimeOpenApp && loggedIn) {
      return syncDown();
    }

    //* if logged in, first time open the app but not online, show a dialog to warn the user that no internet connection and he needs to fetch the data from the cloud once online
    if (!online && loggedIn && firstTimeOpenApp) {
      await SharedPrefHelper.toggleNeedSyncDown();
      showSnackBar(
          context, 'Data will be synced down once online!', SnackBarType.info);
    }
    //* if online and need sync down , just sync the data down , and then turn of the sync
    bool needSyncDown = await SharedPrefHelper.needSyncDown();
    if (online && needSyncDown && !firstTimeOpenApp) {
      await SharedPrefHelper.toggleNeedSyncDown();
      //* don't delete any of the data exist on the app because the user might have some data that he created
      //* if the user have any data inside the app but the default profile just delete all data before getting the new data from the firestore
      //* else just get the data from the firestore and merge them with the existing data

      return syncDown();
    }

    //? 1]  fetching the active theme
    await Provider.of<ThemeProvider>(context, listen: false)
        .fetchAndSetActiveTheme();

    //? 2] fetching the profiles
    await Provider.of<ProfilesProvider>(context, listen: false)
        .fetchAndUpdateProfiles(context);

    //? 3] fetching the active profile id
    await Provider.of<ProfilesProvider>(context, listen: false)
        .fetchAndUpdateActivatedProfileId();

    String activeProfileId =
        Provider.of<ProfilesProvider>(context, listen: false)
            .activatedProfileId;

    if (!firstTimeOpenApp) {
      //? 4] fetching the transactions from the database
      await Provider.of<TransactionProvider>(context, listen: false)
          .fetchAndUpdateProfileTransactions(activeProfileId);

      //? 5] fetching the quick actions
      await Provider.of<QuickActionsProvider>(context, listen: false)
          .fetchAndUpdateProfileQuickActions(activeProfileId);
    }
  }

  @override
  void initState() {
    super.initState();

    // this work very well in debugging mode but in production mode the problem happens and i can't debug the problem in production mode
    // i have no other solution but this to fix the ultimate fucken problem
    // this will run first

    // if you made this of zero duration the loading will be infinitely loading in the production
    Future.delayed(Duration.zero).then((value) async {
      await fetchData();
      //! this is not good but i have no other way around this right now
      // await fetchData();
      Navigator.pushReplacementNamed(context, HolderScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
      body: Stack(
        children: [
          MainLoading(),
          if (showLoggingBanner) OpenLoggingScreen(),
        ],
      ),
    );
  }
}
