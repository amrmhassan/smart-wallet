import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants/sizes.dart';

import '../calculator.dart';
import 'heading_calc_button.dart';
import 'math_operation_button.dart';
import 'number_button.dart';
import 'save_button.dart';

class CalculatorButtonsFixed extends StatelessWidget {
  final Function(String value) setCurrentNumber;
  final Function(Operations value) setCurrentOperation;
  final VoidCallback clearAll;
  final VoidCallback calculate;
  final VoidCallback deleteCurrenOperation;
  final VoidCallback backspace;
  final VoidCallback calcPercent;

  const CalculatorButtonsFixed({
    Key? key,
    required this.setCurrentNumber,
    required this.setCurrentOperation,
    required this.clearAll,
    required this.calculate,
    required this.deleteCurrenOperation,
    required this.backspace,
    required this.calcPercent,
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
                    calculate: (value) {
                      backspace();
                    },
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
        const SizedBox(
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
                    calculate: (value) {
                      calcPercent();
                    },
                    iconData: Icons.percent,
                  ),
                  MathOperationBtn(
                    setOperation: setCurrentOperation,
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
                    setOperation: setCurrentOperation,
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
                    setOperation: setCurrentOperation,
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
                    setOperation: setCurrentOperation,
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
