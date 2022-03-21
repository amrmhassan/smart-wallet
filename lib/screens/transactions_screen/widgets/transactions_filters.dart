import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import 'choose_transaction_type_button.dart';

class TransactionsFilters extends StatelessWidget {
  final Function(int index) setActiveIcon;
  final int activeIconIndex;

  const TransactionsFilters({
    Key? key,
    required this.setActiveIcon,
    required this.activeIconIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ChooseTransactionTypeButton(
            title: 'All',
            onTap: () {
              setActiveIcon(0);
            },
            active: activeIconIndex == 0,
          ),
          ChooseTransactionTypeButton(
            title: 'Income',
            onTap: () {
              setActiveIcon(1);
            },
            active: activeIconIndex == 1,
          ),
          ChooseTransactionTypeButton(
            title: 'Outcome',
            onTap: () {
              setActiveIcon(2);
            },
            active: activeIconIndex == 2,
          ),
        ],
      ),
    );
  }
}
