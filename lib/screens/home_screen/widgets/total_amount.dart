import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TotalAmountInProfile extends StatelessWidget {
  const TotalAmountInProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Total : 1,250 \$',
      style: TextStyle(
        color: kMainColor,
        fontSize: kDefaultInfoTextSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
