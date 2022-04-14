// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/holder_screen.dart';
import 'package:smart_wallet/widgets/global/main_loading.dart';

import '../providers/profiles_provider.dart';

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

    //? 1]  fetching the active theme
    Future.delayed(Duration.zero).then((value) async {
      // await Provider.of<ThemeProvider>(context, listen: false)
      //     .fetchAndSetActiveTheme();
      // });
      // Future.delayed(Duration.zero).then((value) async {
      // //? 2] fetching the profiles
      // await Provider.of<ProfilesProvider>(context, listen: false)
      //     .fetchAndUpdateProfiles();
      // //? 3] fetching the active profile id
      // //* foe getting the active profile id and default one if empty
      // await Provider.of<ProfilesProvider>(context, listen: false)
      //     .fetchAndUpdateActivatedProfileId();

      // //? 4] fetching the transactions from the database
      // await Provider.of<TransactionProvider>(context, listen: false)
      //     .fetchAllTransactionsFromDataBase();

      //? 5] fetching the quick actions
      // await Provider.of<QuickActionsProvider>(context, listen: false)
      //     .fetchAllQuickActionsFromDataBase();
//! this error happened because i was using pushReplacementNamed and this disposes the providers used here
//! so i think i might need to refresh the providers in the holder screen to user them again after disposing this widget

      //? 6] forwarding the holder screen
      await Future.delayed(Duration.zero).then((value) async =>
          await Navigator.pushReplacementNamed(
              context, HolderScreen.routeName));
      if (await SharedPrefHelper.firstTimeRunApp()) {
      } else {
        await Navigator.pushReplacementNamed(context, HolderScreen.routeName);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
      body: MainLoading(),
    );
  }
}
