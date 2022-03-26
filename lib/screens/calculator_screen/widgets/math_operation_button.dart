// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/helpers/responsive.dart';
import 'package:wallet_app/screens/calculator_screen/calculator_screen.dart';

class MathOperationBtn extends StatelessWidget {
  final IconData? iconData;
  final String? title;
  final Operations operation;

  final Function(Operations value) setOperation;

  const MathOperationBtn({
    Key? key,
    this.title,
    this.iconData,
    required this.setOperation,
    required this.operation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      width: Responsive.getWidth(context) / 7,
      height: Responsive.getWidth(context) / 7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          1000,
        ),
        border: Border.all(width: 1, color: kMainColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setOperation(operation);
          },
          child: Container(
            alignment: Alignment.center,
            child: iconData == null
                ? Text(
                    title as String,
                    style: kCalcTextStyle,
                  )
                : Icon(
                    iconData,
                    color: kMainColor,
                    size: kMediumIconSize,
                  ),
          ),
        ),
      ),
    );
  }
}
