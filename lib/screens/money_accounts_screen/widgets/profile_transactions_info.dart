import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/globals.dart';

import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

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
            const Text(
              currency,
              style: TextStyle(
                fontSize: 11,
                color: Colors.black45,
              ),
            )
          ],
        ),
        const SizedBox(
          height: kDefaultPadding / 6,
        ),
        Text(
          title,
          style: kSmallInActiveParagraphTextStyle,
        ),
      ],
    );
  }
}
