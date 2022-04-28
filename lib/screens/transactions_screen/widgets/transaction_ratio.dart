import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/types.dart';

class TransactionRatio extends StatelessWidget {
  final double ratioToTotal;
  final TransactionType transactionType;
  final double? radius;

  const TransactionRatio(
      {Key? key,
      required this.ratioToTotal,
      required this.transactionType,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    const double defaultRadius = 50;

    return Container(
      alignment: Alignment.center,
      width: radius ?? defaultRadius,
      height: radius ?? defaultRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(
          width: 2,
          color: transactionType == TransactionType.income
              ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
              : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
        ),
        color: transactionType == TransactionType.income
            ? themeProvider.getThemeColor(ThemeColors.kIncomeColor).withOpacity(
                  ratioToTotal > 1 ? 1 : ratioToTotal,
                )
            : themeProvider
                .getThemeColor(ThemeColors.kOutcomeColor)
                .withOpacity(
                  ratioToTotal > 1 ? 1 : ratioToTotal,
                ),
      ),
      //* the small circular icon that represents the original color of the transaction type
      //* to make it easy to differentiate between colors
      child: Container(
        width: defaultRadius / 2,
        height: defaultRadius / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: transactionType == TransactionType.income
              ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
              : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
        ),
      ),
    );
  }
}
