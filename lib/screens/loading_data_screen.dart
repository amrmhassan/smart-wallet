// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/main.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/holder_screen/holder_screen.dart';
import 'package:smart_wallet/utils/general_utils.dart';
import 'package:smart_wallet/widgets/global/main_loading.dart';

class LoadingDataScreen extends StatefulWidget {
  static const String routeName = '/loading-data-screen';
  const LoadingDataScreen({Key? key}) : super(key: key);

  @override
  State<LoadingDataScreen> createState() => _LoadingDataScreenState();
}

class _LoadingDataScreenState extends State<LoadingDataScreen> {
  bool firstTimeRunApp = true;
  //! here load the data form the firestore if there is internet connection and the user is logged in and it the first time to open the app

  Future<void> fetchData() async {
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

    // //? 4] fetching the transactions from the database
    await Provider.of<TransactionProvider>(context, listen: false)
        .fetchAndUpdateProfileTransactions(activeProfileId);

    // //? 5] fetching the quick actions
    await Provider.of<QuickActionsProvider>(context, listen: false)
        .fetchAndUpdateProfileQuickActions(activeProfileId);

    await Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    ).fetchAndUpdateUserPhoto();
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
      await fetchData();
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
          if (showLoggingBanner) CustomHelperWidget(),
        ],
      ),
    );
  }
}
