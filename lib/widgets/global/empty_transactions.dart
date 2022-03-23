import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class EmptyTransactions extends StatelessWidget {
  final String? title;
  final bool showImage;
  const EmptyTransactions({
    Key? key,
    this.title,
    this.showImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Text(
            title.toString(),
            style: TextStyle(
              color: kMainColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        if (showImage)
          SizedBox(
            width: 300,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/icons/empty.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
      ],
    );
  }
}
