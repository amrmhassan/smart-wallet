// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/screens/calculator_screen/calculator_screen.dart';
import 'package:wallet_app/screens/calculator_screen/widgets/save_button.dart';

import 'heading_calc_button.dart';
import 'math_operation_button.dart';
import 'number_button.dart';

class CalculatorButtonsFixed extends StatelessWidget {
  final Function(String value) setCurrentNumber;
  final Function(Operations value) setCurrentOperation;
  final VoidCallback clearAll;
  final VoidCallback calculate;
  final VoidCallback deleteCurrenOperation;

  const CalculatorButtonsFixed({
    Key? key,
    required this.setCurrentNumber,
    required this.setCurrentOperation,
    required this.clearAll,
    required this.calculate,
    required this.deleteCurrenOperation,
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
                    calculate: (value) {
                      clearAll();
                    },
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
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '7',
                  ),
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '8',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '4',
                  ),
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '5',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '1',
                  ),
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '2',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '.',
                  ),
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
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
                    setOperation: (value) {
                      setCurrentOperation(value);
                    },
                    iconData: FontAwesomeIcons.divide,
                    operation: Operations.divide,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '9',
                  ),
                  MathOperationBtn(
                    setOperation: (value) {
                      setCurrentOperation(value);
                    },
                    operation: Operations.multiply,
                    title: 'x',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '6',
                  ),
                  MathOperationBtn(
                    setOperation: (value) {
                      setCurrentOperation(value);
                    },
                    operation: Operations.minus,
                    iconData: FontAwesomeIcons.minus,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumberButton(
                    calculate: (value) {
                      setCurrentNumber(value);
                    },
                    number: '3',
                  ),
                  MathOperationBtn(
                    setOperation: (value) {
                      setCurrentOperation(value);
                    },
                    iconData: FontAwesomeIcons.plus,
                    operation: Operations.add,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: SaveButton(
                      onTap: () {
                        calculate();
                        deleteCurrenOperation();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
