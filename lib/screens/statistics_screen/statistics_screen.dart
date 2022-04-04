// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/profiles_provider.dart';
import 'package:wallet_app/providers/statistics_provider.dart';
import 'package:wallet_app/widgets/app_bar/home_heading.dart';
import '../../constants/sizes.dart';
import 'widgets/profile_summary_statistics.dart';
import 'widgets/summary_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Future<void> updatingTheTransactions() async {
    return Future.delayed(Duration.zero).then((value) {
      //* for initializing the viewed transactions of the statistics page
      Provider.of<StatisticsProvider>(context, listen: false)
          .fetchAndUpdateViewedTransactions();
    });
  }

//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    //* this is for updating the transactions that will be used for creating statistics
    updatingTheTransactions();

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
              ProfileSummaryStatistics(),
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

