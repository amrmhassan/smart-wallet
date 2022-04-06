import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/colors.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';

import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../../constants/types.dart';
import '../../home_screen/widgets/summary_period_container.dart';
import 'date_picker_button.dart';
import 'summary_element.dart';

class ProfileSummaryStatistics extends StatelessWidget {
  final int profileAge;
  const ProfileSummaryStatistics({
    Key? key,
    required this.profileAge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var transactionData = Provider.of<ProfileDetailsProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
        boxShadow: [
          kDefaultBoxShadow,
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryElement(
                  title: 'Income(${transactionData.incomeTransactions.length})',
                  amount: transactionData.totalIncome,
                  transactionType: TransactionType.income,
                ),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
                SummaryElement(
                  title:
                      'Outcome(${transactionData.outcomeTransactions.length})',
                  amount: transactionData.totalOutcome,
                  transactionType: TransactionType.outcome,
                ),
                const SizedBox(
                  height: kDefaultPadding / 2,
                ),
                SummaryElement(
                  title: 'Total',
                  amount: transactionData.totalMoney,
                ),
                const Expanded(
                  child: SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    DatePickerButton(
                      dateType: DateTypes.startDate,
                    ),
                    Expanded(
                      child: Icon(
                        Icons.arrow_right_alt_sharp,
                        color: kMainColor,
                        size: kDefaultIconSize,
                      ),
                    ),
                    DatePickerButton(
                      dateType: DateTypes.endDate,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          SammeryPeriodContainer(
            profileAge: profileAge,
          ),
        ],
      ),
    );
  }
}
