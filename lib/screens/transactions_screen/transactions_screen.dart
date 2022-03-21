// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/widgets/app_bar/home_heading.dart';

import 'widgets/transactions_filters.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _activeIconIndex = 0;

  void _setActiveIcon(int index) {
    setState(() {
      _activeIconIndex = index;
    });
  }

//* this is the build method of this widget
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Column(
            children: [
              HomeHeading(
                title: 'Transactions',
              ),
              TransactionsFilters(
                setActiveIcon: _setActiveIcon,
                activeIconIndex: _activeIconIndex,
              ),
            ],
          ),
        ),
        //* this is the bottom nav bar that has all 5 main tabs
      ],
    );
  }
}
