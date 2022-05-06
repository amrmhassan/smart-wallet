import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/sizes.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/utils/general_utils.dart';

class AmountViewer extends StatelessWidget {
  const AmountViewer({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final double amount;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
      decoration: BoxDecoration(
        color: themeProvider.getThemeColor(ThemeColors.kTextFieldInputColor),
        borderRadius: BorderRadius.circular(kDefaultBorderRadius / 2),
      ),
      //* price text field
      child: FittedBox(
        child: Text(
          doubleToString(amount),
          style: themeProvider.getTextStyle(ThemeTextStyles.kCalcTextStyle),
        ),
      ),
    );
  }
}
