import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/globals.dart';

import '../../../constants/sizes.dart';
import '../../../providers/theme_provider.dart';

class ProfileTransactionsInfo extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  const ProfileTransactionsInfo({
    Key? key,
    required this.amount,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              currency,
              style: TextStyle(
                fontSize: 11,
                color: themeProvider.getThemeColor(ThemeColors.kMainColor),
              ),
            )
          ],
        ),
        const SizedBox(
          height: kDefaultPadding / 6,
        ),
        Text(
          title,
          style: themeProvider
              .getTextStyle(ThemeTextStyles.kSmallInActiveParagraphTextStyle),
        ),
      ],
    );
  }
}
