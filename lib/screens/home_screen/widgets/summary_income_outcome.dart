import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import '../../../providers/transactions_provider.dart';

import '../../../constants/sizes.dart';
import 'profile_summary_element.dart';

//* this is to ensure that the money container won't exceed the specified height

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
            Expanded(
              child: ProfileSummaryElement(
                title: 'Today',
                amount: transactionData.todayOutcome,
                transactionType: TransactionType.outcome,
                size: 20,
              ),
            ),
            Expanded(
              child: ProfileSummaryElement(
                title: 'Yesterday',
                amount: transactionData.yesterdayOutcome,
                transactionType: TransactionType.outcome,
                size: 18,
              ),
            ),
            Expanded(
              child: ProfileSummaryElement(
                title: 'Savings',
                amount: transactionData.totalMoney,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
