// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';
import 'package:smart_wallet/screens/holder_screen/widgets/testing_element.dart';

class TestingLengthsWidget extends StatelessWidget {
  const TestingLengthsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
      ),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          TestingElement(
            title: 'All Profiles',
            value: Provider.of<ProfilesProvider>(context).profiles.length,
          ),
          TestingElement(
            title: 'Active id',
            value: Provider.of<UserPrefsProvider>(context).activatedProfileId,
          ),
          ...Provider.of<ProfilesProvider>(context)
              .profiles
              .map((profile) => TestingElement(
                    title: profile.name,
                    value: profile.id,
                  ))
              .toList(),
          TestingElement(
            title: 'All Transactions',
            value:
                Provider.of<TransactionProvider>(context).transactions.length,
          ),
          TestingElement(
            title: 'All Quick Actions',
            value:
                Provider.of<QuickActionsProvider>(context).quickActions.length,
          ),
        ],
      ),
    );
  }
}
