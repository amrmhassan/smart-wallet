// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/responsive.dart';
import 'package:smart_wallet/screens/quick_actions_screen/widgets/all_quick_actions_card.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';
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
        try {
          await deleteTransaction(context, transaction);
          confirmDelete = true;
        } catch (error, stackTrace) {
          CustomError.log(error: error, stackTrace: stackTrace);
          showSnackBar(context, error.toString(), SnackBarType.error);
          confirmDelete = false;
        }
      },
    ).show();

    return confirmDelete;
  }

  void handleOpenTransactionDetails(
    BuildContext context,
    TransactionModel transaction,
  ) async {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DateFormat formatter = DateFormat('yyyy-MM-dd, E   hh:mm a');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                  style: themeProvider.getTextStyle(
                      ThemeTextStyles.kSmallTextPrimaryColorStyle),
                )
              ],
            ),
            SizedBox(
              height: kDefaultPadding / 2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showSnackBar(context, 'Open editing data page, or date picker',
                    SnackBarType.info);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    //* the main container of the card
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDeleteCustomDialog(context),
      background: QuickActionCardBackground(),
      child: GestureDetector(
        onTap: () => handleOpenTransactionDetails(context, transaction),
        child: CustomCard(
          margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding / 2,
            vertical: kDefaultVerticalPadding / 2,
          ),

          //* the row that hold the main components of the card, ( circular leading, title buttons etc...)
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //* circular icon that represent the transaction type and its ratio to the total of the time the transaction added
              //* and have the border radius and the background color
              TransactionRatio(
                ratioToTotal: transaction.ratioToTotal,
                transactionType: transaction.transactionType,
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
                      style: themeProvider
                          .getTextStyle(ThemeTextStyles.kParagraphTextStyle),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 4,
                  ),
                  //* price text widget
                  Text(
                    '${doubleToString(transaction.amount)} $currency',
                    style: themeProvider.getTextStyle(
                        ThemeTextStyles.kSmallTextPrimaryColorStyle),
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
                      color:
                          themeProvider.getThemeColor(ThemeColors.kMainColor),
                      backgroundColor: themeProvider
                          .getThemeColor(ThemeColors.kMainBackgroundColor),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => AddTransactionScreen(
                              addTransactionScreenOperations:
                                  AddTransactionScreenOperations
                                      .editTransaction,
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
                    // CardActionButton(
                    //   iconData: FontAwesomeIcons.trash,
                    //   color:
                    //       themeProvider.getThemeColor(ThemeColors.kDeleteColor),
                    //   backgroundColor: themeProvider
                    //       .getThemeColor(ThemeColors.kMainBackgroundColor),
                    //   //? here i need to show dialog before actually deleting a transaction
                    //   onTap: () => showDeleteCustomDialog(context),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionRatio extends StatelessWidget {
  final double ratioToTotal;
  final TransactionType transactionType;
  final double? radius;

  const TransactionRatio(
      {Key? key,
      required this.ratioToTotal,
      required this.transactionType,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    const double defaultRadius = 50;

    return Container(
      alignment: Alignment.center,
      width: radius ?? defaultRadius,
      height: radius ?? defaultRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(
          width: 2,
          color: transactionType == TransactionType.income
              ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
              : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
        ),
        color: transactionType == TransactionType.income
            ? themeProvider.getThemeColor(ThemeColors.kIncomeColor).withOpacity(
                  ratioToTotal > 1 ? 1 : ratioToTotal,
                )
            : themeProvider
                .getThemeColor(ThemeColors.kOutcomeColor)
                .withOpacity(
                  ratioToTotal > 1 ? 1 : ratioToTotal,
                ),
      ),
      //* the small circular icon that represents the original color of the transaction type
      //* to make it easy to differentiate between colors
      child: Container(
        width: defaultRadius / 2,
        height: defaultRadius / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: transactionType == TransactionType.income
              ? themeProvider.getThemeColor(ThemeColors.kIncomeColor)
              : themeProvider.getThemeColor(ThemeColors.kOutcomeColor),
        ),
      ),
    );
  }
}
