import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';

class ChooseTransactionTypeButton extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;
  final TransactionType transactionType;

  const ChooseTransactionTypeButton({
    Key? key,
    required this.title,
    this.active = false,
    required this.transactionType,
    required this.onTap,
  }) : super(key: key);

  Color get backgroundColor {
    // if (transactionType == TransactionType.income) {
    //   return active
    //       ? themeProvider.getThemeColor(ThemeColors.kMainColor)
    //       : themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor);
    // } else if (transactionType == TransactionType.outcome) {
    //   return active
    //       ? themeProvider.getThemeColor(ThemeColors.kMainColor)
    //       : themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor);
    // } else {
    //   return active
    //       ? themeProvider.getThemeColor(ThemeColors.kMainColor)
    //       : themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor);
    // }

    return active
        ? themeProvider.getThemeColor(ThemeColors.kMainColor)
        : themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor);
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultHorizontalPadding / 1.5,
          vertical: kDefaultVerticalPadding / 3,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            kDefaultBorderRadius,
          ),
          border: Border.all(
            width: 1.5,
            color: active
                ? Colors.transparent
                : themeProvider.getThemeColor(ThemeColors.kCardBackgroundColor),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: active
                ? themeProvider.getThemeColor(ThemeColors.kMainBackgroundColor)
                : themeProvider.getThemeColor(ThemeColors.kMainColor),
          ),
        ),
      ),
    );
  }
}

//  active
//               ? themeProvider
//                   .getTextStyle(ThemeTextStyles.kSmallTextWhiteColorStyle)
//               : themeProvider
//                   .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),