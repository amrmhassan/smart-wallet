// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/statistics_provider.dart';

import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../home_screen/widgets/summary_period_container.dart';
import 'date_picker_button.dart';
import 'summary_element.dart';

class ProfileSummaryStatistics extends StatelessWidget {
  const ProfileSummaryStatistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var transactionData = Provider.of<StatisticsProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
        boxShadow: [
          kDefaultBoxShadow,
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryElement(
                  title: 'Income(${transactionData.incomeTransactions.length})',
                  amount: transactionData.totalIncome,
                  transactionType: TransactionType.income,
                ),
                SizedBox(
                  height: kDefaultPadding / 2,
                ),
                SummaryElement(
                  title:
                      'Outcome(${transactionData.outcomeTransactions.length})',
                  amount: transactionData.totalOutcome,
                  transactionType: TransactionType.outcome,
                ),
                SizedBox(
                  height: kDefaultPadding / 2,
                ),
                SummaryElement(
                  title: 'Total',
                  amount: transactionData.totalMoney,
                ),
                Expanded(
                  child: SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                ),
                Row(
                  children: [
                    DatePickerButton(
                      title: 'From',
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    DatePickerButton(
                      title: 'To',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: kDefaultPadding,
          ),
          SammeryPeriodContainer(),
        ],
      ),
    );
  }
}
