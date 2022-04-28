// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/statistics_screen/widgets/statistics_money_summary.dart';

import '../../constants/sizes.dart';
import '../../widgets/app_bar/home_heading.dart';
import '../../widgets/global/custom_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    var profilesData = Provider.of<ProfilesProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: 'Statistics',
              ),
              SizedBox(
                height: kDefaultPadding,
              ),
              StatisticsMoneySummary(profilesData: profilesData),
              SizedBox(height: kDefaultPadding / 2),
              CustomCard(
                child: Text(
                  'The highest profile with total money will be here ',
                  style: themeProvider.getTextStyle(
                      ThemeTextStyles.kSmallInActiveParagraphTextStyle),
                ),
              ),
              SizedBox(height: kDefaultPadding / 2),
              CustomCard(
                  child: Text('total debts will be here',
                      style: themeProvider.getTextStyle(
                          ThemeTextStyles.kSmallInActiveParagraphTextStyle))),
            ],
          ),
        ),
      ],
    );
  }
}
