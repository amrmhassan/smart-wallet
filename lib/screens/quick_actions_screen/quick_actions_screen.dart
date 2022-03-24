// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/providers/quick_actions_provider.dart';
import 'package:wallet_app/screens/quick_actions_screen/widgets/all_quick_actions_card.dart';

import '../../constants/sizes.dart';
import '../../widgets/app_bar/my_app_bar.dart';
import '../add_transaction_screen/add_transaction_screen.dart';
import '../home_screen/widgets/background.dart';
import 'widgets/quick_actions_filter.dart';

class QuickActionsScreen extends StatefulWidget {
  static const String routeName = '/quick-actions-screen';
  const QuickActionsScreen({Key? key}) : super(key: key);

  @override
  State<QuickActionsScreen> createState() => _QuickActionsScreenState();
}

class _QuickActionsScreenState extends State<QuickActionsScreen> {
  @override
  Widget build(BuildContext context) {
    final quickActionsData = Provider.of<QuickActionsProvider>(context);
    final quickActions =
        quickActionsData.displayedQuickActions.reversed.toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        backgroundColor: kMainColor,
        child: Icon(
          Icons.add,
          size: kDefaultIconSize,
        ),
      ),
      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          //* this is the background of the screen
          Background(),

          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Column(
                children: [
                  //* my custom app bar and the mainAppBar is equal to false for adding the back button and remove the menu icon(side bar opener)
                  MyAppBar(
                    title: 'Quick Actions',
                  ),
                  //* space between the app bar and the next widget
                  SizedBox(
                    height: 40,
                  ),
                  //* quick actions filter
                  QuickActionsFilter(),
                  SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: quickActions.length,
                      itemBuilder: (ctx, index) =>
                          AllQuickActionsCard(quickAction: quickActions[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
