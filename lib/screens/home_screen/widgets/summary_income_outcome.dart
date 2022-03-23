// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/transactions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../utils/transactions_utils.dart';

class SummaryIncomeOutcome extends StatelessWidget {
  const SummaryIncomeOutcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionData = Provider.of<TransactionProvider>(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${doubleToString(transactionData.totalIncome)} \$',
                  style: TextStyle(
                    color: kIncomeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: kDefaultHeadingTextSize,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  FontAwesomeIcons.arrowDown,
                  color: kIncomeColor,
                  size: kDefaultIconSize - 5,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${doubleToString(transactionData.totalOutcome)} \$',
                  style: TextStyle(
                    color: kOutcomeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: kDefaultHeadingTextSize,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  FontAwesomeIcons.arrowUp,
                  color: kOutcomeColor,
                  size: kDefaultIconSize - 5,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
