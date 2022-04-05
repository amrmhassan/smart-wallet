import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';

import '../../../constants/colors.dart';
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
                ? kIncomeColor
                : transactionType == TransactionType.outcome
                    ? kOutcomeColor
                    : kMainColor,
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
                ? kIncomeColor
                : transactionType == TransactionType.outcome
                    ? kOutcomeColor
                    : kMainColor,
          ),
        ),
      ],
    );
  }
}
