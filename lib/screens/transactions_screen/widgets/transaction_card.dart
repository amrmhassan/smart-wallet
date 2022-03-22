import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/transactions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../../models/transaction_model.dart';
import '../../../utils/transactions_utils.dart';
import 'transaction_action_button.dart';

class TranscationCard extends StatelessWidget {
  final TransactionModel transaction;
  const TranscationCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: transaction.transactionType == TransactionType.income
                  ? kIncomeColor.withOpacity(transaction.ratioToTotal)
                  : kOutcomeColor.withOpacity(transaction.ratioToTotal),
            ),
          ),
          const SizedBox(
            width: kDefaultPadding / 3,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: kParagraphTextStyle,
              ),
              const SizedBox(
                height: kDefaultPadding / 4,
              ),
              Text(
                '${doubleToString(transaction.amount)} \$',
                style: kSmallTextPrimaryColorStyle,
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TransactionActionButton(
                  iconData: FontAwesomeIcons.pen,
                  color: kMainColor,
                  onTap: () {},
                ),
                const SizedBox(
                  width: kDefaultPadding / 4,
                ),
                TransactionActionButton(
                  iconData: FontAwesomeIcons.trash,
                  color: kDeleteColor,
                  onTap: () {
                    Provider.of<TransactionProvider>(context, listen: false)
                        .deleteTransaction(transaction.id);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
