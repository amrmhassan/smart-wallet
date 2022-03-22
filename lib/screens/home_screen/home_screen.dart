// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//! how to make my own icons using adobe xd then change the icon of menu to be one dash and a half

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/widgets/app_bar/home_heading.dart';

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
    return Stack(
      children: [
        //* this is the main content of the home screen in the safe area
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: 'Current Profile Name',
              ),
              //* this has the summery of the current active profile like (outcome, income of this day or month or year..., and the current total amount that currently exist in the profile)
              ProfileSummary(),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 15),
                width: double.infinity,
                child: Text(
                  'Quick Actions',
                  style: kParagraphTextStyle,
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
        //* this is the bottom nav bar that has all 5 main tabs
      ],
    );
  }
}
