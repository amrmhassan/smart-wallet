// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/styles.dart';
import 'widgets/heading_calc_button.dart';
import 'widgets/math_operation_button.dart';
import 'widgets/number_button.dart';
import 'widgets/save_button.dart';

enum Operations {
  add,
  minus,
  multiply,
  divide,
}

//? you can add this widget into Expanded and remove the constrains in the parent container of this widget
class Calculator extends StatefulWidget {
  //? this function is responsible for setting the state of the parent widget of this widget
  //? to give it the result of the calculated results
  final VoidCallback saveTransaction;
  final Function(double result) setResults;

  const Calculator({
    Key? key,
    required this.saveTransaction,
    required this.setResults,
  }) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  //* this will hold the numbers that are currently clicked
  List<String> currentNumberList = [];
  //* this will hold the current operation
  Operations? currentOperation;

  //* this will hold the value of the number entered before an operation button is clicked
  double firstNumber = 0;

//* when clicking for the first time => i will set the numbers list to the numbers being clicked
//* when clicking an operation i will set the current operation and then set the first number to the current numbers list and clear the numbers list
//* when clicking another numbers i will keep the operation as it is i won't change it now cause i want to wait until the user finishes entering numbers
//* when clicking another operation i will replace it with the current operation then
//* making the calcRes to be firstNumber to be (+-*/) the double.parse(numbersString)
//* so now in the very first time to enter numbers ( there is no operation and there is no first number)
//* after first operation clicked there is operation and firstNumber
//* after this there will be always firstNumber and operation
//* the calculation will happen when clicking an operation button i will calculate the last firstNumber and the last operation and the currentNumbersList
//* finished integers calculating
//* next step is to add the double calculating and then change the calculator layout to have the equal button
//* the save button will be just an icon (save)
//* you can remove the percent button but wait ... you can use it as it is important in buying stuff
//* you can make it

//*---------------
//* i might need to add a small screen over the calculator and when clicking the equal button the result will be shown in the priceInput next to the title and the description

  void setcurrentNumberList(String value) {
    //* this will clear ensure that if the user clicked equal button then clicked a number without clicking an operation first to start over and clear the first number and start calculating from the start
    if (currentOperation == null && firstNumber != 0) {
      setState(() {
        firstNumber = 0;
      });
    }

    if (value == '.' && currentNumberList.contains('.')) {
      return;
    }

    if (currentNumberList.length == 1 && currentNumberList[0] == '0') {
      if (value == '0') {
        return;
      } else {
        currentNumberList.clear();
      }
    }

    setState(() {
      currentNumberList.add(value);
    });
  }

  void deleteCurrenOperation() {
    setState(() {
      currentOperation = null;
    });
  }

  //* this will be executed after clicking an operation button
  //* and i checks if it the first time to click an operation button or not
  //* to deal will the first number if it is there or not
  void setCurrentOperation(Operations operation) {
    if (firstNumber != 0 && currentOperation != null) {
      calculate();
    } else {
      //* this mean that it is the first time to press an operation button
      //* so i will clear the currentNumberList outside the current state cause i need something to be shown in the text screen(blueGrey)
      //* and i will set the firstNumber to the content of the currentNumberList
      if (currentNumberString != '0') {
        setState(() {
          firstNumber = double.parse(currentNumberString);
        });
      }
    }
    currentNumberList = [];
    //* then i will set the currentOparation to the operation
    setState(() {
      currentOperation = operation;
    });
  }

  String get currentNumberString {
    String viewedNumber = '';
    for (var element in currentNumberList) {
      viewedNumber += element.toString();
    }
    if (viewedNumber == '') {
      viewedNumber = '0';
    }
    return viewedNumber;
  }

//* this will only calculate the output of the firstNumber , operation, currentNumberlist
//* then changing the value of the calcRes

  void calculate() {
    if (currentOperation == null) {
      firstNumber == double.parse(currentNumberString);
      return;
    }
    if (currentOperation == Operations.add) {
      firstNumber = firstNumber + double.parse(currentNumberString);
    } else if (currentOperation == Operations.minus) {
      firstNumber = firstNumber - double.parse(currentNumberString);
    } else if (currentOperation == Operations.divide) {
      firstNumber = firstNumber / double.parse(currentNumberString);
    } else if (currentOperation == Operations.multiply) {
      firstNumber = firstNumber * double.parse(currentNumberString);
    }
    setState(() {
      currentNumberList = [];
    });
  }

  String get operationToString {
    if (currentOperation == Operations.add) {
      return '+';
    } else if (currentOperation == Operations.minus) {
      return '-';
    } else if (currentOperation == Operations.multiply) {
      return 'x';
    } else if (currentOperation == Operations.divide) {
      return '/';
    } else {
      return '';
    }
  }

