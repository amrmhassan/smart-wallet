// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallet_app/helpers/responsive.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../../models/transaction_model.dart';
import '../../../utils/general_utils.dart';
import '../../../utils/transactions_utils.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import '../../../widgets/global/card_action_button.dart';

class TranscationCard extends StatelessWidget {
  final TransactionModel transaction;

  const TranscationCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  Future<bool> showDeleteCustomDialog(BuildContext context) async {
    bool confirmDelete = false;
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete Transaction?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        deleteTransaction(context, transaction);
        confirmDelete = true;
      },
    ).show();

    return confirmDelete;
  }

  @override
  Widget build(BuildContext context) {
    //* the main container of the card
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding / 2,
        vertical: kDefaultVerticalPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        boxShadow: [
          kCardBoxShadow,
        ],
      ),
      //* the row that hold the main components of the card, ( circular leading, title buttons etc...)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //* circular icon that represent the transaction type and its ratio to the total of the time the transaction added
          //* and have the border radius and the background color
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(
                width: 2,
                color: transaction.transactionType == TransactionType.income
                    ? kIncomeColor
                    : kOutcomeColor,
              ),
              color: transaction.transactionType == TransactionType.income
                  ? kIncomeColor.withOpacity(transaction.ratioToTotal > 1
                      ? 1
                      : transaction.ratioToTotal)
                  : kOutcomeColor.withOpacity(transaction.ratioToTotal > 1
                      ? 1
                      : transaction.ratioToTotal),
            ),
            //* the small circular icon that represents the original color of the transaction type
            //* to make it easy to differentiate between colors
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: transaction.transactionType == TransactionType.income
                    ? kIncomeColor
                    : kOutcomeColor,
              ),
            ),
          ),
          const SizedBox(
            width: kDefaultPadding / 3,
          ),
          //* title and price column
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* title text widget
              //* i made this sizedbox trick to make the text take a definite width and prevent overflow of the text
              SizedBox(
                width: Responsive.getWidth(context) / 3,
                child: Text(
                  transaction.title,
                  style: kParagraphTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: kDefaultPadding / 4,
              ),
              //* price text widget
              Text(
                '${doubleToString(transaction.amount)} \$',
                style: kSmallTextPrimaryColorStyle,
              ),
            ],
          ),
          Expanded(
            //* the container of the actions button
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //* for opening the screen to edit the transactions
                CardActionButton(
                  iconData: FontAwesomeIcons.pen,
                  color: kMainColor,
                  backgroundColor: Colors.grey[100],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => AddTransactionScreen(
                          addTransactionScreenOperations:
                              AddTransactionScreenOperations.editTransaction,
                          editingId: transaction.id,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: kDefaultPadding / 4,
                ),
                //* for deleting a transactions
                CardActionButton(
                  iconData: FontAwesomeIcons.trash,
                  color: kDeleteColor,
                  backgroundColor: Colors.grey[100],
                  //? here i need to show dialog before actually deleting a transaction
                  onTap: () => showDeleteCustomDialog(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
