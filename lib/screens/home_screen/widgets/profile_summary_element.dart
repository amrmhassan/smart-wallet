import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: transactionType == null
                ? kMainColor
                : transactionType == TransactionType.income
                    ? kIncomeColor
                    : kOutcomeColor,
            fontWeight: FontWeight.bold,
            fontSize: size,
          ),
        ),
        Expanded(
          child: Text(
            '${doubleToString(amount)} $currency',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: transactionType == null
                  ? kMainColor
                  : transactionType == TransactionType.income
                      ? kIncomeColor
                      : kOutcomeColor,
              fontWeight: FontWeight.bold,
              fontSize: size,
            ),
          ),
        ),
      ],
    );
  }
}