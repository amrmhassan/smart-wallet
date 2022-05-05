// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/screens/transactions_screen/widgets/transaction_ratio.dart';
import 'package:smart_wallet/utils/transactions_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';
import '../../../constants/types.dart';
import '../../../models/transaction_model.dart';
import '../../../utils/general_utils.dart';

class TransactionDetailsModal extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailsModal({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DateFormat formatter = DateFormat('yyyy-MM-dd, E   hh:mm a');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultBorderRadius),
          topRight: Radius.circular(kDefaultBorderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TransactionRatio(
                ratioToTotal: transaction.ratioToTotal,
                transactionType: transaction.transactionType,
              ),
              SizedBox(
                width: kDefaultPadding / 2,
              ),
              Expanded(
                child: Text(
                  transaction.title,
                  style: themeProvider
                      .getTextStyle(ThemeTextStyles.kHeadingTextStyle),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: kDefaultPadding,
              ),
              Text(
                '${doubleToString(transaction.amount)} $currency',
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
              )
            ],
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 10)),
                lastDate: DateTime.now(),
              );
              if (pickedDate == null) {
                return;
              }

              TransactionModel newTransaction = TransactionModel(
                id: transaction.id,
                title: transaction.title,
                description: transaction.description,
                amount: transaction.amount,
                createdAt: pickedDate,
                transactionType: transaction.transactionType,
                ratioToTotal: transaction.ratioToTotal,
                profileId: transaction.profileId,
              );
              await Provider.of<TransactionProvider>(context, listen: false)
                  .editTransaction(newTransaction: newTransaction);
              Navigator.pop(context);
              showSnackBar(context, 'Date edited', SnackBarType.info);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color:
                      themeProvider.getThemeColor(ThemeColors.kInactiveColor),
                  size: kSmallIconSize,
                ),
                SizedBox(
                  width: kDefaultPadding / 4,
                ),
                Text(
                  formatter.format(transaction.createdAt),
                  style: themeProvider.getTextStyle(
                      ThemeTextStyles.kSmallInActiveParagraphTextStyle),
                ),
              ],
            ),
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  transaction.description,
                  style: themeProvider.getTextStyle(
                    ThemeTextStyles.kMediumTextPrimaryColorStyle,
                  ),
                  softWrap: true,
                  maxLines: 10,
                ),
              ),
            ],
          ),
          SizedBox(
            height: kDefaultPadding,
          )
        ],
      ),
    );
  }
}
