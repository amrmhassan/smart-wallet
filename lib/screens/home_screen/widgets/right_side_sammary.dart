// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wallet_app/screens/add_transaction/add_transaction_screen.dart';

import 'add_new_transaction_icon.dart';
import 'total_amount.dart';

class RightSideSammary extends StatelessWidget {
  const RightSideSammary({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AddNewTransactionIcon(onTap: () {
              Navigator.pushNamed(context, AddTransactionScreen.routeName);
            }),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: TotalAmountInProfile(),
            ),
          ),
        ],
      ),
    );
  }
}
