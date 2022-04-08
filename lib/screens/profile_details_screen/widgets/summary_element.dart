import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

import '../../../constants/sizes.dart';
import '../../../constants/types.dart';
import '../../../utils/general_utils.dart';

class SummaryElement extends StatelessWidget {
  final String title;
  final double amount;
  final TransactionType? transactionType;

  const SummaryElement({
    Key? key,
    required this.amount,
    required this.title,
    this.transactionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    String stringAmount = doubleToString(amount) + ' $currency';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: transactionType == TransactionType.income
                ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
                : transactionType == TransactionType.outcome
                    ? themeProvider.getThemeColor(ThemeColors.kOutcomeColor)
                    : themeProvider.getThemeColor(ThemeColors.kSavingsColor),
          ),
        ),
        const SizedBox(
          width: kDefaultPadding,
        ),
        Text(
          stringAmount,
          style: TextStyle(
            fontSize: 16,
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
