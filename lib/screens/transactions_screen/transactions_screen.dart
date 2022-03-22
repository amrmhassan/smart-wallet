// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/models/transaction_model.dart';
import 'package:wallet_app/providers/transactions_provider.dart';
import 'package:wallet_app/widgets/app_bar/home_heading.dart';

import 'widgets/transaction_card.dart';
import 'widgets/transactions_filters.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    //* i needed the trick of duration zero here
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<TransactionProvider>(context, listen: false)
            .fetchAndUpdateTransactions());
  }

//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    List<TransactionModel> _transactions = Provider.of<TransactionProvider>(
      context,
    ).displayedTransactions;

    return Stack(
      children: [
        Column(
          children: [
            HomeHeading(
              title: 'Transactions',
            ),
            TransactionsFilters(),
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.only(
                  top: kDefaultHorizontalPadding,
                  right: kDefaultPadding / 2,
                  left: kDefaultPadding / 2,
                  bottom: bottomNavBarHeight,
                ),
                decoration: BoxDecoration(),
                child: _transactions.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        itemCount: _transactions.length,
                        itemBuilder: (ctx, index) => TranscationCard(
                          transaction: _transactions[index],
                        ),
                      )
                    : Column(
                        children: [
                          // Text(
                          //   'No Transaction Here',
                          //   style: TextStyle(
                          //     color: kMainColor.withOpacity(0.8),
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 22,
                          //   ),
                          // ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          SizedBox(
                            width: 300,
                            child: Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/icons/empty.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
        //* this is the bottom nav bar that has all 5 main tabs
      ],
    );
  }
}
