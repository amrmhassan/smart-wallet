import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/utils/general_utils.dart';

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
            fontSize: 16,
            fontWeight: transactionType == TransactionType.all
                ? FontWeight.bold
                : FontWeight.w400,
            color: transactionType == TransactionType.income
                ? themeProvider
                    .getThemeColor(ThemeColors.kIncomeColor)
                    .withOpacity(0.6)
                : transactionType == TransactionType.outcome
                    ? themeProvider
                        .getThemeColor(ThemeColors.kOutcomeColor)
                        .withOpacity(0.6)
                    : themeProvider.getThemeColor(ThemeColors.kSavingsColor),
          ),
        ),
        Text(
          '${doubleToString(amount)} $currency',
          style: TextStyle(
            fontSize: 16,
            fontWeight: transactionType == TransactionType.all
                ? FontWeight.bold
                : FontWeight.w400,
            color: transactionType == TransactionType.income
                ? themeProvider
                    .getThemeColor(ThemeColors.kIncomeColor)
                    .withOpacity(0.6)
                : transactionType == TransactionType.outcome
                    ? themeProvider
                        .getThemeColor(ThemeColors.kOutcomeColor)
                        .withOpacity(0.6)
                    : themeProvider.getThemeColor(ThemeColors.kSavingsColor),
          ),
        ),
      ],
    );
  }
}
