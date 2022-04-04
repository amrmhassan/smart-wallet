// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
        padding: EdgeInsets.only(
          left: kDefaultHorizontalPadding,
          right: kDefaultHorizontalPadding / 2,
        ),
        child: Row(
          children: [
            SummaryIncomeOutcome(),
          ],
        ),
      ),
    );
  }
}
