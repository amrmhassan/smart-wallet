import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/screens/debts_screen/widgets/debts_card.dart';
import 'package:smart_wallet/screens/holder_screen/widgets/holder_screen.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/global/empty_transactions.dart';

import '../../constants/sizes.dart';
import '../../widgets/app_bar/my_app_bar.dart';
import '../add_transaction_screen/add_transaction_screen.dart';
import '../home_screen/widgets/background.dart';

class DebtsScreen extends StatefulWidget {
  static const String routeName = '/debts-screen';
  const DebtsScreen({Key? key}) : super(key: key);

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  void openAddDebtScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AddTransactionScreen(
          addTransactionScreenOperations:
              AddTransactionScreenOperations.addDebt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtsProvider>(context);

    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,

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
                  MyAppBar(
                    title: 'Debts',
                    rightIcon: AddElementButton(
                      onTap: () => openAddDebtScreen(context),
                    ),
                  ),
                  //* space between the app bar and the next widget
                  const SizedBox(
                    height: 40,
                  ),
                  //* quick actions filter
                  // const QuickActionsFilter(),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Expanded(
                    child: debtProvider.debts.isEmpty
                        ? EmptyTransactions(
                            title: Text(
                              'No Debts Yet',
                              style: themeProvider.getTextStyle(
                                  ThemeTextStyles.kSmallTextOpaqueColorStyle),
                            ),
                            imagePath: 'assets/icons/debt.png',
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: debtProvider.debts.length,
                            itemBuilder: (ctx, index) => DebtCard(
                              debtModel: debtProvider.debts[index],
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
