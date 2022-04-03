// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import 'widgets/summary_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
//* this is the build method of this widget

  @override
  Widget build(BuildContext context) {
    //* the main container of the home screen
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              SizedBox(
                height: 300,
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
