// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//! how to make my own icons using adobe xd then change the icon of menu to be one dash and a half

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/profiles_provider.dart';
import '../../constants/sizes.dart';
import '../../constants/styles.dart';
import '../../providers/quick_actions_provider.dart';
import '../../screens/quick_actions_screen/quick_actions_screen.dart';
import '../../widgets/app_bar/home_heading.dart';

import '../../widgets/global/add_quick_action_button.dart';
import '../add_transaction_screen/add_transaction_screen.dart';
import 'widgets/profile_summary.dart';
import 'widgets/quick_actions_cards_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              HomeHeading(
                title: Provider.of<ProfilesProvider>(context)
                    .getActiveProfile
                    .name,
              ),
              //* this has the summery of the current active profile like (outcome, income of this day or month or year..., and the current total amount that currently exist in the profile)
              ProfileSummary(),
              if (Provider.of<QuickActionsProvider>(context)
                  .getFavoriteQuickActions
                  .isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: 10, left: 15),
                  width: double.infinity,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                        context, QuickActionsScreen.routeName),
                    child: Text(
                      'Quick Actions',
                      style: kParagraphTextStyle,
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
              //   padding: EdgeInsets.symmetric(
              //     horizontal: kDefaultPadding,
              //   ),
              //   child: Line(lineType: LineType.horizontal),
              // ),
              // //* this static height is to be added as a separator between the horizontal line and the quick actions cards
              // SizedBox(
              //   height: 20,
              // ),
              // //* these are the quick actions cards container

              QuickActionsCardsGrid(),
            ],
          ),
        ),

        //? this floating action button will be hidden when scrolling down
        //* floating action button for adding new quick action

        if (Provider.of<QuickActionsProvider>(context)
            .getFavoriteQuickActions
            .isNotEmpty)
          AddQuickActionButton(
            title: 'Add Quick Action',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AddTransactionScreen(
                    addTransactionScreenOperations:
                        AddTransactionScreenOperations.addQuickAction,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
