// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/utils/initializing_app_utils.dart';
import 'package:smart_wallet/widgets/global/main_loading.dart';
import 'package:smart_wallet/widgets/global/open_logging_screen.dart';

class LoadingDataScreen extends StatefulWidget {
  static const String routeName = '/loading-data-screen';
  const LoadingDataScreen({Key? key}) : super(key: key);

  @override
  State<LoadingDataScreen> createState() => _LoadingDataScreenState();
}

class _LoadingDataScreenState extends State<LoadingDataScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await handleInitialzingApp(context);
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





  // Future<void> handleStart() async {
  //   // bool online = await isOnline();
  //   bool firstTimeOpenApp = await SharedPrefHelper.firstTimeRunApp();
  //   bool loggedIn =
  //       Provider.of<AuthenticationProvider>(context, listen: false).loggedIn();

  //   // logging out if first time open the app then continue
  //   if (firstTimeOpenApp && loggedIn) {
  //     await logOut(
  //       context,
  //     );
  //   }

  //   // if logged in set the user photo file to be viewed
  //   if (loggedIn) {
  //     // 0] fetching the user photo from the( should be run here before any returns that come next)
  //     await Provider.of<AuthenticationProvider>(
  //       context,
  //       listen: false,
  //     ).fetchAndUpdateUserPhoto();
  //   }

  //   // if first time open the app go to the intro screen
  //   if (firstTimeOpenApp) {
  //     await Navigator.pushReplacementNamed(context, IntroScreen.routeName);
  //     return;
  //   }

  //   // if (online && firstTimeOpenApp && loggedIn) {
  //   //   return syncDown();
  //   // }

  //   // if logged in, first time open the app but not online, show a dialog to warn the user that no internet connection and he needs to fetch the data from the cloud once online
  //   // if (!online && loggedIn && firstTimeOpenApp) {
  //   //   await SharedPrefHelper.toggleNeedSyncDown();
  //   //   showSnackBar(
  //   //       context, 'Data will be synced down once online!', SnackBarType.info);
  //   // }
  //   // if online and need sync down , just sync the data down , and then turn of the sync
  //   // bool needSyncDown = await SharedPrefHelper.needSyncDown();
  //   // if (online && needSyncDown && !firstTimeOpenApp) {
  //   //   await SharedPrefHelper.toggleNeedSyncDown();
  //   //   //* don't delete any of the data exist on the app because the user might have some data that he created
  //   //   //* if the user have any data inside the app but the default profile just delete all data before getting the new data from the firestore
  //   //   //* else just get the data from the firestore and merge them with the existing data

  //   //   return syncDown();
  //   // }
  //   await fetchAndUpdatingDataFromSqlite(context);
  //   await Navigator.pushReplacementNamed(context, HolderScreen.routeName);
  // }
