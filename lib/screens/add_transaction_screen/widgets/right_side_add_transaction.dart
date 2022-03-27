// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import 'add_transaction_type_button.dart';

class RightSideAddTransaction extends StatelessWidget {
  //* this is for controlling the transaction type
  final TransactionType currentActiveTransactionType;
  final Function(TransactionType transactionType)
      setCurrentActiveTransactionType;

//* for the price controller given by the parent
  final double amount;

  const RightSideAddTransaction({
    Key? key,
    required this.currentActiveTransactionType,
    required this.setCurrentActiveTransactionType,
    required this.amount,
  }) : super(key: key);

  String get amountToString {
    String value = amount.toString();
    if (value.endsWith('.0')) {
      value = amount.toString().replaceAll('.0', '');
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //* the padding next to the vertical line
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          //* the holder of the price and transaction type
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // * price container
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
                decoration: BoxDecoration(
                  color: kTextFieldInputColor,
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
                ),
                //* price text field
                child: FittedBox(
                  child: Text(
                    amountToString,
                    style: kCalcTextStyle,
                  ),
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              //* the transaction types holder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* outcome transaction button
                  AddTransactionTypeButton(
                    transactionType: TransactionType.outcome,
                    active:
                        currentActiveTransactionType == TransactionType.outcome,
                    onTap: setCurrentActiveTransactionType,
                  ),
                  const SizedBox(
                    width: kDefaultPadding / 2,
                  ),
                  //* income transaction button

                  AddTransactionTypeButton(
                    transactionType: TransactionType.income,
                    active:
                        currentActiveTransactionType == TransactionType.income,
                    onTap: setCurrentActiveTransactionType,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
