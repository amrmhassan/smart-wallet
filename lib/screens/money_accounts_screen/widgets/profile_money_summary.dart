import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../../constants/colors.dart';
import '../../../themes/choose_color_theme.dart';
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
    var themeProvider = Provider.of<ThemeProvider>(context);
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
            color: themeProvider.getThemeColor(ThemeColors.kIncomeColor),
          ),
          ProfileTransactionsInfo(
            title: 'Total Money',
            amount: totalMoneyString,
            color: themeProvider.getThemeColor(ThemeColors.kSavingsColor),
          ),
          ProfileTransactionsInfo(
            title: 'Outcome',
            amount: outcomeString,
            color: themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
          ),
        ],
      ),
    );
  }
}
