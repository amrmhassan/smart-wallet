import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/models/quick_action_model.dart';
import 'package:wallet_app/providers/quick_actions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../../utils/transactions_utils.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import '../../../widgets/global/card_action_button.dart';

class AllQuickActionsCard extends StatelessWidget {
  final QuickActionModel quickAction;
  const AllQuickActionsCard({
    Key? key,
    required this.quickAction,
  }) : super(key: key);

  void deleteQuickAction(BuildContext context) async {
    try {
      await Provider.of<QuickActionsProvider>(context, listen: false)
          .deleteQuickActions(quickAction.id);
    } catch (error) {
      showSnackBar(context, error.toString(), SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    //* the main container of the card
    return Dismissible(
      key: Key(quickAction.id),
      onDismissed: (direction) {},
      child: Container(
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
        //* the row that hold the main components of the card, ( circular leading icon, title buttons etc...)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //* transaction type icon
            Container(
              alignment: Alignment.center,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  width: 2,
                  color: quickAction.transactionType == TransactionType.income
                      ? kIncomeColor
                      : kOutcomeColor,
                ),
              ),
              child: Icon(
                quickAction.transactionType == TransactionType.income
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: quickAction.transactionType == TransactionType.income
                    ? kIncomeColor
                    : kOutcomeColor,
                size: kDefaultIconSize,
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
                  quickAction.title,
                  style: kParagraphTextStyle,
                ),
                const SizedBox(
                  height: kDefaultPadding / 4,
                ),
                //* price text widget
                Text(
                  '${doubleToString(quickAction.amount)} \$',
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => AddTransactionScreen(
                            addTransactionScreenOperations:
                                AddTransactionScreenOperations.editQuickAction,
                            editingId: quickAction.id,
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
                    iconData: FontAwesomeIcons.heart,
                    color: kDeleteColor,
                    //? here i need to add the code to make the quick action favorite
                    onTap: () => {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
