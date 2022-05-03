import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/transactions_provider.dart';

import '../../../constants/sizes.dart';
import '../../../utils/general_utils.dart';

class TotalAmountInProfile extends StatelessWidget {
  const TotalAmountInProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalAmount = Provider.of<TransactionProvider>(context).totalMoney;
    var themeProvider = Provider.of<ThemeProvider>(context);

    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        'Total : ${doubleToString(totalAmount)} $currency',
        style: TextStyle(
          color: themeProvider.getThemeColor(ThemeColors.kMainColor),
          fontSize: kDefaultInfoTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
