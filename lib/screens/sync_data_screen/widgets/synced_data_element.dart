import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/theme_constants.dart';
import '../../../providers/theme_provider.dart';

class SyncedDataElement extends StatelessWidget {
  final String title;
  final int amount;
  const SyncedDataElement({
    Key? key,
    required this.amount,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: themeProvider.getTextStyle(
            ThemeTextStyles.kSmallTextPrimaryColorStyle,
          ),
        ),
        Text(
          amount.toString(),
          style: themeProvider.getTextStyle(
            ThemeTextStyles.kSmallTextPrimaryColorStyle,
          ),
        ),
      ],
    );
  }
}
