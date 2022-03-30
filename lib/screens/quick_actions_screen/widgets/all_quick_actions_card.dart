// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../models/profile_model.dart';
import '../../../models/quick_action_model.dart';
import '../../../providers/profiles_provider.dart';
import '../../../providers/quick_actions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../../providers/transactions_provider.dart';
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
  Future<bool> deleteQuickAction(BuildContext context) async {
    bool confirmDelete = false;
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text('Delete Quick Action?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await Provider.of<QuickActionsProvider>(context,
                              listen: false)
                          .deleteQuickActions(quickAction.id);
                    } catch (error) {
                      showSnackBar(
                          context, error.toString(), SnackBarType.error);
                    }
                    confirmDelete = true;
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                ),
              ],
            ));
    return confirmDelete;
  }

  //* in this method i will apply the quick action and add the transaction by clicking on the quick action card
  void applyQuickAction(BuildContext context) async {
    //? the problem here is that each quick action will have an id , so we can't add the same quick action with the same id to be multiple transactions with the same id
    //? so i will make the add transaction provider decide the id of the newly added transaction

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Apply Transaction?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<TransactionProvider>(context, listen: false)
                    .addTransaction(
                  quickAction.title,
                  quickAction.description,
                  quickAction.amount,
                  quickAction.transactionType,
                  quickAction.profileId,
                );

                //* here i will edit the current active profile
                ProfileModel activeProfile =
                    Provider.of<ProfilesProvider>(context, listen: false)
                        .getActiveProfile;
                //* cheching the added transaction type and then update the profile depending on that

                if (quickAction.transactionType == TransactionType.income) {
                  //* if income then update income

                  await Provider.of<ProfilesProvider>(context, listen: false)
                      .editActiveProfile(
                          income: activeProfile.income + quickAction.amount);
                } else if (quickAction.transactionType ==
                    TransactionType.outcome) {
                  //* if outcome then update the outcome
                  await Provider.of<ProfilesProvider>(context, listen: false)
                      .editActiveProfile(
                          outcome: activeProfile.outcome + quickAction.amount);
                }
                showSnackBar(
                    context, 'Transaction Added', SnackBarType.success, true);
              } catch (error) {
                showSnackBar(
                    context, error.toString(), SnackBarType.error, true);
              }
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //* the main container of the card
    return Dismissible(
      direction: DismissDirection.endToStart,
      // onDismissed: (direction) => deleteQuickAction(context),
      confirmDismiss: (direction) => deleteQuickAction(context),
      background: QuickActionCardBackground(),
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
            onTap: () => applyQuickAction(context),
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
      padding: EdgeInsets.only(right: kDefaultPadding / 2),
      margin: const EdgeInsets.only(bottom: kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      ),
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: kDefaultIconSize,
      ),
    );
  }
}
