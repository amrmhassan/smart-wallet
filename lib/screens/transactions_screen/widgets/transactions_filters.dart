import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import 'choose_transaction_type_button.dart';

const List<String> _transactionsFilters = ['All', 'Income', 'Outcome'];

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
        children: _transactionsFilters.map((e) {
          int index = _transactionsFilters.indexOf(e);
          return ChooseTransactionTypeButton(
            title: e,
            onTap: () {
              setActiveIcon(index);
            },
            active: activeIconIndex == index,
          );
        }).toList(),
      ),
    );
  }
}
