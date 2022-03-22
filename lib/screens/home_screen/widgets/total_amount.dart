// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/transactions_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../utils/transactions_utils.dart';

class TotalAmountInProfile extends StatelessWidget {
  const TotalAmountInProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalAmount = Provider.of<TransactionProvider>(context).totalMoney;
    return Text(
      'Total : ${doubleToString(totalAmount)} \$',
      style: TextStyle(
        color: kMainColor,
        fontSize: kDefaultInfoTextSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
