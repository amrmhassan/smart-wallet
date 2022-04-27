// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/logged_in_user_data.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/logout_button.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/not_logged_in_user_data.dart';
import 'package:smart_wallet/utils/general_utils.dart';
import 'package:smart_wallet/utils/synced_data_utils.dart';
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
  bool _loggingIn = false;
  bool _loggingOut = false;
  bool _isOnline = false;

  void toggleLogin() {
    setState(() {
      _loggingIn = !_loggingIn;
    });
  }

  void toggleLogOut() {
    setState(() {
      _loggingOut = !_loggingOut;
    });
  }

  Future<void> handleGoogleLogIn() async {
    setState(() {
      _loggingIn = true;
    });

    try {
      bool online = await isOnline();
      if (!online) {
        CustomError.log('network_error', null, true);
      }
      await googleLogin(context);
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
      try {
        showSnackBar(
          context,
          CustomError.beautifyError(error),
          SnackBarType.error,
        );
        Provider.of<AuthenticationProvider>(context, listen: false)
            .setUserPhoto(null);
        await handleDeleteUserPhoto();
      } catch (error, stackTrace) {
        CustomError.log(error: error, stackTrace: stackTrace);
      }
    }
    setState(() {
      _loggingIn = false;
    });
  }

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
    bool online = await isOnline();
    setState(() {
      _isOnline = online;
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfilesProvider>(context);
    var transactionProvider = Provider.of<TransactionProvider>(context);
    var quickActionsProvider = Provider.of<QuickActionsProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
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
          ? Container(
              color:
                  themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
              child: Center(
                  child: SpinKitCubeGrid(
                color: themeProvider.getThemeColor(ThemeColors.kMainColor),
                size: 100,
                duration: Duration(seconds: 1),
              )),
            )
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
                                title: _loggingIn
                                    ? 'Syncing ...'
                                    : 'Cloud Syncing',
                                enableTapping: false,
                                rightIcon: snapshot.hasData
                                    ? LogOutButton(
                                        logOut: () async {
                                          setState(() {
                                            _loggingOut = true;
                                          });
                                          await logOut(context);
                                          setState(() {
                                            _loggingOut = false;
                                          });
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: kDefaultPadding,
                            ),
                            StreamBuilder(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if ((snapshot.hasData ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) &&
                                    snapshot.data != null) {
                                  User user = snapshot.data as User;

                                  return LoggedInUserData(
                                    online: _isOnline,
                                    user: user,
                                    profiles: profileProvider,
                                    transactions: transactionProvider,
                                    quickActions: quickActionsProvider,
                                    googleLogIn: handleGoogleLogIn,
                                  );
                                } else {
                                  return NotLoggedInUserData(
                                    profiles: profileProvider.notSyncedProfiles,
                                    transactions: transactionProvider
                                        .notSyncedTransactions,
                                    quickActions: quickActionsProvider
                                        .notSyncedQuickActions,
                                    googleLogIn: handleGoogleLogIn,
                                    online: _isOnline,
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
