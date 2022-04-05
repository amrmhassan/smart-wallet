import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/globals.dart';
import 'package:wallet_app/helpers/responsive.dart';
import 'package:wallet_app/utils/transactions_utils.dart';
import '../../../models/quick_action_model.dart';
import '../../../providers/quick_actions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../../utils/general_utils.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import '../../../widgets/global/card_action_button.dart';

class AllQuickActionsCard extends StatelessWidget {
  final QuickActionModel quickAction;
  const AllQuickActionsCard({
    Key? key,
    required this.quickAction,
  }) : super(key: key);

//* this function will show a dialog to delete and after confirming deleting it will be deleted
//* or if cancel was clicked the card will come back and won't be deleted

  Future<bool> showDeleteCustomDialog(BuildContext context) async {
    bool confirmDelete = false;
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Delete Quick Action?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          await Provider.of<QuickActionsProvider>(context, listen: false)
              .deleteQuickActions(quickAction.id);
        } catch (error) {
          showSnackBar(context, error.toString(), SnackBarType.error);
        }
        confirmDelete = true;
      },
    ).show();

    return confirmDelete;
  }

  @override
  Widget build(BuildContext context) {
    //* the main container of the card
    return Dismissible(
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) => deleteQuickAction(context),
      confirmDismiss: (direction) => showDeleteCustomDialog(context),
      background: const QuickActionCardBackground(),
      key: Key(quickAction.id),
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          boxShadow: [
            kCardBoxShadow,
          ],
        ),
        //* the row that hold the main components of the card, ( circular leading icon, title buttons etc...)
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => showApplyQuickActionDialog(context, quickAction),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultHorizontalPadding / 2,
                vertical: kDefaultVerticalPadding / 2,
              ),
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
                        color: quickAction.transactionType ==
                                TransactionType.income
                            ? kIncomeColor
                            : kOutcomeColor,
                      ),
                    ),
                    child: Icon(
                      quickAction.transactionType == TransactionType.income
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color:
                          quickAction.transactionType == TransactionType.income
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
                      SizedBox(
                        width: Responsive.getWidth(context) / 3,
                        child: Text(
                          quickAction.title,
                          style: kParagraphTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding / 4,
                      ),
                      //* price text widget
                      Text(
                        '${doubleToString(quickAction.amount)} $currency',
                        style: kSmallTextPrimaryColorStyle,
                      ),
                    ],
                  ),
                  Expanded(
                    //* the container of the actions button
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //* for opening the screen to edit the quick action
                        CardActionButton(
                          iconData: FontAwesomeIcons.pen,
                          color: kMainColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => AddTransactionScreen(
                                  addTransactionScreenOperations:
                                      AddTransactionScreenOperations
                                          .editQuickAction,
                                  editingId: quickAction.id,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: kDefaultPadding / 4,
                        ),
                        //* for making a quick action favorite
                        //* this consumer will provide the data for knowing if it is favorite or not
                        //* and the toggle favorite

                        CardActionButton(
                          iconData: quickAction.isFavorite
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: kDeleteColor,
                          //* this will toggle the favorite for each quick action
                          onTap: () async {
                            await Provider.of<QuickActionsProvider>(context,
                                    listen: false)
                                .toggleFavouriteQuickAction(quickAction.id);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuickActionCardBackground extends StatelessWidget {
  const QuickActionCardBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: kDefaultPadding / 2),
      margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: kDefaultIconSize,
      ),
    );
  }
}
