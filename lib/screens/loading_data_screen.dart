// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/helpers/shared_pref_helper.dart';
import 'package:wallet_app/screens/holder_screen.dart';

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
      //* i forgot to add the await
      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchAndUpdateProfiles();

      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchAndUpdateActivatedProfileId();
      String activatedProfileId =
          Provider.of<ProfilesProvider>(context, listen: false)
              .activatedProfileId;
      await Provider.of<TransactionProvider>(context, listen: false)
          .fetchAndUpdateTransactions(activatedProfileId);

      //? for loading dummy transaction, only in debug mode and it is the first time to run the app
      if (kDebugMode) {
        Provider.of<TransactionProvider>(context, listen: false)
            .loadDummyTransactions();
      }

      // if (kDebugMode && await SharedPrefHelper.firstTimeRunApp()) {
      //   var activeProfileId =
      //       Provider.of<ProfilesProvider>(context, listen: false)
      //           .getActiveProfile;
      //   for (var t in dummyTransactions) {
      //     await addTransaction(
      //       context: context,
      //       title: t.title,
      //       description: t.description,
      //       transactionType: t.transactionType,
      //       activeProfile: activeProfileId,
      //       amount: t.amount,
      //       allowSnackBar: false,
      //     );
      //   }
      // }

      await Provider.of<QuickActionsProvider>(context, listen: false)
          .fetchAndUpdateQuickActions(activatedProfileId);

      //* check if it the first time to run the app

      if (await SharedPrefHelper.firstTimeRunApp()) {
        //* loading the data after 3 seconds if it the first time to run the app
        await Future.delayed(Duration(seconds: 5)).then((value) async =>
            await Navigator.pushReplacementNamed(
                context, HolderScreen.routeName));
      } else {
        //* loading the app UI after finishing fetching data from the database immediately if it isn't the first time to run the app
        await Navigator.pushReplacementNamed(context, HolderScreen.routeName);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Smart Wallet',
            style: TextStyle(
              color: kMainColor,
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
              color: kMainColor,
              size: 100,
              duration: Duration(seconds: 1),
            ),
          ),
        ],
      ),
    );
  }
}
