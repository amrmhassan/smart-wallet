// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/login_user_options.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/sync_data_button.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/user_info_viewer.dart';

class LoggedInUserData extends StatefulWidget {
  const LoggedInUserData({
    Key? key,
    required this.user,
    required this.profiles,
    required this.transactions,
    required this.quickActions,
  }) : super(key: key);

  final User user;
  final List<ProfileModel> profiles;
  final List<TransactionModel> transactions;
  final List<QuickActionModel> quickActions;

  @override
  State<LoggedInUserData> createState() => _LoggedInUserDataState();
}

class _LoggedInUserDataState extends State<LoggedInUserData> {
  bool _syncing = false;
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
        _syncing
            ? Text('Syncing')
            : SyncDataButton(
                onTap: () async {
                  try {
                    setState(() {
                      _syncing = true;
                    });
                    await Provider.of<SyncedDataProvider>(
                      context,
                      listen: false,
                    ).syncAllData();
                    setState(() {
                      _syncing = false;
                    });
                  } catch (error) {
                    if (kDebugMode) {
                      print(error.toString());
                    }
                  }
                },
              ),
        SizedBox(
          height: kDefaultPadding / 2,
        ),

        //* for showing the not synced data info
        DataCard(
          title: 'Not Synced Data',
          data: {
            'Profiles': widget.profiles.length,
            'Transactions': widget.transactions.length,
            'Quick Actions': widget.quickActions.length,
          },
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        //* for showing the synced data info
        DataCard(
          title: 'Synced Data',
          data: {
            'Profiles': 10,
            'Transactions': 53,
            'Quick Actions': 6,
          },
        ),
        SizedBox(
          height: kDefaultPadding,
        ),
        LogInUserOptions(),
      ],
    );
  }
}
