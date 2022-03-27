import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/types.dart';
import '../../../providers/transactions_provider.dart';

import '../../../constants/sizes.dart';
import 'choose_transaction_type_button.dart';

const List<Map<String, dynamic>> _transactionsFilters = [
  {
    'title': 'All',
    'type': TransactionType.all,
  },
  {
    'title': 'Income',
    'type': TransactionType.income,
  },
  {
    'title': 'Outcome',
    'type': TransactionType.outcome,
  },
];

class TransactionsFilters extends StatelessWidget {
  const TransactionsFilters({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionData = Provider.of<TransactionProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _transactionsFilters.map((e) {
          return ChooseTransactionTypeButton(
            title: e['title'],
            onTap: () {
              transactionData.setCurrentActiveTransactionType(e['type']);
            },
            active: transactionData.currentActiveTransactionType == e['type'],
          );
        }).toList(),
      ),
    );
  }
}
