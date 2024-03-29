// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:smart_wallet/constants/user_helpers_constants.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/user_helpers_provider.dart';
import 'package:smart_wallet/screens/quick_actions_screen/quick_actions_screen.dart';
import '../../../models/quick_action_model.dart';
import '../../../providers/quick_actions_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/transactions_utils.dart';
import '../../../widgets/global/empty_transactions.dart';

import '../../../constants/sizes.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import 'quick_action_card.dart';

class QuickActionsCardsGrid extends StatefulWidget {
  const QuickActionsCardsGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<QuickActionsCardsGrid> createState() => _QuickActionsCardsGridState();
}

class _QuickActionsCardsGridState extends State<QuickActionsCardsGrid> {
  // ScrollController scrollController = ScrollController();
  void openAddQuickActionScreen(BuildContext context) {
    var quickActions = Provider.of<QuickActionsProvider>(
      context,
      listen: false,
    ).quickActions;
    if (quickActions.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const AddTransactionScreen(
            addTransactionScreenOperations:
                AddTransactionScreenOperations.addQuickAction,
          ),
        ),
      );
    } else {
      Navigator.pushNamed(context, QuickActionsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<QuickActionModel> quickActions =
        Provider.of<QuickActionsProvider>(context).getFavoriteQuickActions;
    var themeProvider = Provider.of<ThemeProvider>(context);
    final generatedQuickActions = List.generate(
      quickActions.length,
      (index) => QuickActionCard(
        key: Key(quickActions[index].id),
        amount: quickActions[index].amount * 1.00,
        title: quickActions[index].title,
        description: quickActions[index].description,
        transactionType: quickActions[index].transactionType,
        onTap: () async {
          QuickActionModel q = quickActions[index];
          // an error here after changing the order and applying the quick action it apply the older quick action that was in it's place instead of the new quick Action
          return showApplyQuickActionDialog(
            context,
            QuickActionModel(
              id: q.id,
              title: q.title,
              description: q.description,
              amount: q.amount,
              createdAt: q.createdAt,
              transactionType: q.transactionType,
              profileId: q.profileId,
            ),
          );
        },
      ),
    );

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
                key: addQuickActionKey,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      openAddQuickActionScreen(context);

                      Provider.of<UserHelpersProvider>(context, listen: false)
                          .setActive(false);
                    },
                    child: EmptyTransactions(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Quick Actions, Click to add one.',
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
            //? this is the reorderable grid view
            : ReorderableBuilder(
                dragChildBoxDecoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.black12,
                      blurRadius: 15,
                    )
                  ],
                ),
                onReorder: (List<OrderUpdateEntity> orderUpdateEntities) async {
                  for (final orderUpdateEntity in orderUpdateEntities) {
                    //* this will run only one time on the updated quick action
                    final quickAction =
                        quickActions.removeAt(orderUpdateEntity.oldIndex);
                    quickActions.insert(
                        orderUpdateEntity.newIndex, quickAction);
                  }
                  await Provider.of<QuickActionsProvider>(context,
                          listen: false)
                      .updateFavoriteQuickActionsIndex(quickActions);
                  //? this line is very important(without it the quick actions won't change order if reordered)
                  setState(() {});
                },
                longPressDelay: Duration(
                  milliseconds: 200,
                ),
                builder: (children) {
                  return GridView(
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: kDefaultPadding / 2,
                      mainAxisSpacing: kDefaultPadding / 2,
                      childAspectRatio: 1,
                    ),
                    // controller: scrollController,
                    children: children,
                  );
                },
                children: generatedQuickActions,
              ),
      ),
    );
  }
}

//? old widget backup
// import 'package:flutter/material.dart';
// import 'package:reorderable_grid_view/reorderable_grid_view.dart';
// import 'package:smart_wallet/constants/theme_constants.dart';
// import 'package:provider/provider.dart';
// import '../../../models/quick_action_model.dart';
// import '../../../providers/quick_actions_provider.dart';
// import '../../../providers/theme_provider.dart';
// import '../../../utils/transactions_utils.dart';
// import '../../../widgets/global/empty_transactions.dart';

// import '../../../constants/sizes.dart';
// import '../../add_transaction_screen/add_transaction_screen.dart';
// import 'quick_action_card.dart';

// class QuickActionsCardsGrid extends StatelessWidget {
//   const QuickActionsCardsGrid({
//     Key? key,
//   }) : super(key: key);

//   void openAddQuickActionScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (ctx) => const AddTransactionScreen(
//           addTransactionScreenOperations:
//               AddTransactionScreenOperations.addQuickAction,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<QuickActionModel> quickActions =
//         Provider.of<QuickActionsProvider>(context).getFavoriteQuickActions;
//     var themeProvider = Provider.of<ThemeProvider>(context);

//     return Expanded(
//       child: Container(
//         clipBehavior: Clip.hardEdge,
//         decoration: const BoxDecoration(),
//         padding: const EdgeInsets.only(
//           bottom: kCustomBottomNavBarHeight + kDefaultPadding / 4,
//           right: kDefaultPadding / 4,
//           left: kDefaultPadding / 4,
//           top: kDefaultPadding / 4,
//         ),
//         child: quickActions.isEmpty
//             ? Column(
//                 children: [
//                   InkWell(
//                     splashColor: Colors.transparent,
//                     overlayColor: MaterialStateProperty.all(Colors.transparent),
//                     onTap: () => openAddQuickActionScreen(context),
//                     child: EmptyTransactions(
//                       title: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'No Favorite Quick Actions, Add one?',
//                             style: themeProvider.getTextStyle(
//                                 ThemeTextStyles.kParagraphTextStyle),
//                           ),
//                         ],
//                       ),
//                       imagePath: 'assets/icons/box.png',
//                     ),
//                   ),
//                 ],
//               )
//             : NotificationListener<ScrollUpdateNotification>(
//                 onNotification: ((notification) {
//                   double scrollingPosition = notification.metrics.pixels;
//                   if (scrollingPosition > 50) {
//                     //? here i will add the code to hide the the add quick action floating action button
//                   } else {
//                     //? here i will add the code to show the the add quick action floating action button

//                   }
//                   return true;
//                 }),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: ReorderableGridView.builder(
//                     clipBehavior: Clip.none,
//                     physics: const BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     //* this is so impressive for adding a different animation to the scrolling effect
//                     //? SOLVED
//                     //* this is a problem :: when making the clip none the cards overflow the grid and get out of it
//                     //* when it is hards edges the shadow of the cards gets cut and look bad
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: kDefaultPadding / 2,
//                       mainAxisSpacing: kDefaultPadding / 2,
//                       childAspectRatio: 1,
//                     ),
//                     itemCount: quickActions.length,
//                     itemBuilder: (ctx, index) {
//                       return QuickActionCard(
//                         key: Key(index.toString()),
//                         //* i tried 1.00 to convert it to a double
//                         amount: quickActions[index].amount * 1.00,
//                         title: quickActions[index].title,
//                         description: quickActions[index].description,
//                         transactionType: quickActions[index].transactionType,
//                         onTap: () => showApplyQuickActionDialog(
//                             context, quickActions[index]),
//                       );
//                     },
//                     onReorder: (int oldIndex, int newIndex) {
//                       print('oldIndex ' + oldIndex.toString());
//                       print('newIndex ' + newIndex.toString());
//                     },
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
