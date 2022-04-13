// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
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

class LoggedInUserData extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        //* for showing the user info (picture and a name)
        UserInfoViewer(
          photoUrl: user.photoURL,
          userName: user.displayName,
          userEmail: user.email,
        ),

        SizedBox(
          height: kDefaultPadding,
        ),
        SyncDataButton(
          onTap: () async {
            await Provider.of<SyncedDataProvider>(
              context,
              listen: false,
            ).syncAllData();
          },
        ),
        SizedBox(
          height: kDefaultPadding / 2,
        ),

        //* for showing the not synced data info
        DataCard(
          title: 'Not Synced Data',
          data: {
            'Profiles': profiles.length,
            'Transactions': transactions.length,
            'Quick Actions': quickActions.length,
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
