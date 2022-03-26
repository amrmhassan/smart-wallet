// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';

import '../../widgets/app_bar/my_app_bar.dart';

import '../home_screen/widgets/background.dart';
import 'widgets/calculator_buttons_fixed.dart';

class CalculatorScreen extends StatefulWidget {
  static const String routeName = '/add-transaction-screen';
  //* to differentiate between adding new transaction and editting existing one

  const CalculatorScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double calcRes = 0;
  String get calcResBeatified {
    return calcRes.toString();
  }

  @override
  Widget build(BuildContext context) {
    //* this argument to inform this widget that i need to add a quick action not a transaction
    //* when needing to add a quick action i will add the argument to this with the argument:true like in the add_quick_action_button.dart file

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  MyAppBar(
                    title: 'Calculator',
                  ),
                  //* space between the app bar and the next widget
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      calcResBeatified,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: EdgeInsets.only(
                        bottom: kDefaultPadding,
                      ),
                      padding: EdgeInsets.all(kDefaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(kDefaultBorderRadius),
                        boxShadow: [kDefaultBoxShadow],
                      ),
                      child: CalculatorButtonsFixed(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
