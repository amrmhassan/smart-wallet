import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/constants/globals.dart';
import '../../../providers/transactions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../utils/general_utils.dart';

class TotalAmountInProfile extends StatelessWidget {
  const TotalAmountInProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalAmount = Provider.of<TransactionProvider>(context).totalMoney;
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        'Total : ${doubleToString(totalAmount)} $currency',
        style: const TextStyle(
          color: kMainColor,
          fontSize: kDefaultInfoTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
