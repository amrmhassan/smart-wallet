// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/login_user_options.dart';

class NotLoggedInUserData extends StatelessWidget {
  final Future<void> Function() googleLogIn;
  final bool online;
  const NotLoggedInUserData({
    Key? key,
    required this.profiles,
    required this.transactions,
    required this.quickActions,
    required this.googleLogIn,
    required this.online,
  }) : super(key: key);

  final List<ProfileModel> profiles;
  final List<TransactionModel> transactions;
  final List<QuickActionModel> quickActions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LogInUserOptions(
          googleLogin: () async => await googleLogIn(),
          // isOnline: online,
        ),
        SizedBox(
          height: kDefaultPadding,
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
      ],
    );
  }
}
