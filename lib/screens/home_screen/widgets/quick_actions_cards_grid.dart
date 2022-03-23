// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/quick_actions_provider.dart';
import 'package:wallet_app/providers/transactions_provider.dart';
import 'package:wallet_app/widgets/global/empty_transactions.dart';

import '../../../constants/sizes.dart';
import '../../../models/transaction_model.dart';
import 'quick_action_card.dart';

class QuickActionsCardsGrid extends StatelessWidget {
  const QuickActionsCardsGrid({
    Key? key,
  }) : super(key: key);

//* in this method i will apply the quick action and add the transaction by clicking on the quick action card
  void applyQuickAction(BuildContext context, TransactionModel quickAction) {
    //? the problem here is that each quick action will have an id , so we can't add the same quick action with the same id to be multiple transactions with the same id
    //? so i will make the add transaction provider decide the id of the newly added transaction
    Provider.of<TransactionProvider>(context, listen: false).addTransaction(
      quickAction.title,
      quickAction.description,
      quickAction.amount,
      quickAction.transactionType,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TransactionModel> quickActions =
        Provider.of<QuickActionsProvider>(context).getAllQuickActions;

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
        child: quickActions.isEmpty
            ? EmptyTransactions(
                title: 'No Quick Actions',
              )
            : GridView.builder(
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
                itemCount: quickActions.length,
                itemBuilder: (ctx, index) {
                  return QuickActionCard(
                    //* i tried 1.00 to convert it to a double
                    amount: quickActions[index].amount * 1.00,
                    title: quickActions[index].title,
                    description: quickActions[index].description,
                    transactionType: quickActions[index].transactionType,
                    onTap: () => applyQuickAction(context, quickActions[index]),
                  );
                }),
      ),
    );
  }
}
