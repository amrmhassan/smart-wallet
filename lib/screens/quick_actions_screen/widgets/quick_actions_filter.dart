// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/quick_actions_provider.dart';

import '../../../constants/sizes.dart';
import '../../../constants/types.dart';
import 'quick_actions_filter_button.dart';

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

class QuickActionsFilter extends StatelessWidget {
  const QuickActionsFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quickActionsData = Provider.of<QuickActionsProvider>(context);
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _transactionsFilters
            .map(
              (e) => QuickActionsFilterButton(
                title: e['title'],
                onTap: () =>
                    quickActionsData.setcurrentActiveQuickActionType(e['type']),
                active:
                    quickActionsData.currentActiveQuickActionType == e['type'],
              ),
            )
            .toList(),
      ),
    );
  }
}
