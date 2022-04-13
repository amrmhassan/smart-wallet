// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/holder_screen.dart';

import '../providers/profiles_provider.dart';
import '../providers/quick_actions_provider.dart';
import '../providers/transactions_provider.dart';

class LoadingDataScreen extends StatefulWidget {
  static const String routeName = '/loading-data-screen';
  const LoadingDataScreen({Key? key}) : super(key: key);

  @override
  State<LoadingDataScreen> createState() => _LoadingDataScreenState();
}

class _LoadingDataScreenState extends State<LoadingDataScreen> {
  bool firstTimeRunApp = true;
  @override
  void initState() {
    //* i needed the trick of duration zero here
    //* here i will fetch and update the transactions

    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<ThemeProvider>(context, listen: false)
          .fetchAndSetActiveTheme();
    });
    Future.delayed(Duration.zero).then((value) async {
      //* for getting the profiles and initialize one if empty
      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchAndUpdateProfiles();

      //* foe getting the active profile id and default one if empty
      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchAndUpdateActivatedProfileId();

      //* for setting the active profile id

      //* for getting the transactions of the active profile
      await Provider.of<TransactionProvider>(context, listen: false)
          .fetchAllTransactionsFromDataBase();

      //* for getting the quick actions of the active profile
      await Provider.of<QuickActionsProvider>(context, listen: false)
          .fetchAllQuickActionsFromDataBase();

      //* check if it the first time to run the app to make the animation last longer(5 sec)
      await Future.delayed(Duration(seconds: 2)).then((value) async =>
          Navigator.pushReplacementNamed(context, HolderScreen.routeName));
      // if (await SharedPrefHelper.firstTimeRunApp()) {
      //   //* loading the data after 3 seconds if it the first time to run the app
      // } else {
      //   //* loading the app UI after finishing fetching data from the database immediately if it isn't the first time to run the app
      //   Navigator.pushReplacementNamed(context, HolderScreen.routeName);
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Smart Wallet',
            style: TextStyle(
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: kDefaultPadding * 2,
          ),
          Container(
            alignment: Alignment.center,
            child: SpinKitCubeGrid(
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              size: 100,
              duration: Duration(seconds: 1),
            ),
          ),
        ],
      ),
    );
  }
}
