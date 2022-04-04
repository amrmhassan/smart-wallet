// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/providers/profiles_provider.dart';
import 'package:wallet_app/providers/transactions_provider.dart';
import 'package:wallet_app/widgets/app_bar/home_heading.dart';
import '../../constants/sizes.dart';
import '../home_screen/widgets/summary_period_container.dart';
import 'widgets/date_picker_button.dart';
import 'widgets/summary_chart.dart';
import 'widgets/summary_element.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
//* this is the build method of this widget

  @override
  Widget build(BuildContext context) {
    var transactionData = Provider.of<TransactionProvider>(context);
    //* the main container of the home screen
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: Provider.of<ProfilesProvider>(context)
                    .getActiveProfile
                    .name,
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              ProfileSummaryStatistics(transactionData: transactionData),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: SummaryChart(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//! the user will choose form presets durations in the right column
//! or from  a custom duration in the bottom
//! when the user checks the box in the bottom the right periods will be inactive and the bottom will be active
//?  another method
//! their will be a variable duration from , to
//! when the day is clicked the from will be today and to will be today
//! week is clicked , from will be (today-7 days) to will be today the same will be for month and a year

//! when there is no dates for a week only the day will be active and etc

class ProfileSummaryStatistics extends StatelessWidget {
  const ProfileSummaryStatistics({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  final TransactionProvider transactionData;

  @override
  Widget build(BuildContext context) {
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
        boxShadow: [kDefaultBoxShadow],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryElement(
                  title: 'Income',
                  amount: transactionData.totalIncome,
                  transactionType: TransactionType.income,
                ),
                SizedBox(
                  height: kDefaultPadding / 2,
                ),
                SummaryElement(
                  title: 'Outcome',
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
