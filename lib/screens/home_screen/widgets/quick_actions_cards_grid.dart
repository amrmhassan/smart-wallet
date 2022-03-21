// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import '../../../constants/types.dart';
import 'quick_action_card.dart';

const List<Map<String, dynamic>> _demoQuickActions = [
  {
    'title': 'This is a title',
    'desc': 'This is a description, of the quick action',
    'amount': 52,
    'type': TransactionType.income,
  },
  {
    'title': 'This is a title',
    'desc': 'This is a description, of the quick action',
    'amount': 52,
    'type': TransactionType.outcome,
  },
  {
    'title': 'This is a title',
    'desc': 'This is a description, of the quick action',
    'amount': 55.66,
    'type': TransactionType.outcome,
  },
  {
    'title': 'This is a title',
    'desc': 'This is a description, of the quick action',
    'amount': 52,
    'type': TransactionType.income,
  },
  {
    'title': 'This is a title',
    'desc': 'This is a description, of the quick action',
    'amount': 4578.3,
    'type': TransactionType.income,
  },
];

class QuickActionsCardsGrid extends StatelessWidget {
  const QuickActionsCardsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(),
        padding: const EdgeInsets.only(
          bottom: bottomNavBarHeight + kDefaultPadding / 4,
          right: kDefaultPadding / 4,
          left: kDefaultPadding / 4,
          top: kDefaultPadding / 4,
        ),
        child: GridView.builder(
            clipBehavior: Clip.none,
            //* this is so impressive for adding a different animation to the scrolling effect
            physics: BouncingScrollPhysics(),
            //? SOLVED
            //* this is a problem :: when making the clip none the cards overflow the grid and get out of it
            //* when it is hards edges the shadow of the cards gets cut and look bad
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: kDefaultPadding / 2,
              mainAxisSpacing: kDefaultPadding / 2,
              childAspectRatio: 1,
            ),
            itemCount: _demoQuickActions.length,
            itemBuilder: (ctx, index) {
              return QuickActionCard(
                amount: _demoQuickActions[index]['amount'].toString(),
                title: _demoQuickActions[index]['title'],
                description: _demoQuickActions[index]['desc'],
                transactionType: _demoQuickActions[index]['type'],
              );
            }),
      ),
    );
  }
}
