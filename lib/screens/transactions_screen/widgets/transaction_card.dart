import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/transactions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../../models/transaction_model.dart';
import '../../../utils/transactions_utils.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import '../../../widgets/global/card_action_button.dart';

class TranscationCard extends StatelessWidget {
  final TransactionModel transaction;
  const TranscationCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  void deleteTransaction(BuildContext context) async {
    try {
      await Provider.of<TransactionProvider>(context, listen: false)
          .deleteTransaction(transaction.id);
    } catch (error) {
      showSnackBar(context, error.toString(), SnackBarType.error);
    }
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
              Text(
                transaction.title,
                style: kParagraphTextStyle,
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
                  onTap: () => deleteTransaction(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
