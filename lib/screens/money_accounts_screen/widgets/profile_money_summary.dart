import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import 'profile_transactions_info.dart';

class ProfileMoneySummary extends StatelessWidget {
  final double income;
  final double outcome;
  final double totalMoney;

  const ProfileMoneySummary({
    Key? key,
    required this.income,
    required this.outcome,
    required this.totalMoney,
  }) : super(key: key);

  String get incomeString {
    return income.toStringAsFixed(0);
  }

  String get outcomeString {
    return outcome.toStringAsFixed(0);
  }

  String get totalMoneyString {
    return totalMoney.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileTransactionsInfo(
            title: 'Income',
            amount: incomeString,
            color: kIncomeColor,
          ),
          ProfileTransactionsInfo(
            title: 'Total Money',
            amount: totalMoneyString,
            color: kMainColor,
          ),
          ProfileTransactionsInfo(
            title: 'Outcome',
            amount: outcomeString,
            color: kOutcomeColor,
          ),
        ],
      ),
    );
  }
}
