// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/screens/add_transaction_screen/widgets/amount_viewer.dart';
import 'package:smart_wallet/screens/add_transaction_screen/widgets/choose_borrowing_profile.dart';
import 'package:smart_wallet/widgets/global/custom_card.dart';
import 'package:smart_wallet/widgets/global/stylized_text_field.dart';

class DebtController extends StatelessWidget {
  final double amount;
  final String borrowingProfileId;
  final TextEditingController debtTitleController;
  final Function(String profileId) setBorrowingProfileId;
  const DebtController({
    Key? key,
    required this.borrowingProfileId,
    required this.amount,
    required this.debtTitleController,
    required this.setBorrowingProfileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return CustomCard(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StylizedTextField(
                    controller: debtTitleController,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          themeProvider.getThemeColor(ThemeColors.kMainColor),
                    ),
                    maxLines: 1,
                    hintText: 'Enter a title',
                    onChanged: (value) {},
                    keyboardType: TextInputType.text,
                    textStyle: TextStyle(
                      color:
                          themeProvider.getThemeColor(ThemeColors.kMainColor),
                    ),
                    fillColor: themeProvider
                        .getThemeColor(ThemeColors.kTextFieldInputColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(kDefaultBorderRadius / 2),
                      borderSide: BorderSide(
                        color: themeProvider
                            .getThemeColor(ThemeColors.kMainBackgroundColor),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(kDefaultBorderRadius / 2),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: kDefaultPadding),
                AmountViewer(amount: amount),
              ],
            ),
          ),
          ChooseBorrowingProfile(
            borrowingProfileId: borrowingProfileId,
            setBorrowingProfileId: setBorrowingProfileId,
          ),
        ],
      ),
    );
  }
}
