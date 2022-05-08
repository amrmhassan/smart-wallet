// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';
import '../../../providers/transactions_provider.dart';

import '../../../constants/sizes.dart';
import 'profile_summary_element.dart';

//* this is to ensure that the money container won't exceed the specified height

class SummaryIncomeOutcome extends StatelessWidget {
  const SummaryIncomeOutcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionData = Provider.of<TransactionProvider>(context);
    final userPrefsProvider = Provider.of<UserPrefsProvider>(context);
    return Container(
      padding: EdgeInsets.only(
          left: kDefaultHorizontalPadding,
          right: kDefaultHorizontalPadding / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ProfileSummaryElement(
              title: 'Today',
              amount: transactionData.todayOutcome(userPrefsProvider.dayStart),
              transactionType: TransactionType.outcome,
              size: 20,
            ),
          ),
          Expanded(
            child: ProfileSummaryElement(
              title: 'Yesterday',
              amount:
                  transactionData.yesterdayOutcome(userPrefsProvider.dayStart),
              transactionType: TransactionType.outcome,
              size: 18,
            ),
          ),
          Expanded(
            child: ProfileSummaryElement(
              title: 'Savings',
              amount: transactionData.totalMoney,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
