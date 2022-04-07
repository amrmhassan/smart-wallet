import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../themes/choose_color_theme.dart';
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
    return GestureDetector(
      onTap: () => onTap(transactionType),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: !active
              ? Border.all(width: 1.5, color: ChooseColorTheme.kMainColor)
              : null,
          color: active && transactionType == TransactionType.income
              ? kIncomeColor
              : active && transactionType == TransactionType.outcome
                  ? kOutcomeColor
                  : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          transactionType == TransactionType.outcome
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: active ? Colors.white : ChooseColorTheme.kMainColor,
          size: kDefaultIconSize,
        ),
      ),
    );
  }
}
