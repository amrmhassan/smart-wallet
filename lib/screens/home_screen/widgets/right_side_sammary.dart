import 'package:flutter/material.dart';

import '../../add_transaction_screen/add_transaction_screen.dart';
import 'add_new_transaction_icon.dart';

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
            child: Center(
              child: AddNewTransactionIcon(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const AddTransactionScreen(
                        addTransactionScreenOperations:
                            AddTransactionScreenOperations.addTransaction,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // SizedBox(height: 20),
          // Expanded(
          //   child: ConstrainedBox(
          //     constraints: BoxConstraints(maxWidth: 100),
          //     child: TotalAmountInProfile(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
