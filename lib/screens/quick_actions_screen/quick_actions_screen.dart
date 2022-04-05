import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../providers/quick_actions_provider.dart';
import '../../screens/quick_actions_screen/widgets/all_quick_actions_card.dart';
import '../../widgets/global/empty_transactions.dart';

import '../../constants/sizes.dart';
import '../../widgets/app_bar/my_app_bar.dart';
import '../add_transaction_screen/add_transaction_screen.dart';
import '../home_screen/widgets/background.dart';
import 'widgets/quick_actions_filter.dart';

class QuickActionsScreen extends StatefulWidget {
  static const String routeName = '/quick-actions-screen';
  const QuickActionsScreen({Key? key}) : super(key: key);

  @override
  State<QuickActionsScreen> createState() => _QuickActionsScreenState();
}

class _QuickActionsScreenState extends State<QuickActionsScreen> {
  @override
  Widget build(BuildContext context) {
    final quickActionsData = Provider.of<QuickActionsProvider>(context);
    final quickActions =
        quickActionsData.displayedQuickActions.reversed.toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const AddTransactionScreen(
                addTransactionScreenOperations:
                    AddTransactionScreenOperations.addQuickAction,
              ),
            ),
          );
        },
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.add,
          size: kDefaultIconSize,
        ),
      ),
      //* this is the drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          //* this is the background of the screen
          const Background(),

          SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Column(
                children: [
                  //* my custom app bar and the mainAppBar is equal to false for adding the back button and remove the menu icon(side bar opener)
                  const MyAppBar(
                    title: 'Quick Actions',
                  ),
                  //* space between the app bar and the next widget
                  const SizedBox(
                    height: 40,
                  ),
                  //* quick actions filter
                  const QuickActionsFilter(),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Expanded(
                    child: quickActions.isEmpty
                        ? EmptyTransactions(
                            imagePath: 'assets/icons/box.png',
                            trainling: Text(
                              'No Quick Actions Here',
                              style: kSmallTextOpaqueColorStyle,
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: quickActions.length,
                            itemBuilder: (ctx, index) => AllQuickActionsCard(
                              quickAction: quickActions[index],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
