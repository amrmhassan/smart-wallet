// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/utils/general_utils.dart';

import '../../constants/sizes.dart';
import '../../widgets/app_bar/home_heading.dart';
import '../../widgets/global/custom_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    var profilesData = Provider.of<ProfilesProvider>(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: 'Statistics',
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              StatisticsMoneySummary(profilesData: profilesData),
              SizedBox(height: kDefaultPadding / 2),
              CustomCard(
                child: Text('The hight profile with total money will be here '),
              ),
              SizedBox(height: kDefaultPadding / 2),
              CustomCard(child: Text('total debts will be here')),
            ],
          ),
        ),
      ],
    );
  }
}

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

class StatisticsMainSummaryItem extends StatelessWidget {
  final String title;
  final double amount;
  final TransactionType transactionType;

  const StatisticsMainSummaryItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.transactionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight:
                transactionType == TransactionType.all ? FontWeight.bold : null,
            color: transactionType == TransactionType.income
                ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
                : transactionType == TransactionType.outcome
                    ? themeProvider.getThemeColor(ThemeColors.kOutcomeColor)
                    : themeProvider.getThemeColor(ThemeColors.kSavingsColor),
          ),
        ),
        Text(
          '${doubleToString(amount)} $currency',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
                transactionType == TransactionType.all ? FontWeight.bold : null,
            color: transactionType == TransactionType.income
                ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
                : transactionType == TransactionType.outcome
                    ? themeProvider.getThemeColor(ThemeColors.kOutcomeColor)
                    : themeProvider.getThemeColor(ThemeColors.kSavingsColor),
          ),
        ),
      ],
    );
  }
}