  void calcPercent() {
    if (currentOperation == null) {
      return;
    }

    double temp = double.parse(currentNumberString);
    setState(() {
      if (currentOperation == Operations.add) {
        firstNumber = firstNumber + (temp / 100) * firstNumber;
      } else if (currentOperation == Operations.minus) {
        firstNumber = firstNumber - (temp / 100) * firstNumber;
      } else if (currentOperation == Operations.divide) {
        firstNumber = firstNumber / ((temp / 100) * firstNumber);
      } else if (currentOperation == Operations.multiply) {
        firstNumber = firstNumber * (temp / 100) * firstNumber;
      }
      currentOperation = null;
      currentNumberList.clear();
    });
  }

  //* this will deal with the empty list to view 0 instead of ' '
  String get currentNumberToView {
    return currentNumberString == '0' ? '' : currentNumberString;
  }

  //* this will remove the .0 from the firstNumber only to be viewed
  String get firstNumberToView {
    return firstNumber.toString().endsWith('.0')
        ? firstNumber.toString().replaceAll('.0', '')
        : firstNumber.toString();
  }

  String get output {
    //* this var will be viewed on the screen
    String value = '';

    if (firstNumber == 0) {
      value = currentNumberString;
    } else if (firstNumber != 0 &&
        currentOperation != null &&
        currentNumberList.isNotEmpty) {
      value = '$firstNumberToView $operationToString $currentNumberString';
    } else if (firstNumber != 0 && currentOperation != null) {
      value = '$firstNumberToView $operationToString';
    } else {
      value = firstNumberToView;
    }

    return value;
  }

  void clearAll() {
    currentOperation = null;
    firstNumber = 0;
    setState(() {
      // calcRes = 0;
      currentNumberList = [];
    });
  }

  void backspace() {
    setState(() {
      currentNumberList.removeLast();
    });
  }

  void sendResultToParent() {
    String result = '0';
    if (firstNumber == 0) {
      result = double.parse(currentNumberString).toStringAsFixed(2);
    } else {
      result = firstNumber.toStringAsFixed(2);
    }
    widget.setResults(double.parse(result));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(
      //   //? if you added this container into Expanded then remove this constrains
      //   maxHeight: 500,
      //   minHeight: 200,
      // ),
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: kDefaultPadding,
      ),
      padding: EdgeInsets.only(bottom: kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
        boxShadow: [kDefaultBoxShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
            alignment: Alignment.center,
            width: double.infinity,
            // height: 150,
            decoration: BoxDecoration(
              color: Colors.blueGrey[200],
            ),
            child: Text(
              output,
              style: kCalcTextStyle,
            ),
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          //? this row will have the heading buttons which will control the other operations and the divide button
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                      HeadingCalcButton(
                        calculate: (value) {
                          calcPercent();
                        },
                        iconData: Icons.percent,
                      ),
                      MathOperationBtn(
                        setOperation: (value) {
                          setCurrentOperation(Operations.divide);
                        },
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
                        calculate: setcurrentNumberList,
                        number: '7',
                      ),
                      NumberButton(
                        calculate: setcurrentNumberList,
                        number: '8',
                      ),
                      NumberButton(
                        calculate: setcurrentNumberList,
                        number: '9',
                      ),
                      //? search for the cross icon for the multiplication operation
                      MathOperationBtn(
                        setOperation: (value) {
                          setCurrentOperation(Operations.multiply);
                        },
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
                        calculate: setcurrentNumberList,
                        number: '4',
                      ),
                      NumberButton(
                        calculate: setcurrentNumberList,
                        number: '5',
                      ),
                      NumberButton(
                        calculate: setcurrentNumberList,
                        number: '6',
                      ),
                      //? search for the cross icon for the multiplication operation
                      MathOperationBtn(
                        setOperation: (value) {
                          setCurrentOperation(Operations.minus);
                        },
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
                        calculate: setcurrentNumberList,
                        number: '1',
                      ),
                      NumberButton(
                        calculate: setcurrentNumberList,
                        number: '2',
                      ),
                      NumberButton(
                        calculate: setcurrentNumberList,
                        number: '3',
                      ),
                      //? search for the cross icon for the multiplication operation
                      MathOperationBtn(
                        setOperation: setCurrentOperation,
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
                        calculate: setcurrentNumberList,
                        number: '.',
                      ),
                      NumberButton(
                        calculate: setcurrentNumberList,
                        number: '0',
                      ),

                      //? search for the cross icon for the multiplication operation
                      HeadingCalcButton(
                        //! these functions are still experimental
                        calculate: (String value) {
                          calculate();
                          sendResultToParent();
                          deleteCurrenOperation();
                        },
                        iconData: FontAwesomeIcons.equals,
                      ),
                      SaveButton(
                        onTap: () {
                          //! these functions are still experimental

                          calculate();
                          sendResultToParent();
                          deleteCurrenOperation();
                          widget.saveTransaction();
                        },
                      ),
                    ],
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
