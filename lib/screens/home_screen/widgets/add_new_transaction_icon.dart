import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

class AddNewTransactionIcon extends StatelessWidget {
  final VoidCallback onTap;
  const AddNewTransactionIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 4,
          color: themeProvider.getThemeColor(ThemeColors.kMainColor),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            // padding: const EdgeInsets.all(
            //   kDefaultPadding / 3,
            // ),
            child: Icon(
              Icons.add,
              size: 45,
              color: themeProvider.getThemeColor(ThemeColors.kMainColor),
            ),
          ),
        ),
      ),
    );
  }
}
