// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/screens/transactions_screen/widgets/choose_transaction_type_button.dart';

class ChartTypesFilter extends StatelessWidget {
  final CustomChartType activeChartType;
  final void Function(CustomChartType chartType) setActiveChartType;

  const ChartTypesFilter({
    Key? key,
    required this.activeChartType,
    required this.setActiveChartType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ChooseTransactionTypeButton(
          title: 'Savings',
          onTap: () => setActiveChartType(CustomChartType.savings),
          active: activeChartType == CustomChartType.savings,
          transactionType: TransactionType.all,
        ),
        ChooseTransactionTypeButton(
          title: 'Income',
          onTap: () => setActiveChartType(CustomChartType.income),
          active: activeChartType == CustomChartType.income,
          transactionType: TransactionType.income,
        ),
        ChooseTransactionTypeButton(
          title: 'Outcome',
          onTap: () => setActiveChartType(CustomChartType.outcome),
          active: activeChartType == CustomChartType.outcome,
          transactionType: TransactionType.outcome,
        ),
      ],
    );
  }
}
