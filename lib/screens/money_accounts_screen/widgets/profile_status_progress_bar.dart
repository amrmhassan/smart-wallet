import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../constants/sizes.dart';

class ProfileStatusProgressBar extends StatelessWidget {
  final double incomeRatio;
  final Color profileStatusColor;

  const ProfileStatusProgressBar({
    Key? key,
    required this.incomeRatio,
    required this.profileStatusColor,
  }) : super(key: key);

  String get incomeRatioString {
    return '${(incomeRatio * 100).toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income',
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
                // style: kSmallTextPrimaryColorStyle,
              ),
              Text(
                incomeRatioString,
                style: themeProvider
                    .getTextStyle(ThemeTextStyles.kSmallTextPrimaryColorStyle),
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding / 6,
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: themeProvider
                  .getThemeColor(ThemeColors.kInactiveColor)
                  .withOpacity(0.3),
            ),
            child: FractionallySizedBox(
                widthFactor: incomeRatio,
                child: Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: profileStatusColor,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
