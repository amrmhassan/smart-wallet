// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/profile_details_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';

import '../../../constants/sizes.dart';
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
    var themeProvider = Provider.of<ThemeProvider>(context);

    return CustomCard(
      height: 200,
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
                  children: [
                    DatePickerButton(
                      dateType: DateTypes.startDate,
                    ),
                    Expanded(
                      child: Icon(
                        Icons.arrow_right_alt_sharp,
                        color:
                            themeProvider.getThemeColor(ThemeColors.kMainColor),
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
