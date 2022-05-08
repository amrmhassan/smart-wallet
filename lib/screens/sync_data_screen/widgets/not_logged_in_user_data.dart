// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/data_card.dart';
import 'package:smart_wallet/screens/sync_data_screen/widgets/login_user_options.dart';

class NotLoggedInUserData extends StatefulWidget {
  final Future<void> Function() googleLogIn;
  final bool online;
  const NotLoggedInUserData({
    Key? key,
    required this.googleLogIn,
    required this.online,
  }) : super(key: key);

  @override
  State<NotLoggedInUserData> createState() => _NotLoggedInUserDataState();
}

class _NotLoggedInUserDataState extends State<NotLoggedInUserData> {
  late ProfilesProvider profilesProvider;
  late TransactionProvider transactionProvider;
  late QuickActionsProvider quickActionsProvider;
  late DebtsProvider debtsProvider;

  void fetchData() {
    profilesProvider = Provider.of<ProfilesProvider>(context, listen: false);
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    quickActionsProvider =
        Provider.of<QuickActionsProvider>(context, listen: false);

    debtsProvider = Provider.of<DebtsProvider>(context, listen: false);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LogInUserOptions(
          googleLogin: () async => await widget.googleLogIn(),
          // isOnline: online,
        ),
        SizedBox(
          height: kDefaultPadding,
        ),

        //* for showing the not synced data info
        DataCard(
          title: 'Not Synced Data',
          data: {
            'Profiles': profilesProvider.profiles.length,
            'Transactions': transactionProvider.transactions.length,
            'Quick Actions': quickActionsProvider.quickActions.length,
            'Debts': debtsProvider.debts.length,
          },
        ),
      ],
    );
  }
}
