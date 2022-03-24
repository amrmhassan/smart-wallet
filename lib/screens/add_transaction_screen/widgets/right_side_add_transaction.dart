import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/types.dart';
import '../../../widgets/global/stylized_text_field.dart';
import 'add_transaction_type_button.dart';

class RightSideAddTransaction extends StatelessWidget {
  //* this is for controlling the transaction type
  final TransactionType currentActiveTransactionType;
  final Function(TransactionType transactionType)
      setCurrentActiveTransactionType;

//* for the price controller given by the parent
  final TextEditingController priceController;

  const RightSideAddTransaction({
    Key? key,
    required this.currentActiveTransactionType,
    required this.setCurrentActiveTransactionType,
    required this.priceController,
  }) : super(key: key);

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
                //* price text field
                child: StylizedTextField(
                  controller: priceController,
                  hintText: '0,0',
                  onChanged: (value) {},
                  keyboardType: TextInputType.number,
                  fillColor: kTextFieldInputColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
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
