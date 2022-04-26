// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/login_user_options.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/sync_data_button.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/user_info_viewer.dart';

class LoggedInUserData extends StatefulWidget {
  final User user;
  final ProfilesProvider profiles;
  final TransactionProvider transactions;
  final QuickActionsProvider quickActions;
  final Future<void> Function() googleLogIn;
  final bool online;

  const LoggedInUserData({
    Key? key,
    required this.user,
    required this.profiles,
    required this.transactions,
    required this.quickActions,
    required this.googleLogIn,
    required this.online,
  }) : super(key: key);

  @override
  State<LoggedInUserData> createState() => _LoggedInUserDataState();
}

class _LoggedInUserDataState extends State<LoggedInUserData> {
  bool _syncing = false;

  Future syncData(BuildContext context) async {
    try {
      setState(() {
        _syncing = true;
      });

      var profileProvider =
          Provider.of<ProfilesProvider>(context, listen: false);
      var transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      var quickActionsProvider =
          Provider.of<QuickActionsProvider>(context, listen: false);

      await Provider.of<SyncedDataProvider>(
        context,
        listen: false,
      ).syncAllData(
        profileProvider,
        transactionProvider,
        quickActionsProvider,
      );

      await Provider.of<TransactionProvider>(context, listen: false)
          .fetchAndUpdateAllTransactions();
      await Provider.of<QuickActionsProvider>(context, listen: false)
          .fetchAndUpdateAllQuickActions();
      setState(() {
        _syncing = false;
      });
    } catch (error) {
      CustomError.log(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        //* for showing the user info (picture and a name)
        UserInfoViewer(
          photoUrl: widget.user.photoURL,
          userName: widget.user.displayName,
          userEmail: widget.user.email,
        ),

        SizedBox(
          height: kDefaultPadding,
        ),

        SyncDataButton(
          onTap: () async => await syncData(context),
          syncing: _syncing,
          online: widget.online,
        ),

        SizedBox(
          height: kDefaultPadding / 2,
        ),

        //* for showing the not synced data info
        DataCard(
          title: 'Not Synced Data',
          data: {
            'Profiles': widget.profiles.notSyncedProfiles.length,
            'Transactions': widget.transactions.notSyncedTransactions.length,
            'Quick Actions': widget.quickActions.notSyncedQuickActions.length,
          },
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        //* for showing the synced data info
        DataCard(
          title: 'All Data',
          data: {
            'Profiles': widget.profiles.profiles.length,
            'Transactions': widget.transactions.allTransactions.length,
            'Quick Actions': widget.quickActions.allQuickActions.length,
          },
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        //! implement this button and then fix the error with it
        LogInUserOptions(
          googleLogin: () async => await widget.googleLogIn(),
          // isOnline: widget.online,
        ),
      ],
    );
  }
}
