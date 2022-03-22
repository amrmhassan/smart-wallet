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
                padding: EdgeInsets.symmetric(
                  vertical: kDefaultHorizontalPadding,
                  horizontal: kDefaultPadding / 2,
                ),
                decoration: BoxDecoration(),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemCount: _transactions.length,
                  itemBuilder: (ctx, index) => TranscationCard(
                    transaction: _transactions[index],
                  ),
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

class TranscationCard extends StatelessWidget {
  final TransactionModel transaction;
  const TranscationCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: kDefaultPadding / 2),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding / 2,
        vertical: kDefaultVerticalPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        boxShadow: [kIconBoxShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: transaction.transactionType == TransactionType.income
                  ? kIncomeColor.withOpacity(transaction.ratioToTotal)
                  : kOutcomeColor.withOpacity(transaction.ratioToTotal),
            ),
          ),
          SizedBox(
            width: kDefaultPadding / 3,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.title,
                style: kParagraphTextStyle,
              ),
              SizedBox(
                height: kDefaultPadding / 4,
              ),
              Text(
                '${transaction.amount.toStringAsFixed(2)} \$',
                style: kSmallTextPrimaryColorStyle,
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TransactionActionButton(
                  iconData: FontAwesomeIcons.pen,
                  color: kMainColor,
                  onTap: () {},
                ),
                SizedBox(
                  width: kDefaultPadding / 4,
                ),
                TransactionActionButton(
                  iconData: FontAwesomeIcons.trash,
                  color: kDeleteColor,
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TransactionActionButton extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  const TransactionActionButton({
    Key? key,
    required this.color,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(
            1000,
          ),
        ),
        child: Icon(
          iconData,
          size: kUltraSmallIconSize,
          color: color,
        ),
      ),
    );
  }
}
