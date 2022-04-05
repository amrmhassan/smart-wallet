import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import 'summary_income_outcome.dart';

class LeftSideSummary extends StatelessWidget {
  const LeftSideSummary({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.only(
          left: kDefaultHorizontalPadding,
          right: kDefaultHorizontalPadding / 2,
        ),
        child: Row(
          children: const [
            SummaryIncomeOutcome(),
          ],
        ),
      ),
    );
  }
}
