// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/quick_action_model.dart';
import '../../../providers/quick_actions_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/transactions_utils.dart';
import '../../../widgets/global/empty_transactions.dart';

import '../../../constants/sizes.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import 'quick_action_card.dart';

class QuickActionsCardsGrid extends StatelessWidget {
  const QuickActionsCardsGrid({
    Key? key,
  }) : super(key: key);

  void openAddQuickActionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AddTransactionScreen(
          addTransactionScreenOperations:
              AddTransactionScreenOperations.addQuickAction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<QuickActionModel> quickActions =
        Provider.of<QuickActionsProvider>(context).getFavoriteQuickActions;
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.only(
          bottom: kCustomBottomNavBarHeight + kDefaultPadding / 4,
          right: kDefaultPadding / 4,
          left: kDefaultPadding / 4,
          top: kDefaultPadding / 4,
        ),
        child: quickActions.isEmpty
            ? Column(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () => openAddQuickActionScreen(context),
                    child: EmptyTransactions(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Favorite Quick Actions, Add one?',
                            style: themeProvider.getTextStyle(
                                ThemeTextStyles.kParagraphTextStyle),
                          ),
                        ],
                      ),
                      imagePath: 'assets/icons/box.png',
                    ),
                  ),
                ],
              )
            : NotificationListener<ScrollUpdateNotification>(
                onNotification: ((notification) {
                  double scrollingPosition = notification.metrics.pixels;
                  if (scrollingPosition > 50) {
                    //? here i will add the code to hide the the add quick action floating action button
                  } else {
                    //? here i will add the code to show the the add quick action floating action button

                  }
                  return true;
                }),
                child: GridView.builder(
                    clipBehavior: Clip.none,
                    //* this is so impressive for adding a different animation to the scrolling effect
                    physics: const BouncingScrollPhysics(),
                    //? SOLVED
                    //* this is a problem :: when making the clip none the cards overflow the grid and get out of it
                    //* when it is hards edges the shadow of the cards gets cut and look bad
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: kDefaultPadding / 2,
                      mainAxisSpacing: kDefaultPadding / 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: quickActions.length,
                    itemBuilder: (ctx, index) {
                      return QuickActionCard(
                        //* i tried 1.00 to convert it to a double
                        amount: quickActions[index].amount * 1.00,
                        title: quickActions[index].title,
                        description: quickActions[index].description,
                        transactionType: quickActions[index].transactionType,
                        onTap: () => showApplyQuickActionDialog(
                            context, quickActions[index]),
                      );
                    }),
              ),
      ),
    );
  }
}
