// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/screens/statistics_screen/widgets/statistics_main_summary_item.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class StatisticsMoneySummary extends StatelessWidget {
  const StatisticsMoneySummary({
    Key? key,
    required this.profilesData,
  }) : super(key: key);

  final ProfilesProvider profilesData;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          StatisticsMainSummaryItem(
            title: 'Total Money',
            amount: profilesData.getTotalMoney(),
            transactionType: TransactionType.all,
          ),
          SizedBox(height: kDefaultPadding / 2),
          StatisticsMainSummaryItem(
            title: 'Total Income',
            amount: profilesData.getTotalIncome(),
            transactionType: TransactionType.income,
          ),
          SizedBox(height: kDefaultPadding / 2),
          StatisticsMainSummaryItem(
            title: 'Total Outcome',
            amount: profilesData.getTotalOutcome(),
            transactionType: TransactionType.outcome,
          ),
        ],
      ),
    );
  }
}
