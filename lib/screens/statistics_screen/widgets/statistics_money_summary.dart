// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/utils/statistics_provider.dart';
import 'package:smart_wallet/screens/statistics_screen/widgets/statistics_main_summary_item.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

class StatisticsMoneySummary extends StatelessWidget {
  const StatisticsMoneySummary({
    Key? key,
    required this.statProvider,
    required this.loading,
  }) : super(key: key);

  final StatisticsProvider statProvider;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return CustomCard(
      child: loading
          ? Text(
              'Loading data',
              style: themeProvider
                  .getTextStyle(ThemeTextStyles.kParagraphTextStyle),
            )
          : Column(
              children: [
                StatisticsMainSummaryItem(
                  title: 'Total Money',
                  amount: statProvider.totalMoney,
                  transactionType: TransactionType.all,
                ),
                SizedBox(height: kDefaultPadding / 2),
                StatisticsMainSummaryItem(
                  title: 'Total Income',
                  amount: statProvider.income,
                  transactionType: TransactionType.income,
                ),
                SizedBox(height: kDefaultPadding / 2),
                StatisticsMainSummaryItem(
                  title: 'Total Outcome',
                  amount: statProvider.outcome,
                  transactionType: TransactionType.outcome,
                ),
              ],
            ),
    );
  }
}
