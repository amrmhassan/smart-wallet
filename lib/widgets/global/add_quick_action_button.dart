// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../constants/styles.dart';
import '../../screens/add_transaction_screen/add_transaction_screen.dart';

class AddQuickActionButton extends StatelessWidget {
  const AddQuickActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomNavBarHeight + 10,
      right: 20,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            boxShadow: [kCardHeavyBoxShadow],
            color: kMainColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                kDefaultBorderRadius * 5,
              ),
              topRight: Radius.circular(
                kDefaultBorderRadius * 5,
              ),
              bottomRight: Radius.circular(
                kDefaultBorderRadius * 5,
              ),
            )),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AddTransactionScreen(
                      addTransactionScreenOperations:
                          AddTransactionScreenOperations.addQuickAction),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultHorizontalPadding / 1.5,
                vertical: kDefaultVerticalPadding / 1.2,
              ),
              child: const Text(
                'Add Quick Action',
                style: kSmallTextWhiteColorStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
