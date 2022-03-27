// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';
import 'package:wallet_app/helpers/responsive.dart';

class NumberButton extends StatelessWidget {
  final String number;
  final Function(String value) calculate;

  const NumberButton({
    Key? key,
    required this.calculate,
    required this.number,
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
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: kMainColor.withOpacity(0.2),
            blurRadius: 6,
          )
        ],
        borderRadius: BorderRadius.circular(
          kDefaultBorderRadius / 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            calculate(number);
          },
          child: Container(
              alignment: Alignment.center,
              child: Text(
                number,
                style: kCalcTextStyle,
              )),
        ),
      ),
    );
  }
}
