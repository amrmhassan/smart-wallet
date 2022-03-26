// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/screens/calculator_screen/widgets/save_button.dart';

import 'heading_calc_button.dart';
import 'math_operation_button.dart';
import 'number_button.dart';

class CalculatorButtonsFixed extends StatelessWidget {
  const CalculatorButtonsFixed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeadingCalcButton(
                    calculate: (value) {},
                    title: 'C',
                  ),
                  HeadingCalcButton(
                    calculate: (value) {},
                    iconData: Icons.backspace,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {},
                    number: '7',
                  ),
                  NumberButton(
                    calculate: (value) {},
                    number: '8',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {},
                    number: '4',
                  ),
                  NumberButton(
                    calculate: (value) {},
                    number: '5',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {},
                    number: '1',
                  ),
                  NumberButton(
                    calculate: (value) {},
                    number: '2',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {},
                    number: '.',
                  ),
                  NumberButton(
                    calculate: (value) {},
                    number: '0',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: kDefaultPadding,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeadingCalcButton(
                    calculate: (value) {},
                    iconData: Icons.percent,
                  ),
                  MathOperationBtn(
                    calculate: (value) {},
                    iconData: FontAwesomeIcons.divide,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {},
                    number: '9',
                  ),
                  MathOperationBtn(
                    calculate: (value) {},
                    title: 'x',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {},
                    number: '6',
                  ),
                  MathOperationBtn(
                    calculate: (value) {},
                    iconData: FontAwesomeIcons.minus,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {},
                    number: '3',
                  ),
                  MathOperationBtn(
                    calculate: (value) {},
                    iconData: FontAwesomeIcons.plus,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: SaveButton(
                    onTap: () {},
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
