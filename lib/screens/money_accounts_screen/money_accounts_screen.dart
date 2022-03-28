// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import '../../widgets/app_bar/home_heading.dart';
import '../../widgets/global/add_quick_action_button.dart';
import 'widgets/profiles_grid.dart';

class MoneyAccountsScreen extends StatefulWidget {
  const MoneyAccountsScreen({Key? key}) : super(key: key);

  @override
  State<MoneyAccountsScreen> createState() => _MoneyAccountsScreenState();
}

class _MoneyAccountsScreenState extends State<MoneyAccountsScreen> {
//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    //* the main container of the money accounts screen
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          children: [
            HomeHeading(
              title: 'Money Accounts',
            ),
            SizedBox(
              height: kDefaultPadding,
            ),
            Expanded(
              child: ProfilesGrid(),
            ),
          ],
        ),
        //? i will add an add button here
        // AddQuickActionButton(),
      ],
    );
  }
}
