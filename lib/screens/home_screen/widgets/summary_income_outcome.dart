// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/home_summary_model.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';

import '../../../constants/sizes.dart';
import 'profile_summary_element.dart';

//* this is to ensure that the money container won't exceed the specified height

class SummaryIncomeOutcome extends StatelessWidget {
  const SummaryIncomeOutcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPrefsProvider = Provider.of<UserPrefsProvider>(context);
    var first = userPrefsProvider.defaultHomeSummaryList[0];
    var second = userPrefsProvider.defaultHomeSummaryList[1];
    var third = userPrefsProvider.defaultHomeSummaryList[2];

    return Container(
      padding: EdgeInsets.only(
          left: kDefaultHorizontalPadding,
          right: kDefaultHorizontalPadding / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ProfileSummaryElement(
              title: first.name,
              amount: getAmountForHomeSummary(first.homeSummary, context),
              transactionType: first.transactionType,
              size: 20,
            ),
          ),
          Expanded(
            child: ProfileSummaryElement(
              title: second.name,
              amount: getAmountForHomeSummary(second.homeSummary, context),
              transactionType: second.transactionType,
              size: 18,
            ),
          ),
          Expanded(
            child: ProfileSummaryElement(
              title: third.name,
              amount: getAmountForHomeSummary(third.homeSummary, context),
              transactionType: third.transactionType,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}


// [
//           Expanded(
//             child: ProfileSummaryElement(
//               title: 'Today',
//               amount:
//                   transactionProvider.todayOutcome(userPrefsProvider.dayStart),
//               transactionType: TransactionType.outcome,
//               size: 20,
//             ),
//           ),
//           Expanded(
//             child: ProfileSummaryElement(
//               title: 'Yesterday',
//               amount: transactionProvider
//                   .yesterdayOutcome(userPrefsProvider.dayStart),
//               transactionType: TransactionType.outcome,
//               size: 18,
//             ),
//           ),
//           Expanded(
//             child: ProfileSummaryElement(
//               title: 'Savings',
//               amount: transactionProvider.totalMoney,
//               size: 16,
//             ),
//           ),
//         ]