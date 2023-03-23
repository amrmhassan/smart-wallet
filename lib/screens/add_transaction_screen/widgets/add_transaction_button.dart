import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

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
    var themeProvider = Provider.of<ThemeProvider>(context);
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                themeProvider.getThemeColor(ThemeColors.kMainColor)),
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
