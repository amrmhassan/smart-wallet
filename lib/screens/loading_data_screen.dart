import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    //* i needed the trick of duration zero here
    //* here i will fetch and update the transactions
    Future.delayed(Duration.zero).then((value) async {
      //* start loading

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

      await Provider.of<QuickActionsProvider>(context, listen: false)
          .fetchAndUpdateQuickActions(activatedProfileId);
      //* loading the app UI after finishing fetching data from the database
      Navigator.pushNamed(context, HolderScreen.routeName);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Loading..',
        ),
      ),
    );
  }
}
