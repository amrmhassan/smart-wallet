import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';
import '../../../constants/types.dart';

class AddTransactionTypeButton extends StatelessWidget {
  final bool active;
  final TransactionType transactionType;
  final Function(TransactionType transactionType) onTap;

  const AddTransactionTypeButton({
    Key? key,
    required this.transactionType,
    required this.active,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () => onTap(transactionType),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: !active
              ? Border.all(
                  width: 1.5,
                  color: themeProvider.getThemeColor(ThemeColors.kMainColor))
              : null,
          color: active && transactionType == TransactionType.income
              ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
              : active && transactionType == TransactionType.outcome
                  ? themeProvider.getThemeColor(ThemeColors.kOutcomeColor)
                  : null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          transactionType == TransactionType.outcome
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: active
              ? Colors.white
              : themeProvider.getThemeColor(ThemeColors.kMainColor),
          size: kDefaultIconSize,
        ),
      ),
    );
  }
}
