// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/screens/home_screen/widgets/add_new_transaction_icon.dart';

import '../../../widgets/global/custom_card.dart';
import '../../../widgets/global/line.dart';
import '../../add_transaction_screen/add_transaction_screen.dart';
import 'summary_income_outcome.dart';

//* constants that matter to this widget only
const double height = 180;

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({
    Key? key,
  }) : super(key: key);

  void openTransactionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const AddTransactionScreen(
          addTransactionScreenOperations:
              AddTransactionScreenOperations.addTransaction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.symmetric(
        vertical: kDefaultVerticalPadding,
      ),
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SummaryIncomeOutcome(),
          ),
          Line(
            lineType: LineType.vertical,
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: AddNewTransactionIcon(
                  onTap: () => openTransactionScreen(context)),
            ),
          ),
        ],
      ),
    );
  }
}
