// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/logged_in_user_data.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/logout_button.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/not_logged_in_user_data.dart';
import '../../constants/sizes.dart';

import '../../widgets/app_bar/my_app_bar.dart';
import '../home_screen/widgets/background.dart';

class SyncDataScreen extends StatefulWidget {
  static const String routeName = '/sync-data-screen';

  const SyncDataScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SyncDataScreen> createState() => _SyncDataScreenState();
}

class _SyncDataScreenState extends State<SyncDataScreen> {
  bool _loading = false;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    setState(() {
      _loading = true;
    });
    // //? 6] fetching all the transactions
    await Provider.of<TransactionProvider>(context, listen: false)
        .fetchAndUpdateAllTransactions();

    // //? 7] fetching all  quick actions
    await Provider.of<QuickActionsProvider>(context, listen: false)
        .fetchAndUpdateAllQuickActions();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var profiles = Provider.of<ProfilesProvider>(context).profiles;
    var transactionProvider = Provider.of<TransactionProvider>(context);
    var quickActionsProvider = Provider.of<QuickActionsProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,

      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      //? this gesture detector will remove the focus whenever anything else is clicked in the screen
      body: _loading
          ? Text('Loading')
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: [
                  //* this is the background of the screen
                  const Background(),

                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding / 2),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (ctx, snapshot) => MyAppBar(
                                title: 'Sync Data',
                                enableTapping: false,
                                rightIcon:
                                    snapshot.hasData ? LogOutButton() : null,
                              ),
                            ),
                            SizedBox(
                              height: kDefaultPadding,
                            ),
                            StreamBuilder(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  //! a glitch occurs here when start syncing the data it start rendering that widget(Text)
                                  return Text('Loading');
                                } else if (snapshot.hasError) {
                                  return Text('Error');
                                } else if (snapshot.hasData) {
                                  User user = snapshot.data as User;

                                  return LoggedInUserData(
                                    user: user,
                                    profiles: profiles,
                                    transactions: transactionProvider
                                        .notSyncedTransactions,
                                    quickActions: quickActionsProvider
                                        .notSyncedQuickActions,
                                  );
                                } else {
                                  return NotLoggedInUserData(
                                    profiles: profiles,
                                    transactions: transactionProvider
                                        .notSyncedTransactions,
                                    quickActions: quickActionsProvider
                                        .notSyncedQuickActions,
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: kDefaultPadding,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
