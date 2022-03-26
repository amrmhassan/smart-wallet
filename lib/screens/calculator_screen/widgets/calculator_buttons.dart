// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallet_app/screens/calculator_screen/calculator_screen.dart';
import 'package:wallet_app/screens/calculator_screen/widgets/save_button.dart';

import 'heading_calc_button.dart';
import 'math_operation_button.dart';
import 'number_button.dart';

class CalculatorButtons extends StatelessWidget {
  const CalculatorButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //? this row will have the heading buttons which will control the other operations and the divide button
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
            HeadingCalcButton(
              calculate: (value) {},
              iconData: Icons.percent,
            ),
            MathOperationBtn(
              setOperation: (value) {},
              iconData: FontAwesomeIcons.divide,
              operation: Operations.divide,
            ),
          ],
        ),
        //? this will have 7, 8, 9 and the multiplication button
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
            NumberButton(
              calculate: (value) {},
              number: '9',
            ),
            //? search for the cross icon for the multiplication operation
            MathOperationBtn(
              setOperation: (value) {},
              title: 'x',
              operation: Operations.multiply,
            ),
          ],
        ),
        //? this will have 4, 5 , 6, and the minus icon
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
            NumberButton(
              calculate: (value) {},
              number: '6',
            ),
            //? search for the cross icon for the multiplication operation
            MathOperationBtn(
              setOperation: (value) {},
              iconData: FontAwesomeIcons.minus,
              operation: Operations.minus,
            ),
          ],
        ),
        //? this will have 1, 2, 3, and plus icon
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
            NumberButton(
              calculate: (value) {},
              number: '3',
            ),
            //? search for the cross icon for the multiplication operation
            MathOperationBtn(
              setOperation: (value) {},
              iconData: FontAwesomeIcons.plus,
              operation: Operations.add,
            ),
          ],
        ),
        //? this will have the dot , zero and save button
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

            //? search for the cross icon for the multiplication operation
            SaveButton(
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
