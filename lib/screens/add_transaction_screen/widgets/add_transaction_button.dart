import 'package:flutter/material.dart';

import '../../../themes/choose_color_theme.dart';

class AddTransactionButton extends StatelessWidget {
  final VoidCallback addTransaction;
  final String saveButtonText;
  const AddTransactionButton({
    Key? key,
    required this.addTransaction,
    required this.saveButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: ChooseColorTheme.kMainColor),
        onPressed: addTransaction,
        child: Text(
          saveButtonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
