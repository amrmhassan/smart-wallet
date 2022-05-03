// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import '../../constants/sizes.dart';
import '../../providers/quick_actions_provider.dart';
import '../../providers/theme_provider.dart';
import '../../screens/quick_actions_screen/quick_actions_screen.dart';
import '../../widgets/app_bar/home_heading.dart';

import 'widgets/profile_summary.dart';
import 'widgets/quick_actions_cards_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProfileModel activeProfile;
  @override
  void initState() {
    activeProfile = Provider.of<ProfilesProvider>(context, listen: false)
        .getActiveProfile();

    super.initState();
  }

//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    //* the main container of the home screen
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: activeProfile.name,
              ),
              SizedBox(height: kDefaultPadding),
              //* this has the summery of the current active profile like (outcome, income of this day or month or year..., and the current total amount that currently exist in the profile)
              if (true) const ProfileSummary(),
              SizedBox(height: kDefaultPadding / 2),

              if (Provider.of<QuickActionsProvider>(context)
                  .getFavoriteQuickActions
                  .isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 10, left: 15),
                  width: double.infinity,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                        context, QuickActionsScreen.routeName),
                    child: Text(
                      'Quick Actions',
                      style: themeProvider
                          .getTextStyle(ThemeTextStyles.kParagraphTextStyle),
                    ),
                  ),
                ),
              //? i commeted all of these but it is optional
              //* this height is added as a separator between the profile summary and the horizontal line
              // SizedBox(
              //   height: 20,
              // ),
              // //* this is a horizontal line to be added between the profile summary and the quick Actions cards
              // Container(
              //   padding:const EdgeInsets.symmetric(
              //     horizontal: kDefaultPadding,
              //   ),
              //   child: Line(lineType: LineType.horizontal),
              // ),
              // //* this static height is to be added as a separator between the horizontal line and the quick actions cards
              // SizedBox(
              //   height: 20,
              // ),
              // //* these are the quick actions cards container

              const QuickActionsCardsGrid(),
            ],
          ),
        ),
      ],
    );
  }
}
