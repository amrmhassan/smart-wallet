import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/sizes.dart';
import '../../models/transaction_model.dart';
import '../../providers/transactions_provider.dart';
import '../../widgets/app_bar/home_heading.dart';
import '../../widgets/global/empty_transactions.dart';

import 'widgets/transaction_card.dart';
import 'widgets/transactions_filters.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    List<TransactionModel> _transactions = Provider.of<TransactionProvider>(
      context,
    ).displayedTransactions.reversed.toList();

    return Stack(
      children: [
        Column(
          children: [
            const HomeHeading(
              title: 'Transactions',
            ),
            const TransactionsFilters(),
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.only(
                  top: kDefaultHorizontalPadding,
                  right: kDefaultPadding / 2,
                  left: kDefaultPadding / 2,
                  bottom: kCustomBottomNavBarHeight,
                ),
                decoration: const BoxDecoration(),
                child: _transactions.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        itemCount: _transactions.length,
                        itemBuilder: (ctx, index) => TranscationCard(
                          transaction: _transactions[index],
                        ),
                      )
                    : const EmptyTransactions(),
              ),
            ),
          ],
        ),
        //* this is the bottom nav bar that has all 5 main tabs
      ],
    );
  }
}
