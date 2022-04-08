import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../../constants/globals.dart';
import '../../../constants/types.dart';
import '../../../utils/general_utils.dart';

class ProfileSummaryElement extends StatelessWidget {
  final String title;
  final double amount;
  final TransactionType? transactionType;
  final double size;

  const ProfileSummaryElement({
    Key? key,
    required this.title,
    required this.amount,
    this.transactionType,
    this.size = 18,
  }) : super(key: key);

  String amountString(String amount) {
    if (amount == '0') {
      return '0';
    } else if (transactionType == TransactionType.outcome) {
      return '-$amount';
    } else {
      return amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: transactionType == null
                ? themeProvider.getThemeColor(ThemeColors.kSavingsColor)
                : transactionType == TransactionType.income
                    ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
                    : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
            fontWeight: FontWeight.bold,
            fontSize: size,
          ),
        ),
        Expanded(
          child: Text(
            '${amountString(doubleToString(amount))} $currency',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: transactionType == null
                  ? themeProvider.getThemeColor(ThemeColors.kSavingsColor)
                  : transactionType == TransactionType.income
                      ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
                      : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
              fontWeight: FontWeight.bold,
              fontSize: size,
            ),
          ),
        ),
      ],
    );
  }
}
