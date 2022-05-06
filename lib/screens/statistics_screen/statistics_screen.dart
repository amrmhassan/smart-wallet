// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/utils/statistics_provider.dart';
import 'package:smart_wallet/screens/profile_details_screen/profile_details_screen.dart';
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
  bool _loading = false;
  void handleOpenRichestProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ProfileDetailsScreen(
          profileId: Provider.of<ProfilesProvider>(context).highestProfile().id,
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      _loading = true;
    });
    List<ProfileModel> profiles =
        Provider.of<ProfilesProvider>(context, listen: false).profiles;
    await Provider.of<StatisticsProvider>(context, listen: false)
        .updateStatisticsData(profiles: profiles, context: context);

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var highestProfile =
        Provider.of<ProfilesProvider>(context).highestProfile();

    var statProvider = Provider.of<StatisticsProvider>(context, listen: false);

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
              StatisticsMoneySummary(
                statProvider: statProvider,
                loading: _loading,
              ),
              SizedBox(height: kDefaultPadding / 2),
              if (!(highestProfile.income == 0 && highestProfile.outcome == 0))
                GestureDetector(
                  onTap: handleOpenRichestProfile,
                  child: CustomCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Richest Profile',
                          style: themeProvider.getTextStyle(
                              ThemeTextStyles.kSmallInActiveParagraphTextStyle),
                        ),
                        SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                        Text(
                          Provider.of<ProfilesProvider>(context)
                              .highestProfile()
                              .name,
                          style: themeProvider.getTextStyle(
                              ThemeTextStyles.kParagraphTextStyle),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
